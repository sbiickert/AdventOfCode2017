//
//  AOCDay02.m
//  AoC2017
//

#import <Foundation/Foundation.h>
#import "AOCDay02.h"
#include "limits.h"

@implementation AOCDay02

- (AOCDay02 *)init {
	self = [super initWithDay:2 name:@"Corruption Checksum"];
	return self;
}

- (struct AOCResult)solveInputIndex:(int)index inFile:(NSString *)filename {
	struct AOCResult result = [super solveInputIndex:index inFile:filename];
	
	NSArray<NSString *> *input = [AOCInput readGroupedInputFile:filename atIndex:index];
	
	result.part1 = [self solvePartOne: input];
	result.part2 = [self solvePartTwo: [input objectAtIndex:0]];
	
	return result;
}

- (NSString *)solvePartOne:(NSArray<NSString *> *)input {
	int sum = 0;
	for (NSString *line in input) {
		NSArray<NSString *> *numStrings = [line componentsSeparatedByString:@"\t"];
		sum += [self rowDifference:numStrings];
	}
	return [NSString stringWithFormat:@"%d", sum];
}

- (NSString *)solvePartTwo:(NSString *)input {
	
	return @"World";
}

- (int)rowDifference:(NSArray<NSString *> *)values {
	int xmax = -INT_MAX;
	int xmin = INT_MAX;
	for (NSString *str in values) {
		int x = [str intValue];
		if (x < xmin) xmin = x;
		if (x > xmax) xmax = x;
	}
	return xmax - xmin;
}

@end
