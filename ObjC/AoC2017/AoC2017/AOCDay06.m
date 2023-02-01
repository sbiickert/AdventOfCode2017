//
//  AOCDay06.m
//  AoC2017
//

#import <Foundation/Foundation.h>
#import "AOCDay06.h"

@implementation AOCDay06

- (AOCDay06 *)init {
	self = [super initWithDay:6 name:@"Memory Reallocation"];
	return self;
}

- (struct AOCResult)solveInputIndex:(int)index inFile:(NSString *)filename {
	struct AOCResult result = [super solveInputIndex:index inFile:filename];
	
	NSArray<NSString *> *input = [AOCInput readGroupedInputFile:filename atIndex:index];
	
	result.part1 = [self solvePartOne: [input objectAtIndex:0]];
	result.part2 = [self solvePartTwo: input];
	
	return result;
}

- (NSString *)solvePartOne:(NSString *)input {
	NSMutableArray<NSNumber *> *banks = [[[input componentsSeparatedByString:@"\t"] valueForKey:@"integerValue"] mutableCopy];
	
	NSMutableSet<NSString *> *states = [NSMutableSet set];
	[states addObject:[banks componentsJoinedByString:@""]];
	
	int cycle = 0;
	while (YES) {
		int bank = [self indexOfFullestBank:banks];
		int ptr = bank;
		int blocks = [banks[bank] intValue];
		banks[bank] = @(0);
		while (blocks > 0) {
			ptr++;
			ptr = ptr % banks.count;
			banks[ptr] = @([banks[ptr] intValue] + 1);
			blocks--;
		}
		NSString *state = [banks componentsJoinedByString:@""];
		//NSLog(@"%@",state);
		cycle++;
		if ([states containsObject:state]) {
			break;
		}
		[states addObject:state];
	}
	
	return [NSString stringWithFormat:@"Returned to initial state after %d cycles", cycle];
}

- (int)indexOfFullestBank:(NSArray<NSNumber *> *)banks {
	int maxIndex = 0;
	for (int i = 1; i < banks.count; i++) {
		if (banks[i].intValue > banks[maxIndex].intValue) {
			maxIndex = i;
		}
	}
	return maxIndex;
}

- (NSString *)solvePartTwo:(NSArray<NSString *> *)input {
	
	return @"World";
}

@end
