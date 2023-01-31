//
//  AOCDay04.m
//  AoC2017
//

#import <Foundation/Foundation.h>
#import "AOCDay04.h"
#import "AOCStrings.h"

@implementation AOCDay04

- (AOCDay04 *)init {
	self = [super initWithDay:4 name:@"High-Entropy Passphrases"];
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
	int validCount = 0;
	
	for (NSString *line in input) {
		if ([self noRepeatedWordsIn:line]) {
			validCount++;
		}
	}
	
	return [NSString stringWithFormat:@"%d", validCount];
}

- (NSString *)solvePartTwo:(NSArray<NSString *> *)input {
	int validCount = 0;
	
	for (NSString *line in input) {
		if ([self noRepeatedWordsIn:line] && [self noAnagramsIn:line]) {
			validCount++;
		}
	}
	
	return [NSString stringWithFormat:@"%d", validCount];
}

- (BOOL)noRepeatedWordsIn:(NSString *)phrase {
	NSArray<NSString *> *words = [phrase componentsSeparatedByString:@" "];
	NSSet<NSString *> *wordSet = [NSSet setWithArray:words];
	
	return [words count] == [wordSet count]; // NO if any duplicate words, b/c set will have fewer entries.
}

- (BOOL)noAnagramsIn:(NSString *)phrase {
	NSArray<NSString *> *words = [phrase componentsSeparatedByString:@" "];
	NSMutableArray<NSString *> *sortedLetterWords = [NSMutableArray array];

	for (NSString *word in words) {
		NSArray<NSString *> *letters = [word getAllCharacters];
		letters = [letters sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
		[sortedLetterWords addObject:[letters componentsJoinedByString:@""]];
	}
	NSSet<NSString *> *wordSet = [NSSet setWithArray:sortedLetterWords];

	return [words count] == [wordSet count]; // NO if any anagram matching, b/c set will have fewer entries.
}

@end
