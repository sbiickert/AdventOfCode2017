//
//  AOCDay16.m
//  AoC2017
//

#import <Foundation/Foundation.h>
#import "AOCDay16.h"

@implementation AOCDay16

- (AOCDay16 *)init {
	self = [super initWithDay:16 name:@"Permutation Promenade"];
	return self;
}

- (struct AOCResult)solveInputIndex:(int)index inFile:(NSString *)filename {
	struct AOCResult result = [super solveInputIndex:index inFile:filename];
	
	NSArray<NSString *> *input = [AOCInput readGroupedInputFile:filename atIndex:index];
	
//	NSArray<NSString *> *programs = @[@"a",@"b",@"c",@"d",@"e"];
	NSArray<NSString *> *programs = @[@"a",@"b",@"c",@"d",
									  @"e",@"f",@"g",@"h",
									  @"i",@"j",@"k",@"l",
									  @"m",@"n",@"o",@"p",];

	NSArray<NSString *> *moves = [input[0] componentsSeparatedByString:@","];
	
	result.part1 = [self solvePartOne: programs moves:moves];
	result.part2 = [self solvePartTwo: input];
	
	return result;
}

- (NSString *)solvePartOne:(NSArray<NSString *> *)immutablePrograms moves:(NSArray<NSString *> *)moves {
	NSMutableArray<NSString *> *programs = [immutablePrograms mutableCopy];
	for (NSString *move in moves) {
		NSString *indexInfo = [move substringFromIndex:1];
		if ([move hasPrefix:@"s"]) {
			// spin: e.g. "s4"
			int size = [indexInfo intValue];
			[self spin:programs size:size];
		}
		else if ([move hasPrefix:@"x"]) {
			// exchange: e.g. "x5/6"
			NSArray<NSNumber *> *indexes = [[indexInfo componentsSeparatedByString:@"/"] valueForKey:@"integerValue"];
			[self exchange:programs position:indexes[0].intValue position:indexes[1].intValue];
		}
		else {
			// partner: e.g. "ph/o
			NSArray<NSString *> *names = [indexInfo componentsSeparatedByString:@"/"];
			[self partner:programs name:names[0] name:names[1]];
		}
	}
	return [programs componentsJoinedByString:@""];
}

- (NSString *)solvePartTwo:(NSArray<NSString *> *)input {
	
	return @"World";
}

- (void)spin:(NSMutableArray<NSString *> *)programs size:(int)size
{
	for (int i = 0; i < size; i++) {
		NSString *program = [programs lastObject];
		[programs removeLastObject];
		[programs insertObject:program atIndex:0];
	}
}

- (void)exchange:(NSMutableArray<NSString *> *)programs position:(int)p1 position:(int)p2
{
	NSString *program = [programs objectAtIndex:p1];
	[programs setObject:[programs objectAtIndex:p2] atIndexedSubscript:p1];
	[programs setObject:program atIndexedSubscript:p2];
}

- (void)partner:(NSMutableArray<NSString *> *)programs name:(NSString *)n1 name:(NSString *)n2
{
	int p1 = (int)[programs indexOfObject:n1];
	int p2 = (int)[programs indexOfObject:n2];
	[self exchange:programs position:p1 position:p2];
}

@end
