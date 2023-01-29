//
//  AOCDay01.m
//  AoC2017
//
//  Created by Simon Biickert on 2023-01-27.
//

#import <Foundation/Foundation.h>
#import "AOCDay01.h"
#import "AOCStrings.h"

@implementation AOCDay01

- (AOCDay01 *)init {
	self = [super initWithDay:1 name:@"Inverse Captcha"];
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
	NSArray<NSString *> *chars = [input getAllCharacters];
	
	int sum = 0;
	for (int i = 0; i < chars.count - 1; i++) {
		if ([[chars objectAtIndex:i] isEqualToString:[chars objectAtIndex:i+1]]) {
			sum += [[chars objectAtIndex:i] integerValue];
		}
	}
	if ([[chars firstObject] isEqualToString:[chars lastObject]]) {
		sum += [[chars firstObject] integerValue];
	}

	return @(sum).stringValue;
}

- (NSString *)solvePartTwo:(NSString *)input {
	NSArray<NSString *> *chars = [input getAllCharacters];

	int sum = 0;
	int j = (int)(chars.count / 2);
	for (int i = 0; i < chars.count; i++) {
		if ([[chars objectAtIndex:i] isEqualToString:[chars objectAtIndex:j]]) {
			sum += [[chars objectAtIndex:i] integerValue];
		}
		if (++j >= chars.count) {
			j = 0;
		}
	}

	return @(sum).stringValue;
}
//
//-(NSArray<NSString *> *)getAllCharactersIn:(NSString *)source {
//	NSMutableArray *characters = [[NSMutableArray alloc] initWithCapacity:[source length]];
//	for (int i=0; i < [source length]; i++) {
//		NSString *ichar  = [NSString stringWithFormat:@"%c", [source characterAtIndex:i]];
//		[characters addObject:ichar];
//	}
//	return characters;
//}

@end
