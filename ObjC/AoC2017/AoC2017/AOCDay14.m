//
//  AOCDay14.m
//  AoC2017
//

#import <Foundation/Foundation.h>
#import "AOCDay.h"
#import "AOCStrings.h"
#import "AOCGrid2D.h"

@implementation AOCDay14

- (AOCDay14 *)init {
	self = [super initWithDay:14 name:@"Disk Defragmentation"];
	return self;
}

- (struct AOCResult)solveInputIndex:(int)index inFile:(NSString *)filename {
	struct AOCResult result = [super solveInputIndex:index inFile:filename];
	
	NSArray<NSString *> *input = [AOCInput readGroupedInputFile:filename atIndex:index];
	
	NSString *key = input[0];
	AOCGrid2D *disk = [self populateDisk:key];

	result.part1 = [self solvePartOne: disk];
	result.part2 = [self solvePartTwo: disk];
	
	return result;
}

- (NSString *)solvePartOne:(AOCGrid2D *)disk {
	NSInteger usedSquareCount = [disk coordsWithValue:@"1"].count;
	
	return [NSString stringWithFormat:@"%ld", usedSquareCount];
}

- (NSString *)solvePartTwo:(AOCGrid2D *)disk {
	// Find regions
	NSMutableSet<AOCCoord2D *> *unassigned = [NSMutableSet setWithArray:[disk coordsWithValue:@"1"]];
	
	int regionCount = 0;
	
	while (unassigned.count > 0) {
		// Start with any unassigned filled coord
		NSMutableArray<AOCCoord2D *> *toVisit = [NSMutableArray arrayWithObject: [unassigned anyObject]];
		AOCCoord2D *coord = [toVisit lastObject];
		[unassigned removeObject:coord];

		// Walk through adjacent coords, removing from unassigned
		while (coord != nil){
			[toVisit removeLastObject];
			
			NSArray<AOCCoord2D *> *adjacentFilled = [disk adjacentTo:coord withValue:@"1"];
			for (AOCCoord2D *adj in adjacentFilled) {
				if ([unassigned containsObject:adj]) {
					[toVisit insertObject:adj atIndex:0];
					[unassigned removeObject:adj];
				}
			}

			coord = [toVisit lastObject];
		}
		
		// Ran out of adjacent coords with @"1". Region's done.
		regionCount++;
	}
	
	return [NSString stringWithFormat:@"%d", regionCount];
}

- (AOCGrid2D *)populateDisk:(NSString *)key
{
	AOCGrid2D *disk = [[AOCGrid2D alloc] initWithDefault:@"0" adjacency:ROOK];
	
	for (int row = 0; row < 128; row++) {
		NSString *rowKey = [NSString stringWithFormat:@"%@-%d", key, row];
		NSString *hexRowHash = [self calcKnotHash:rowKey];
		NSArray<NSString *> *hexRowHashCharacters = [hexRowHash getAllCharacters];
		NSMutableArray<NSString *> *rowBinary = [NSMutableArray array];
		for (NSString *hexChar in hexRowHashCharacters) {
			int value = (int)strtol(hexChar.UTF8String, NULL, 16);
			[rowBinary addObject: [NSString binaryStringFromInteger:value width:4]];
		}
		NSString *joined = [rowBinary componentsJoinedByString:@""];
		NSArray<NSString *> *exploded = [joined getAllCharacters];
		for (int col = 0; col < exploded.count; col++) {
			if ([exploded[col] isEqualToString:@"1"]) {
				[disk setObject:@"1" atCoord:[AOCCoord2D x:col y:row]];
			}
		}
	}
	
	//[disk print];

	return disk;
}

// Implementation from Day 10
- (NSString *)calcKnotHash:(NSString *)input {
	NSMutableArray<NSNumber *> *lengths = [NSMutableArray array];
	for (int i = 0; i < input.length; i++) {
		[lengths addObject: @([input characterAtIndex:i])];
	}
	[lengths addObjectsFromArray:@[@17, @31, @73, @47, @23]];
	
	NSMutableArray<NSNumber *> *sparseHash = [NSMutableArray array];
	for (int i = 0; i < ((lengths.count == 4) ? 5 : 256); i++) {
		[sparseHash addObject:@(i)];
	}
	
	NSInteger skipSize = 0;
	NSInteger position = 0;
	
	for (int i = 0; i < 64; i++) {
		[self knotHashIn:sparseHash lengths:lengths position:&position skipSize:&skipSize];
	}
	
	NSArray<NSNumber *> *denseHash = [self denseHashFrom:sparseHash];
	NSMutableString *hexString = [NSMutableString string];

	for (NSNumber *number in denseHash) {
		[hexString appendFormat:@"%02x", number.intValue];
	}
		
	return hexString;
}


- (void)knotHashIn:(NSMutableArray<NSNumber *> *)array
		   lengths:(NSArray<NSNumber *> *)lengths
		  position:(NSInteger *)position
		  skipSize:(NSInteger *)skipSize
{
	for (NSNumber *length in lengths) {
		NSInteger end = *position + (length.integerValue - 1);
		[self reverseNumbersIn:array startIndex:*position endIndex:end];
		*position = (*position + length.integerValue + *skipSize) % array.count;
		*skipSize = *skipSize + 1;
		//NSLog(@"%@", list);
	}
}

- (void)reverseNumbersIn:(NSMutableArray<NSNumber *> *)array startIndex:(NSInteger)start endIndex:(NSInteger)end
{
	NSInteger length = end - start;
	end = end % array.count;
	NSInteger a = start;
	NSInteger b = end;
	for (int i = 0; i <= length / 2; i++) {
		NSNumber *temp = array[a];
		array[a] = array[b];
		array[b] = temp;
		a = (a + 1) % array.count;
		b = b - 1;
		while (b < 0) { b += array.count; }
	}
}

- (NSArray<NSNumber *> *)denseHashFrom:(NSArray<NSNumber *> *)sparseHash
{
	NSMutableArray *result = [NSMutableArray array];
	
	for (int block = 0; block < 16; block++) {
		NSInteger number = sparseHash[block*16].integerValue;
		for (int element = 1; element < 16; element++) {
			number = number ^ sparseHash[block*16+element].integerValue;
		}
		[result addObject:@(number)];
	}
	
	return result;
}


@end
