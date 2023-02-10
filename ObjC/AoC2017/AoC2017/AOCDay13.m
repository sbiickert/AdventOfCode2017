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
	result.part2 = [self solvePartTwo: scanners];
	
	return result;
}

- (NSString *)solvePartOne:(NSDictionary<NSNumber *, NSNumber *> *)scanners {
	NSInteger totalSeverity = [self sendPacket:scanners withDelay:0];
	return [NSString stringWithFormat:@"%ld", totalSeverity];
}

- (NSString *)solvePartTwo:(NSDictionary<NSNumber *, NSNumber *> *)scanners {
	NSInteger totalSeverity = 1;
	NSInteger delay = -1;
	
	while (totalSeverity > 0) {
		delay++;
		totalSeverity = [self sendPacket:scanners withDelay:delay];
		if (delay % 100000 == 0) {
			NSLog(@"%ld",  delay);
		}
	}
	
	return [NSString stringWithFormat:@"%ld", delay];
}

- (NSInteger)sendPacket:(NSDictionary<NSNumber *, NSNumber *> *)scanners
			  withDelay:(NSInteger)delay
{
	NSInteger totalSeverity = 0;
	
	for (NSNumber *key in scanners.allKeys) {
		NSInteger depth = key.integerValue + delay;
		NSInteger range = scanners[key].integerValue;
		// 2 -> 2, 3 -> 4, 4 -> 6, 5 -> 8
		NSInteger atZeroEvery = (range - 1) * 2;
		if (depth % atZeroEvery == 0) {
			NSInteger severity = depth * range;
			totalSeverity += severity;
		}
		if (delay > 0 && totalSeverity > 0) {
			break;
		}
	}
	return totalSeverity;
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
