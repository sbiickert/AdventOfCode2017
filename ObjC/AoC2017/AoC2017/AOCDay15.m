//
//  AOCDay15.m
//  AoC2017
//

#import <Foundation/Foundation.h>
#import "AOCDay15.h"

static NSInteger A_FACTOR = 16807;
static NSInteger B_FACTOR = 48271;

@interface A15Generator : NSObject

+ (BOOL)value:(NSInteger)valA matches:(NSInteger)valB;

- (A15Generator *)initFactor:(NSInteger)factor value:(NSInteger)value;

@property (readonly) NSInteger factor;
@property (readonly) NSInteger value;

- (void)generate;
- (void)generateAMultipleOf:(int)value;

@end

@implementation AOCDay15

- (AOCDay15 *)init {
	self = [super initWithDay:15 name:@"Dueling Generators"];
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
	NSInteger generatorAStartValue = input[0].integerValue;
	NSInteger generatorBStartValue = input[1].integerValue;
	
	A15Generator *a = [[A15Generator alloc] initFactor:A_FACTOR value:generatorAStartValue];
	A15Generator *b = [[A15Generator alloc] initFactor:B_FACTOR value:generatorBStartValue];
	
	NSInteger matchCount = 0;
	for (int i = 0; i < 40000000; i++) { // 40 million
		[a generate];
		[b generate];
		//NSLog(@"A: %ld  B: %ld", a.value, b.value);
		if ([A15Generator value:a.value matches:b.value]) {
			//NSLog(@"match!");
			matchCount++;
		}
	}

	return [NSString stringWithFormat:@"%ld", matchCount];
}

- (NSString *)solvePartTwo:(NSArray<NSString *> *)input {
	NSInteger generatorAStartValue = input[0].integerValue;
	NSInteger generatorBStartValue = input[1].integerValue;
	
	A15Generator *a = [[A15Generator alloc] initFactor:A_FACTOR value:generatorAStartValue];
	A15Generator *b = [[A15Generator alloc] initFactor:B_FACTOR value:generatorBStartValue];
	
	NSInteger matchCount = 0;
	for (int i = 0; i < 5000000; i++) { // 5 million
		[a generateAMultipleOf:4];
		[b generateAMultipleOf:8];
		//NSLog(@"A: %ld  B: %ld", a.value, b.value);
		if ([A15Generator value:a.value matches:b.value]) {
			//NSLog(@"match at %d", i);
			matchCount++;
		}
//		if (i % 10000 == 0) {
//			NSLog(@"%d", i);
//		}
	}

	return [NSString stringWithFormat:@"%ld", matchCount];
}

@end

@implementation A15Generator

+ (BOOL)value:(NSInteger)valA matches:(NSInteger)valB
{
	BOOL result = YES;
	// Lowest 16 bits
	for (int i = 0; i < 16; i++) {
		int mask = (int)pow(2, i);
		if ((valA & mask) != (valB & mask)) {
			result = NO;
			break;
		}
	}
	
	return result;
}

- (A15Generator *)initFactor:(NSInteger)factor value:(NSInteger)value
{
	self = [super init];
	_factor = factor;
	_value = value;
	return self;
}

- (void)generate
{
	_value = (_value * _factor) % 2147483647;
}

- (void)generateAMultipleOf:(int)m
{
	while (YES) {
		[self generate];
		if (self.value % m == 0) {
			break;
		}
	}
}

@end
