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

	NSArray<NSDictionary *> *moves = [self parseMoves:input[0]];
	
	result.part1 = [self solvePartOne: programs moves:moves];
	result.part2 = [self solvePartTwo: programs moves:moves];
	
	return result;
}

- (NSString *)solvePartOne:(NSArray<NSString *> *)programs moves:(NSArray<NSDictionary *> *)moves {
	return [self dance:programs moves:moves iterations:1];
}

- (NSString *)solvePartTwo:(NSArray<NSString *> *)programs moves:(NSArray<NSDictionary *> *)moves {
//	return [self dance:programs moves:moves iterations:100];
	return [self dance:programs moves:moves iterations:1000000000]; // 1 billion
}

- (NSString *)dance:(NSArray<NSString *> *)immutablePrograms moves:(NSArray<NSDictionary *> *)moves iterations:(int)count
{
	NSMutableArray<NSString *> *programs = [immutablePrograms mutableCopy];
	//NSMutableDictionary<NSString *, NSNumber *> *history = [NSMutableDictionary dictionary];
	NSString *joined;
	
	for (int i = 0; i < count; i++) {
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
		
//		if ([history objectForKey:joined] != nil) {
//			NSLog(@"%@ repeated. First seen at %@, now at %d", joined, [history objectForKey:joined], i);
//		}
		if (i % 1000 == 0) {
			NSLog(@"%d", i);
		}
	}
	return joined;
}

- (void)spin:(NSMutableArray<NSString *> *)programs size:(int)size
{
	NSRange r = NSMakeRange(programs.count-size, size);
	NSIndexSet *iset = [NSIndexSet indexSetWithIndexesInRange:r];
	id temp = [programs objectsAtIndexes:iset];
	[programs removeObjectsAtIndexes:iset];
	
	r = NSMakeRange(0, size);
	iset = [NSIndexSet indexSetWithIndexesInRange:r];
	[programs insertObjects:temp atIndexes:iset];
	
//	for (int i = 0; i < size; i++) {
//		NSString *program = [programs lastObject];
//		[programs removeLastObject];
//		[programs insertObject:program atIndex:0];
//	}
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
