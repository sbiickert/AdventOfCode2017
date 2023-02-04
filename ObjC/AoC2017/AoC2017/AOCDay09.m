//
//  AOCDay09.m
//  AoC2017
//

#import <Foundation/Foundation.h>
#import "AOCDay09.h"
#import "AOCStrings.h"

static NSString *ignoreRegex = @"\\!.{1}";
static NSString *garbageRegex = @"<[^>]*>";

@implementation AOCDay09

- (AOCDay09 *)init {
	self = [super initWithDay:9 name:@"Stream Processing"];
	return self;
}

- (struct AOCResult)solveInputIndex:(int)index inFile:(NSString *)filename {
	struct AOCResult result = [super solveInputIndex:index inFile:filename];
	
	NSArray<NSString *> *input = [AOCInput readGroupedInputFile:filename atIndex:index];
	
	result.part1 = [self solvePartOne: input[0]];
	result.part2 = [self solvePartTwo: input];
	
	return result;
}

- (NSString *)solvePartOne:(NSString *)input {
	NSError *err;
	
	// Remove negations
	NSString *noNeg = [input stringByReplacingWithPattern:ignoreRegex withTemplate:@"" error:&err];
	
	// Remove garbage
	NSString *noGarbage = [noNeg stringByReplacingWithPattern:garbageRegex withTemplate:@"" error:&err];
	
	// Remove commas
	NSString *stream = [noGarbage stringByReplacingOccurrencesOfString:@"," withString:@""];
	
	int level = 0;
	int sum = 0;
	
	for (NSString *character in [stream getAllCharacters]) {
		if ([character isEqualToString:@"{"]) {
			level++;
			sum += level;
		}
		else if ([character isEqualToString:@"}"]) {
			level--;
		}
	}
	
	return [NSString stringWithFormat:@"%d", sum];
}

- (NSString *)solvePartTwo:(NSArray<NSString *> *)input {
	
	return @"World";
}

@end
