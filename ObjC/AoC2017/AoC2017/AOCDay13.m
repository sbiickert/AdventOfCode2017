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
	
	result.part1 = [self solvePartOne: input];
	result.part2 = [self solvePartTwo: input];
	
	return result;
}

- (NSString *)solvePartOne:(NSArray<NSString *> *)input {
	
	return @"Hello";
}

- (NSString *)solvePartTwo:(NSArray<NSString *> *)input {
	
	return @"World";
}

@end
