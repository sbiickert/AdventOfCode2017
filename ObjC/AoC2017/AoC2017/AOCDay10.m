//
//  AOCDay10.m
//  AoC2017
//

#import <Foundation/Foundation.h>
#import "AOCDay10.h"

@implementation AOCDay10

- (AOCDay10 *)init {
	self = [super initWithDay:10 name:@"Knot Hash"];
	return self;
}

- (struct AOCResult)solveInputIndex:(int)index inFile:(NSString *)filename {
	struct AOCResult result = [super solveInputIndex:index inFile:filename];
	
	NSArray<NSString *> *input = [AOCInput readGroupedInputFile:filename atIndex:index];
	
	NSArray<NSNumber *> *lengths = [[input[0] componentsSeparatedByString:@", "] valueForKey:@"integerValue"];
	
	result.part1 = [self solvePartOne: lengths];
	result.part2 = [self solvePartTwo: input];
	
	return result;
}

- (NSString *)solvePartOne:(NSArray<NSNumber *> *)lengths {
	NSInteger skipSize = 0;
	NSInteger position = 0;
	NSMutableArray<NSNumber *> *list = [NSMutableArray array];
	
	for (int i = 0; i < ((lengths.count == 4) ? 5 : 256); i++) {
		[list addObject:@(i)];
	}
	
	for (NSNumber *length in lengths) {
		NSInteger end = position + (length.integerValue - 1);
		[self reverseNumbersIn:list startIndex:position endIndex:end];
		position = (position + length.integerValue + skipSize) % list.count;
		skipSize++;
		//NSLog(@"%@", list);
	}
	
	NSInteger productOfFirstTwo = list[0].intValue * list[1].intValue; // 10920 too high
	
	return [NSString stringWithFormat:@"%ld", productOfFirstTwo];
}

- (void)reverseNumbersIn:(NSMutableArray<NSNumber *> *)array startIndex:(NSInteger)start endIndex:(NSInteger)end {
	NSInteger length = end - start;
	end = end % array.count;
	NSInteger a = start;
	NSInteger b = end;
	for (int i = 0; i <= length / 2; i++) {
		NSNumber *temp = array[a];
		array[a] = array[b];
		array[b] = temp;
		a = (a + 1) % array.count;
		b = b - 1;
		while (b < 0) { b += array.count; }
	}
}

- (NSString *)solvePartTwo:(NSArray<NSString *> *)input {
	
	return @"World";
}

@end
