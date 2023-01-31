//
//  AOCDay<##>.h
//  AoC2017
//
//  Created by Simon Biickert on 2023-01-28.
//

#import "AOCSolution.h"
#import "AOCInput.h"

@interface AOCDay<##> : AOCSolution

@end



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
