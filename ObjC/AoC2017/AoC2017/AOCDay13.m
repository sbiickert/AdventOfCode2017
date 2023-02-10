//
//  AOCDay13.m
//  AoC2017
//

#import <Foundation/Foundation.h>
#import "AOCDay13.h"

@implementation AOCDay13

- (AOCDay13 *)init {
	self = [super initWithDay:13 name:@"Packet Scanners"];
	return self;
}

- (struct AOCResult)solveInputIndex:(int)index inFile:(NSString *)filename {
	struct AOCResult result = [super solveInputIndex:index inFile:filename];
	
	NSArray<NSString *> *input = [AOCInput readGroupedInputFile:filename atIndex:index];
	
	NSDictionary<NSNumber *, NSNumber *> *scanners = [self parseInput:input];
	
	result.part1 = [self solvePartOne: scanners];
	result.part2 = [self solvePartTwo: input];
	
	return result;
}

- (NSString *)solvePartOne:(NSDictionary<NSNumber *, NSNumber *> *)scanners {
	NSInteger totalSeverity = 0;
	for (NSNumber *key in scanners.allKeys) {
		NSInteger depth = key.integerValue;
		NSInteger range = scanners[key].integerValue;
		// 2 -> 2
		// 3 -> 4
		// 4 -> 6
		// 5 -> 8
		NSInteger atZeroEvery = (range - 1) * 2;
		if (depth % atZeroEvery == 0) {
			NSInteger severity = depth * range;
			totalSeverity += severity;
		}
	}
	return [NSString stringWithFormat:@"%ld", totalSeverity];
}

- (NSString *)solvePartTwo:(NSArray<NSString *> *)input {
	
	return @"World";
}

- (NSDictionary<NSNumber *, NSNumber *> *)parseInput:(NSArray<NSString *> *)input
{
	NSMutableDictionary<NSNumber *, NSNumber *> *result = [NSMutableDictionary dictionary];
	
	for (NSString *line in input) {
		NSArray<NSString *> *parts = [line componentsSeparatedByString:@": "];
		[result setObject: @(parts[1].integerValue) forKey:@(parts[0].integerValue)];
	}
	
	return result;
}

@end
