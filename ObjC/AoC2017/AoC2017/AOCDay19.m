//
//  AOCDay19.m
//  AoC2017
//

#import <Foundation/Foundation.h>
#import "AOCDay19.h"
#import "AOCStrings.h"
#import "AOCGrid2D.h"

@interface LostPacket : NSObject

- (LostPacket *)initAt:(AOCCoord2D *)position;
@property NSString *facing;
@property AOCCoord2D *position;
@property NSMutableArray<NSString *> *collection;

- (BOOL)move:(AOCGrid2D *)tubes;

@end

@implementation AOCDay19

- (AOCDay19 *)init {
	self = [super initWithDay:19 name:@"A Series of Tubes"];
	return self;
}

- (struct AOCResult)solveInputIndex:(int)index inFile:(NSString *)filename {
	struct AOCResult result = [super solveInputIndex:index inFile:filename];
	
	NSArray<NSString *> *input = [AOCInput readGroupedInputFile:filename atIndex:index];
	
	AOCGrid2D *tubes = [self parseGrid:input];
	
	result.part1 = [self solvePartOne: tubes];
	result.part2 = [self solvePartTwo: input];
	
	return result;
}

- (NSString *)solvePartOne:(AOCGrid2D *)tubes {
	LostPacket *p = [[LostPacket alloc] initAt:[self findStart:tubes]];
	
	while ([p move:tubes]) {
		//[tubes printInvertedY:NO withOverlay:@{p.position: @"*"}];
	}
	
	return [p.collection componentsJoinedByString:@""];
}

- (NSString *)solvePartTwo:(NSArray<NSString *> *)input {
	
	return @"World";
}

- (AOCGrid2D *)parseGrid:(NSArray<NSString *> *)input
{
	AOCGrid2D *grid = [AOCGrid2D grid];
	for (int r = 0; r < input.count; r++) {
		NSArray<NSString *> *chars = [input[r] getAllCharacters];
		for (int c = 0; c < chars.count; c++) {
			if (![chars[c] isEqualToString:@" "]) {
				[grid setObject:chars[c] atCoord:[AOCCoord2D x:c y:r]];
			}
		}
	}
	//[grid print];
	return grid;
}

- (AOCCoord2D *)findStart:(AOCGrid2D *)tubes
{
	for (int x = 0; x <= tubes.extent.max.x; x++) {
		if ([[tubes objectAtCoord:[AOCCoord2D x:x y:0]] isEqualTo:@"|"]) {
			return [AOCCoord2D x:x y:-1];
		}
	}
	return nil;
}

@end

@implementation LostPacket

- (LostPacket *)initAt:(AOCCoord2D *)position
{
	self = [super init];
	self.position = position;
	self.facing = DOWN;
	self.collection = [NSMutableArray array];
	return self;
}

- (BOOL)move:(AOCGrid2D *)tubes
{
	AOCCoord2D *next = [self.position offset:self.facing];
	if ([[tubes objectAtCoord:next] isEqualTo:tubes.defaultValue]) {
		return NO;
	}
	self.position = next;
	NSString *value = (NSString *)[tubes objectAtCoord:self.position];
	if ([value isEqualToString:@"|"] || [value isEqualToString:@"-"]) {
		// Continue
	}
	else if ([value isEqualToString:@"+"]) {
		// Turn cw or ccw
		NSString *cwValue = (NSString *)[tubes objectAtCoord:[self.position offset:self.cw]];
		//NSString *ccwValue = (NSString *)[tubes objectAtCoord:[self.position offset:self.ccw]];
		if ([cwValue isEqualTo:tubes.defaultValue] == NO) {
			self.facing = self.cw;
		}
		else {
			self.facing = self.ccw;
		}
	}
	else {
		// Pick up
		[self.collection addObject:value];
	}
	return YES;
}

- (NSString *)cw
{
	if ([self.facing isEqualToString:UP]) 			{ return RIGHT; }
	else if ([self.facing isEqualToString:RIGHT]) 	{ return DOWN; }
	else if ([self.facing isEqualToString:DOWN]) 	{ return LEFT; }
	return UP;
}

- (NSString *)ccw
{
	if ([self.facing isEqualToString:UP]) 			{ return LEFT; }
	else if ([self.facing isEqualToString:LEFT]) 	{ return DOWN; }
	else if ([self.facing isEqualToString:DOWN]) 	{ return RIGHT; }
	return UP;
}

@end
