//
//  AOCDay05.m
//  AoC2017
//

#import <Foundation/Foundation.h>
#import "AOCDay.h"

@implementation AOCDay05

- (AOCDay05 *)init {
	self = [super initWithDay:5 name:@"A Maze of Twisty Trampolines, All Alike"];
	return self;
}

- (struct AOCResult)solveInputIndex:(int)index inFile:(NSString *)filename {
	struct AOCResult result = [super solveInputIndex:index inFile:filename];
	
	NSArray<NSString *> *input = [AOCInput readGroupedInputFile:filename atIndex:index];
	
	result.part1 = [self solvePartOne: input];
	result.part2 = [self solvePartTwo: input];
	
	return result;
}

- (NSString *)solvePartOne:(NSArray<NSString *> *)input {
	NSMutableArray<NSNumber *> *numbers = [[input valueForKey:@"integerValue"] mutableCopy];
	
	int ptr = 0;
	int step = 0;
	while (ptr >= 0 && ptr < numbers.count) {
		int next = ptr + numbers[ptr].intValue;
		[numbers setObject:@(numbers[ptr].intValue + 1) atIndexedSubscript:ptr];
		ptr = next;
		step++;
	}
	return [NSString stringWithFormat:@"%d", step];
}

- (NSString *)solvePartTwo:(NSArray<NSString *> *)input {
	NSMutableArray<NSNumber *> *numbers = [[input valueForKey:@"integerValue"] mutableCopy];
	
	int ptr = 0;
	int step = 0;
	while (ptr >= 0 && ptr < numbers.count) {
		int valueAtPtr = numbers[ptr].intValue;
		int next = ptr + valueAtPtr;
		if (valueAtPtr >= 3) {
			[numbers setObject:@(valueAtPtr - 1) atIndexedSubscript:ptr];
		}
		else {
			[numbers setObject:@(valueAtPtr + 1) atIndexedSubscript:ptr];
		}
		ptr = next;
		step++;
	}
	return [NSString stringWithFormat:@"%d", step];
}

@end
