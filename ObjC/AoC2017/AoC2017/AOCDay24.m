//
//  AOCDay24.m
//  AoC2017
//

#import <Foundation/Foundation.h>
#import "AOCDay.h"
#import "AOCStrings.h"

@interface D24Connector : NSObject

@property (readonly) NSNumber *number;
@property (readonly) int p1;
@property (readonly) int p2;
@property BOOL isReversed;

+ (D24Connector *)connector:(NSNumber *)number;
+ (NSDictionary<NSNumber *, D24Connector *> *)allConnectors;
+ (NSArray<D24Connector *> *)connectorsWithPins:(int)p;

- (D24Connector *)init:(NSNumber *)number port1Pins:(int)p1 port2Pins:(int)p2;
- (int)sum;

@end




@interface D24Bridge : NSObject

@property (readonly) NSArray<D24Connector *> *connectors;
@property (readonly) NSSet<D24Connector *> *index;

- (D24Bridge *)init;
- (D24Bridge *)bridgeByAppending:(D24Connector *)conn;
- (int)openEnd;
- (int)strength;
- (BOOL)contains:(D24Connector *)conn;

@end




@implementation AOCDay24

- (AOCDay24 *)init {
	self = [super initWithDay:24 name:@"Electromagnetic Moat"];
	return self;
}

- (struct AOCResult)solveInputIndex:(int)index inFile:(NSString *)filename {
	struct AOCResult result = [super solveInputIndex:index inFile:filename];
	
	NSArray<NSString *> *input = [AOCInput readGroupedInputFile:filename atIndex:index];
	
	[self parseConnectors:input];
	
	result.part1 = [self solvePartOne];
	result.part2 = [self solvePartTwo: input];
	
	return result;
}

- (NSString *)solvePartOne {
	D24Bridge *root = [[D24Bridge alloc] init];
	
	NSInteger maxStrength = [self buildBridge:root]; // 1579 too low
	
	return [NSString stringWithFormat:@"%ld", maxStrength];
}

- (NSString *)solvePartTwo:(NSArray<NSString *> *)input {
	
	return @"World";
}

- (NSInteger)buildBridge:(D24Bridge *)parent
{
	//[parent.debugDescription println];
	NSArray<D24Connector *> *connsWithRightPins = [D24Connector connectorsWithPins:parent.openEnd];
	NSInteger maxStrength = 0;
	for (D24Connector *conn in connsWithRightPins) {
		if (![parent contains:conn]) {
			D24Connector *temp = [conn copy];
			if (conn.p1 != parent.openEnd) {
				temp.isReversed = true;
			}
			D24Bridge *child = [parent bridgeByAppending:temp];
			maxStrength = MAX(child.strength, maxStrength);
			NSInteger str = [self buildBridge:child];
			maxStrength = MAX(str, maxStrength);
		}
	}
	return maxStrength;
}

- (void)parseConnectors:(NSArray<NSString *> *)input
{
	NSMutableArray<D24Connector *> *result = [NSMutableArray array];
	int count = 0;
	for (NSString *line in input) {
		NSArray<NSString *> *parts = [line componentsSeparatedByString:@"/"];
		D24Connector *c = [[D24Connector alloc] init:@(count) port1Pins:parts[0].intValue port2Pins:parts[1].intValue];
		[result addObject:c];
		count++;
	}
}

@end




static NSMutableDictionary<NSNumber *, D24Connector *> *_allConnectors = nil;

@implementation D24Connector

+ (NSDictionary<NSNumber *, D24Connector *> *)allConnectors
{
	return [_allConnectors copy];
}

+ (D24Connector *)connector:(NSNumber *)number
{
	return [_allConnectors objectForKey:number];
}

static NSMutableDictionary<NSNumber *, NSArray<D24Connector *> *> *_connectorsWithPins = nil;

+ (NSArray<D24Connector *> *)connectorsWithPins:(int)p
{
	NSArray<D24Connector *> *result = [_connectorsWithPins objectForKey:@(p)];
	if (result != nil) {
		return result;
	}
	NSIndexSet *i = [_allConnectors.allValues indexesOfObjectsPassingTest:^BOOL(D24Connector *conn, NSUInteger index, BOOL *stop) {
		return (conn.p1 == p || conn.p2 == p);
	}];
	result = [_allConnectors.allValues objectsAtIndexes:i];
	_connectorsWithPins[@(p)] = result;
	//NSLog(@"%d: %ld", p, i.count);
	return result;
}


+ (void)initialize
{
	if (_allConnectors == nil) {
		_allConnectors = [NSMutableDictionary dictionary];
	}
	if (_connectorsWithPins == nil) {
		_connectorsWithPins = [NSMutableDictionary dictionary];
	}
}

- (D24Connector *)init:(NSNumber *)number port1Pins:(int)p1 port2Pins:(int)p2
{
	self = [super init];
	_number = number;
	_p1 = p1;
	_p2 = p2;
	self.isReversed = NO;
	_allConnectors[number] = self;
	return self;
}

- (NSString *)debugDescription
{
	if (self.isReversed) {
		return [NSString stringWithFormat:@"}%d==%d{", _p2, _p1];
	}
	return [NSString stringWithFormat:@"}%d==%d{", _p1, _p2];
}

- (int)sum
{
	return _p1 + _p2;
}

- (BOOL)isEqualToConnector:(D24Connector *)other {
	if (other == nil) {
		return NO;
	}
	return [self.number isEqualTo:other.number] && self.p1 == other.p1 && self.p2 == other.p2;
}

- (BOOL)isEqual:(nullable id)object {
	if (object == nil) {
		return NO;
	}

	if (self == object) {
		return YES;
	}

	if (![object isKindOfClass:[D24Connector class]]) {
		return NO;
	}

	return [self isEqualToConnector:(D24Connector *)object];
}

- (NSUInteger)hash {
	return [self.number hash] ^ [@(self.p1) hash] ^ [@(self.p2) hash];
}

// NSCopying (to let this be a key in NSDictionary)
- (id)copy
{
	D24Connector *copy = [[D24Connector alloc] init:self.number port1Pins:self.p1 port2Pins:self.p2];
	return copy;
}

- (id)copyWithZone:(NSZone *)zone
{
	D24Connector *copy = [[D24Connector allocWithZone:zone] init:self.number port1Pins:self.p1 port2Pins:self.p2];
	return copy;
}

@end




@implementation D24Bridge

- (D24Bridge *)init
{
	self = [super init];
	_connectors = [NSArray array];
	return self;
}

- (D24Bridge *)init:(NSArray<D24Connector *> *)connectors
{
	self = [super init];
	_connectors = connectors;
	_index = [NSSet setWithArray:_connectors];
	return self;
}

- (NSString *)debugDescription
{
	NSArray<NSString *> *strings = [_connectors valueForKey:@"debugDescription"];
	return [NSString stringWithFormat:@"%d %@", self.strength, [strings componentsJoinedByString:@" "]];
}

- (D24Bridge *)bridgeByAppending:(D24Connector *)conn
{
	NSArray<D24Connector *> *newConnectors = [_connectors arrayByAddingObject:conn];
	return [[D24Bridge alloc] init:newConnectors];
}

- (int)openEnd
{
	if (self.connectors.count == 0) {
		return 0;
	}
	D24Connector *last = self.connectors.lastObject;
	if ([last isReversed]) {
		return last.p1;
	}
	return last.p2;
}

- (int)strength
{
	int s = 0;
	for (D24Connector *conn in self.connectors) {
		s += conn.sum;
	}
	return s;
}

- (BOOL)contains:(D24Connector *)conn
{
	return [self.index containsObject:conn];
}


@end
