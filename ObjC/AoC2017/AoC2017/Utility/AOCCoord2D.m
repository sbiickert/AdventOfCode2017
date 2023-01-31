//
//  AOCCoord2D.m
//  AoC2017
//
//  Created by Simon Biickert on 2023-01-28.
//

#import <Foundation/Foundation.h>
#import "AOCCoord2D.h"
#include "math.h"

NSString * const NORTH = @"north";
NSString * const SOUTH = @"south";
NSString * const WEST = @"west";
NSString * const EAST = @"east";
NSString * const NW = @"nw";
NSString * const NE = @"ne";
NSString * const SW = @"sw";
NSString * const SE = @"se";
NSString * const UP = @"up";
NSString * const DOWN = @"down";
NSString * const LEFT = @"left";
NSString * const RIGHT = @"right";

static NSDictionary<NSString *, AOCCoord2D *> *_offsets = nil;

@implementation AOCCoord2D

+ (void)initialize
{
	if (!_offsets) {
		NSMutableDictionary<NSString *, AOCCoord2D *> *dict = [NSMutableDictionary dictionary];
		[dict setObject:[AOCCoord2D x: 0 y:-1] forKey:NORTH];
		[dict setObject:[AOCCoord2D x: 0 y: 1] forKey:SOUTH];
		[dict setObject:[AOCCoord2D x:-1 y: 0] forKey:WEST];
		[dict setObject:[AOCCoord2D x: 1 y: 0] forKey:EAST];
		
		[dict setObject:[AOCCoord2D x:-1 y:-1] forKey:NW];
		[dict setObject:[AOCCoord2D x: 1 y:-1] forKey:NE];
		[dict setObject:[AOCCoord2D x:-1 y: 1] forKey:SW];
		[dict setObject:[AOCCoord2D x: 1 y: 1] forKey:SE];
		
		[dict setObject:[AOCCoord2D x: 0 y:-1] forKey:UP];
		[dict setObject:[AOCCoord2D x: 0 y: 1] forKey:DOWN];
		[dict setObject:[AOCCoord2D x:-1 y: 0] forKey:LEFT];
		[dict setObject:[AOCCoord2D x: 1 y: 0] forKey:RIGHT];
		
		_offsets = dict;
	}
}

+ (AOCCoord2D *)origin {
	return [[AOCCoord2D alloc] initX:0 y:0];
}

+ (AOCCoord2D *)x:(int)x y:(int)y {
	return [[AOCCoord2D alloc] initX:x y:y];
}

+ (AOCCoord2D *)copyOf:(AOCCoord2D *)other {
	return [[AOCCoord2D alloc] initX:other.x y:other.y];
}

+ (AOCCoord2D *)offset:(NSString *)direction {
	if (direction == nil) {
		return nil;
	}
	return [_offsets objectForKey:direction];
}


- (AOCCoord2D *)initX:(int)x y:(int)y {
	self = [super init];
	_x = x;
	_y = y;
	return self;
}

- (int)row {
	return self.y;
}

- (int)col {
	return self.x;
}

- (NSString *)description {
	return [NSString stringWithFormat:@"[%d,%d]", self.x, self.y];
}

- (AOCCoord2D *)add:(AOCCoord2D *)other {
	if (other == nil) {
		return [AOCCoord2D copyOf:self];
	}
	return [AOCCoord2D x:self.x + other.x y:self.y + other.y];
}

- (AOCCoord2D *)delta:(AOCCoord2D *)other {
	if (other == nil) {
		return [AOCCoord2D copyOf:self];
	}
	return [AOCCoord2D x:other.x - self.x
					   y:other.y - self.y];
}

- (AOCCoord2D *)offset:(NSString *)direction
{
	return [self add: [AOCCoord2D offset:direction]];
}


- (double)distanceTo:(AOCCoord2D *)other {
	AOCCoord2D *delta = [self delta:other];
	return sqrt(pow(delta.x, 2) + pow(delta.y, 2));
}

- (int)manhattanDistanceTo:(AOCCoord2D *)other {
	AOCCoord2D *delta = [self delta:other];
	return abs(delta.x) + abs(delta.y);
}

- (BOOL)isEqualToCoord2D:(AOCCoord2D *)other {
	if (other == nil) {
		return NO;
	}
	return self.x == other.x && self.y == other.y;
}

- (BOOL)isEqual:(nullable id)object {
	if (object == nil) {
		return NO;
	}

	if (self == object) {
		return YES;
	}

	if (![object isKindOfClass:[AOCCoord2D class]]) {
		return NO;
	}

	return [self isEqualToCoord2D:(AOCCoord2D *)object];
}

- (NSUInteger)hash {
	return [@(self.x) hash] ^ [@(self.y) hash];
}

// NSCopying (to let this be a key in NSDictionary)
- (id)copyWithZone:(NSZone *)zone
{
	AOCCoord2D *copy = [[AOCCoord2D allocWithZone:zone] initX:_x y:_y];
	return copy;
}

@end
