//
//  AOCDay17.m
//  AoC2017
//

#import <Foundation/Foundation.h>
#import "AOCDay17.h"

@interface CircularBufferNode : NSObject

+ (CircularBufferNode *)nodeWithValue:(NSInteger)value;

- (CircularBufferNode *)initWithValue:(NSInteger)value;

@property NSInteger value;
@property CircularBufferNode *prev;
@property CircularBufferNode *next;

- (void)insertAfter:(CircularBufferNode *)node;
- (void)insertBefore:(CircularBufferNode *)node;

@end

@implementation AOCDay17

- (AOCDay17 *)init {
	self = [super initWithDay:17 name:@"Spin Lock"];
	return self;
}

- (struct AOCResult)solveInputIndex:(int)index inFile:(NSString *)filename {
	struct AOCResult result = [super solveInputIndex:index inFile:filename];
	
	NSArray<NSString *> *input = [AOCInput readGroupedInputFile:filename atIndex:index];
	
	NSInteger step = input[0].integerValue;
	
	result.part1 = [self solvePartOne: step];
	result.part2 = [self solvePartTwo: step];
	
	return result;
}

- (NSString *)solvePartOne:(NSInteger)stepSize {
	CircularBufferNode *zero = [CircularBufferNode nodeWithValue:0];
	
	CircularBufferNode *current = zero;
	for (NSInteger i = 1; i <= 2017; i++) {
		for (NSInteger step = 0; step < stepSize; step++) {
			current = current.next;
		}
		[current insertAfter:[CircularBufferNode nodeWithValue:i]];
		current = current.next;
	}
	
	return [NSString stringWithFormat:@"%ld", current.next.value];
}

- (NSString *)solvePartTwo:(NSInteger)stepSize {
	CircularBufferNode *zero = [CircularBufferNode nodeWithValue:0];
	
	CircularBufferNode *current = zero;
	for (NSInteger i = 1; i <= 50000000; i++) {
		for (NSInteger step = 0; step < stepSize; step++) {
			current = current.next;
		}
		[current insertAfter:[CircularBufferNode nodeWithValue:i]];
		current = current.next;
		if (i % 100000 == 0) {
			// Interesting, the final value was in place by 2.4 million iterations done
			NSLog(@"%ld zero -> %ld -> %ld -> %ld -> %ld -> %ld", i,
				  zero.next.value, zero.next.next.value, zero.next.next.next.value,
				  zero.next.next.next.next.value, zero.next.next.next.next.next.value );
		}
	}
	
	return [NSString stringWithFormat:@"%ld", zero.next.value];
}

@end

@implementation CircularBufferNode

+ (CircularBufferNode *)nodeWithValue:(NSInteger)value
{
	return [[CircularBufferNode alloc] initWithValue:value];
}

- (CircularBufferNode *)initWithValue:(NSInteger)value
{
	self = [super init];
	self.value = value;
	self.next = self;
	self.prev = self;
	return self;
}

- (void)insertAfter:(CircularBufferNode *)node
{
	node.prev = self;
	node.next = self.next;
	self.next.prev = node;
	self.next = node;
}

- (void)insertBefore:(CircularBufferNode *)node
{
	node.prev = self.prev;
	node.next = self;
	self.prev.next = node;
	self.prev = node;
}

@end
