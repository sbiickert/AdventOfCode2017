//
//  AOCDay22.m
//  AoC2017
//

#import <Foundation/Foundation.h>
#import "AOCDay.h"
#import "AOCCoord.h"
#import "AOCGrid2D.h"
#import "AOCStrings.h"

@interface D22Carrier : NSObject

@property (readonly) NSString *facing;
@property (readonly) AOCCoord2D *position;
@property (readonly) NSInteger infectionCount;

- (D22Carrier *)init:(AOCCoord2D *)startPosition;
- (void)burst:(AOCGrid2D *)grid;
- (NSInteger)incrementInfectionCount;
- (void)turnCW;
- (void)turnCCW;
- (void)move;

@end

@interface D22EvolvedCarrier : D22Carrier

@end

@implementation AOCDay22

- (AOCDay22 *)init {
	self = [super initWithDay:22 name:@"Sporifica Virus"];
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
	AOCGrid2D *grid = [self parseGrid:input];
	D22Carrier *virus = [[D22Carrier alloc] init:grid.extent.center];
	//[grid printInvertedY:NO withOverlay:@{virus.position: @"*"}];
	for (int i = 1; i <= 10000; i++)
	{
		[virus burst:grid];
		//NSLog(@"%d", i);
		//[grid printInvertedY:NO withOverlay:@{virus.position: @"*"}];
	}
	return [NSString stringWithFormat:@"%ld", virus.infectionCount];
}

- (NSString *)solvePartTwo:(NSArray<NSString *> *)input {
	AOCGrid2D *grid = [self parseGrid:input];
	D22EvolvedCarrier *virus = [[D22EvolvedCarrier alloc] init:grid.extent.center];
//	[grid printInvertedY:NO withOverlay:@{virus.position: @"*"}];
	for (int i = 1; i <= 10000000; i++)
	{
		[virus burst:grid];
//		NSLog(@"%d", i);
//		[grid printInvertedY:NO withOverlay:@{virus.position: @"*"}];
	}
	return [NSString stringWithFormat:@"%ld", virus.infectionCount];
}

- (AOCGrid2D *)parseGrid:(NSArray<NSString *> *)input
{
	AOCGrid2D *grid = [AOCGrid2D grid];
	
	for (int r = 0; r < input.count; r++) {
		NSString *line = input[r];
		NSArray<NSString *> *chars = [line getAllCharacters];
		for (int c = 0; c < chars.count; c++) {
			[grid setObject:chars[c] atCoord:[AOCCoord2D x:c y:r]];
		}
	}
	
	return grid;
}

@end

@implementation D22Carrier

- (D22Carrier *)init:(AOCCoord2D *)startPosition
{
	self = [super init];
	
	_infectionCount = 0;
	_facing = UP;
	_position = startPosition;
	
	return self;
}

- (NSInteger)incrementInfectionCount
{
	_infectionCount++;
	return _infectionCount;
}

- (void)burst:(AOCGrid2D *)grid
{
	NSString *currentPositionValue = (NSString *)[grid objectAtCoord:self.position];
	if ([currentPositionValue isEqualToString:@"#"])
	{
		// Is infected. Turn cw.
		[self turnCW];
		// Clean it
		[grid setObject:grid.defaultValue atCoord:self.position];
	}
	else
	{
		// Is clean. Turn ccw.
		[self turnCCW];
		// Infect it
		[grid setObject:@"#" atCoord:self.position];
		[self incrementInfectionCount];
	}
	// Move forward
	[self move];
}

- (void)turnCW
{
	_facing = self.cw;
}
- (void)turnCCW
{
	_facing = self.ccw;
}

- (void)move
{
	_position = [self.position offset:self.facing];
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

@implementation D22EvolvedCarrier

// Override
- (void)burst:(AOCGrid2D *)grid
{
	NSString *currentPositionValue = (NSString *)[grid objectAtCoord:self.position];
	if ([currentPositionValue isEqualToString:@"#"])
	{
		// Is infected. Turn cw.
		[self turnCW];
		// Flag it
		[grid setObject:@"F" atCoord:self.position];
	}
	else if ([currentPositionValue isEqualToString:@"W"])
	{
		// Is weakened. No turn.
		// Infect it
		[grid setObject:@"#" atCoord:self.position];
		[self incrementInfectionCount];
	}
	else if ([currentPositionValue isEqualToString:@"F"])
	{
		// Is flagged. Reverse.
		[self turnCW];
		[self turnCW];
		// Clean it
		[grid clearAtCoord:self.position]; // Optimization. Less info in grid._data.
//		[grid setObject:grid.defaultValue atCoord:self.position];
	}
	else
	{
		// Is clean. Turn ccw.
		[self turnCCW];
		// Infect it
		[grid setObject:@"W" atCoord:self.position];
	}
	// Move forward
	[self move];
}

@end
