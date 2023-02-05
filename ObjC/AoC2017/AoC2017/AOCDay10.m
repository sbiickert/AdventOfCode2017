//
//  AOCDay10.m
//  AoC2017
//

#import <Foundation/Foundation.h>
#import "AOCDay10.h"
#import "AOCStrings.h"

@implementation AOCDay10

- (AOCDay10 *)init {
	self = [super initWithDay:10 name:@"Knot Hash"];
	return self;
}

- (struct AOCResult)solveInputIndex:(int)index inFile:(NSString *)filename {
	struct AOCResult result = [super solveInputIndex:index inFile:filename];
	
	NSArray<NSString *> *input = [AOCInput readGroupedInputFile:filename atIndex:index];
	
	
	result.part1 = [self solvePartOne: input[0]];
	
	// Tests
//	[[self solvePartTwo:@""] println];
//	[[self solvePartTwo:@"AoC 2017"] println];
//	[[self solvePartTwo:@"1,2,3"] println];
//	[[self solvePartTwo:@"1,2,4"] println];

	result.part2 = [self solvePartTwo: input[0]];
	
	return result;
}

- (NSString *)solvePartOne:(NSString *)input {
	NSArray<NSNumber *> *lengths = [[input componentsSeparatedByString:@","] valueForKey:@"integerValue"];
	NSMutableArray<NSNumber *> *list = [NSMutableArray array];
	for (int i = 0; i < ((lengths.count == 4) ? 5 : 256); i++) {
		[list addObject:@(i)];
	}
	
	NSInteger skipSize = 0;
	NSInteger position = 0;
	
	[self knotHashIn:list lengths:lengths position:&position skipSize:&skipSize];
	
	NSInteger productOfFirstTwo = list[0].intValue * list[1].intValue; // 10920 too high
	
	return [NSString stringWithFormat:@"%ld", productOfFirstTwo];
}


- (NSString *)solvePartTwo:(NSString *)input {
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
