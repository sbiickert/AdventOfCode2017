//
//  AOCDay11.m
//  AoC2017
//

#import <Foundation/Foundation.h>
#import "AOCDay11.h"

@implementation AOCDay11

- (AOCDay11 *)init {
	self = [super initWithDay:11 name:@"Hex Ed"];
	return self;
}

- (struct AOCResult)solveInputIndex:(int)index inFile:(NSString *)filename {
	struct AOCResult result = [super solveInputIndex:index inFile:filename];
	
	NSArray<NSString *> *input = [AOCInput readGroupedInputFile:filename atIndex:index];
	
	NSArray<NSString *> *dirs = [input[0] componentsSeparatedByString:@","];

	result.part1 = [self solvePartOne: dirs];
	result.part2 = [self solvePartTwo: dirs];
	
	return result;
}

- (NSString *)solvePartOne:(NSArray<NSString *> *)dirs {
	NSMutableDictionary<NSString *, NSNumber *> *counts = [self countDirections:dirs];
	return [NSString stringWithFormat:@"%ld", [self measureDistance:counts]];
}

- (NSString *)solvePartTwo:(NSArray<NSString *> *)dirs {
	NSMutableDictionary<NSString *, NSNumber *> *counts = [self countDirections:@[]]; // array of zeros
	NSInteger maxDistance = 0;
	
	for (NSString *dir in dirs) {
		counts[dir] = @(counts[dir].integerValue + 1); // Add 1 to the count for this direction
		NSInteger distance = [self measureDistance:counts];
		maxDistance = MAX(maxDistance, distance);
	}
	
	return [NSString stringWithFormat:@"%ld", maxDistance];
}

- (NSMutableDictionary<NSString *, NSNumber *> *)countDirections:(NSArray<NSString *> *)dirs
{
	// Organize counts of directions
	NSMutableDictionary<NSString *, NSNumber *> *counts = [NSMutableDictionary dictionary];
	NSArray<NSString *> *filtered;
	for (NSString *direction in @[@"n", @"ne", @"se", @"s", @"sw", @"nw"]) {
		filtered = [dirs filteredArrayUsingPredicate:
					[NSPredicate predicateWithFormat:@"SELF = %@", direction]];
		counts[direction] = @(filtered.count);
	}
	return counts;
}

- (NSInteger)measureDistance:(NSMutableDictionary<NSString *, NSNumber *> *)counts
{
	// Opposite directions cancel
	[self cancelDirection:@"n" withDirection:@"s" inDict:counts];
	[self cancelDirection:@"nw" withDirection:@"se" inDict:counts];
	[self cancelDirection:@"ne" withDirection:@"sw" inDict:counts];

	// These directions add
	[self addDirection:@"ne" andDirection:@"s" toDirection:@"se" inDict:counts];
	[self addDirection:@"nw" andDirection:@"s" toDirection:@"sw" inDict:counts];
	[self addDirection:@"se" andDirection:@"n" toDirection:@"ne" inDict:counts];
	[self addDirection:@"sw" andDirection:@"n" toDirection:@"nw" inDict:counts];
	[self addDirection:@"nw" andDirection:@"ne" toDirection:@"n" inDict:counts];
	[self addDirection:@"sw" andDirection:@"se" toDirection:@"s" inDict:counts];

	// The total of all counts should be the distance to the child process
	NSInteger sum = 0;
	for (NSNumber *count in counts.allValues) {
		sum += count.intValue;
	}
	return sum;
}

- (void)cancelDirection:(NSString *)dir1
		  withDirection:(NSString *)dir2
				 inDict:(NSMutableDictionary<NSString *, NSNumber *> *)counts
{
	int minimum = MIN(counts[dir1].intValue, counts[dir2].intValue);
	counts[dir1] = @(counts[dir1].intValue - minimum);
	counts[dir2] = @(counts[dir2].intValue - minimum);
}

- (void)addDirection:(NSString *)dir1
		andDirection:(NSString *)dir2
		 toDirection:(NSString *)result
			  inDict:(NSMutableDictionary<NSString *, NSNumber *> *)counts
{
	int minimum = MIN(counts[dir1].intValue, counts[dir2].intValue);
	counts[dir1] = @(counts[dir1].intValue - minimum);
	counts[dir2] = @(counts[dir2].intValue - minimum);
	counts[result] = @(counts[result].intValue + minimum);
}

@end
