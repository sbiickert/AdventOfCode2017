//
//  AOCDay14.m
//  AoC2017
//

#import <Foundation/Foundation.h>
#import "AOCDay14.h"
#import "AOCStrings.h"

@implementation AOCDay14

- (AOCDay14 *)init {
	self = [super initWithDay:14 name:@"Disk Defragmentation"];
	return self;
}

- (struct AOCResult)solveInputIndex:(int)index inFile:(NSString *)filename {
	struct AOCResult result = [super solveInputIndex:index inFile:filename];
	
	NSArray<NSString *> *input = [AOCInput readGroupedInputFile:filename atIndex:index];
	
	NSString *key = input[0];

	result.part1 = [self solvePartOne: key];
	result.part2 = [self solvePartTwo: input];
	
	return result;
}

- (NSString *)solvePartOne:(NSString *)key {
	NSInteger usedSquareCount = 0;
	
	for (int i = 0; i < 128; i++) {
		NSString *rowKey = [NSString stringWithFormat:@"%@-%d", key, i];
		NSString *hexRowHash = [self calcKnotHash:rowKey];
		NSArray<NSString *> *hexRowHashCharacters = [hexRowHash getAllCharacters];
		//[hexRowHash println];
		//NSMutableArray<NSString *> *rowBinary = [NSMutableArray array];
		for (NSString *hexChar in hexRowHashCharacters) {
			int value = (int)strtol(hexChar.UTF8String, NULL, 16);
			NSString *binary = [NSString binaryStringFromInteger:value width:4];
			for (NSString *binaryChar in [binary getAllCharacters]) {
				if ([binaryChar isEqualToString:@"1"]) {
					usedSquareCount++;
				}
			}
			//[rowBinary addObject: [NSString binaryStringFromInteger:value width:4]];
		}
		//[[rowBinary componentsJoinedByString:@""] println];
	}
	
	return [NSString stringWithFormat:@"%ld", usedSquareCount];
}

- (NSString *)solvePartTwo:(NSArray<NSString *> *)input {
	
	return @"World";
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
