//
//  AOCDay<##>.m
//  AoC2017
//

#import <Foundation/Foundation.h>
#import "AOCDay<##>.h"

@implementation AOCDay<##>

- (AOCDay<##> *)init {
	self = [super initWithDay:<##> name:@"<##>"];
	return self;
}

- (struct AOCResult)solveInputIndex:(int)index inFile:(NSString *)filename {
	struct AOCResult result = [super solveInputIndex:index inFile:filename];
	
	NSArray<NSString *> *input = [AOCInput readGroupedInputFile:filename atIndex:index];
	
	result.part1 = [self solvePartOne: [input objectAtIndex:0]];
	result.part2 = [self solvePartTwo: [input objectAtIndex:0]];
	
	return result;
}

- (NSString *)solvePartOne:(NSString *)input {
	
	return @"Hello";
}

- (NSString *)solvePartTwo:(NSString *)input {
	
	return @"World";
}

@end
