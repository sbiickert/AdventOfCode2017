//
//  AOCDay16.m
//  AoC2017
//

#import <Foundation/Foundation.h>
#import "AOCDay16.h"
#import "AOCStrings.h"

@implementation AOCDay16

- (AOCDay16 *)init {
	self = [super initWithDay:16 name:@"Permutation Promenade"];
	return self;
}

- (struct AOCResult)solveInputIndex:(int)index inFile:(NSString *)filename {
	struct AOCResult result = [super solveInputIndex:index inFile:filename];
	
	NSArray<NSString *> *input = [AOCInput readGroupedInputFile:filename atIndex:index];

	NSArray<NSDictionary *> *moves = [self parseMoves:input[0]];

	NSArray<NSString *> *programs;
	if (moves.count < 10) {
		programs = @[@"a",@"b",@"c",@"d",@"e"];
	}
	else {
		programs = @[@"a",@"b",@"c",@"d",
					 @"e",@"f",@"g",@"h",
					 @"i",@"j",@"k",@"l",
					 @"m",@"n",@"o",@"p",];
	}
	
	result.part1 = [self solvePartOne: programs moves:moves];
	result.part2 = [self solvePartTwo: programs moves:moves];
	
	return result;
}

- (NSString *)solvePartOne:(NSArray<NSString *> *)programs moves:(NSArray<NSDictionary *> *)moves {
	return [self dance:programs moves:moves iterations:1];
}

- (NSString *)solvePartTwo:(NSArray<NSString *> *)programs moves:(NSArray<NSDictionary *> *)moves {
	return [self dance:programs moves:moves iterations:1000000000];
}

- (NSString *)dance:(NSArray<NSString *> *)immutablePrograms moves:(NSArray<NSDictionary *> *)moves iterations:(int)count
{
	NSMutableArray<NSString *> *programs = [immutablePrograms mutableCopy];
	NSString *joined = [programs componentsJoinedByString:@""];
	NSMutableDictionary<NSString *, NSNumber *> *history = [NSMutableDictionary dictionary];
	history[joined] = @(0);
	
	for (int i = 1; i <= count; i++) {
		for (NSDictionary *move in moves) {
			if ([move[@"type"] isEqualToString:@"spin"]) {
				[self spin:programs size:[move[@"size"] intValue]];
			}
			else if ([move[@"type"] isEqualToString:@"exchange"]) {
				[self exchange:programs position:[move[@"p1"] intValue] position:[move[@"p2"] intValue]];
			}
			else {
				[self partner:programs name:move[@"n1"] name:move[@"n2"]];
			}
		}
		
		joined = [programs componentsJoinedByString:@""];
		if ([history objectForKey:joined] != nil) {
			//NSLog(@"Pattern %@ repeated at %i. First seen at %@", joined, i, history[joined]);
			int targetIndex = count % i;
			NSString *projected = [history allKeysForObject:@(targetIndex)].firstObject;
			return projected;
		}
		history[joined] = @(i);
		//[[NSString stringWithFormat:@"%d: %@", i, joined] println];
	}
	return joined;
}

- (void)spin:(NSMutableArray<NSString *> *)programs size:(int)size
{
	// Doing it this way means only moving memory once per spin instead of several remove/inserts per spin
	NSRange r = NSMakeRange(programs.count-size, size);
	NSIndexSet *iset = [NSIndexSet indexSetWithIndexesInRange:r];
	id temp = [programs objectsAtIndexes:iset];
	[programs removeObjectsAtIndexes:iset];
	
	r = NSMakeRange(0, size);
	iset = [NSIndexSet indexSetWithIndexesInRange:r];
	[programs insertObjects:temp atIndexes:iset];
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

- (NSArray<NSDictionary *> *)parseMoves:(NSString *)input
{
	NSArray<NSString *> *movesDefinitions = [input componentsSeparatedByString:@","];
	NSMutableArray<NSDictionary *> *moves = [NSMutableArray array];
	
	for (NSString *defn in movesDefinitions) {
		NSString *indexInfo = [defn substringFromIndex:1];
		if ([defn hasPrefix:@"s"]) {
			// spin: e.g. "s4"
			int size = [indexInfo intValue];
			[moves addObject:@{ @"type": @"spin", @"size": @(size)}];
		}
		else if ([defn hasPrefix:@"x"]) {
			// exchange: e.g. "x5/6"
			NSArray<NSNumber *> *indexes = [[indexInfo componentsSeparatedByString:@"/"] valueForKey:@"integerValue"];
			[moves addObject:@{ @"type": @"exchange", @"p1": indexes[0], @"p2": indexes[1]}];
		}
		else {
			// partner: e.g. "ph/o
			NSArray<NSString *> *names = [indexInfo componentsSeparatedByString:@"/"];
			[moves addObject:@{ @"type": @"partner", @"n1": names[0], @"n2": names[1]}];
		}
	}
	
	return moves;
}

@end
