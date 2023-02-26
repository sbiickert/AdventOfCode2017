//
//  AOCDay25.m
//  AoC2017
//

#import <Foundation/Foundation.h>
#import "AOCDay.h"
#import "AOCStrings.h"
#import "AOCGrid2D.h"

@interface D25State : NSObject

@property (readonly) NSString *name;
@property (readonly) int writeIfZero;
@property (readonly) int writeIfOne;
@property (readonly) int moveIfZero;
@property (readonly) int moveIfOne;
@property (readonly) NSString *nextStateIfZero;
@property (readonly) NSString *nextStateIfOne;

- (D25State *)init:(NSArray<NSString *> *)defn;

@end



@implementation AOCDay25

- (AOCDay25 *)init {
	self = [super initWithDay:25 name:@"The Halting Problem"];
	return self;
}

- (struct AOCResult)solveInputIndex:(int)index inFile:(NSString *)filename {
	struct AOCResult result = [super solveInputIndex:index inFile:filename];
	
	NSArray<NSArray<NSString *> *> *input = [AOCInput readGroupedInputFile:filename];
	
	NSMutableDictionary<NSString *, D25State *> *blueprint = [NSMutableDictionary dictionary];
	for (NSArray<NSString *> *defn in input) {
		D25State *state = [[D25State alloc] init:defn];
		[blueprint setValue:state forKey:state.name];
	}
	
	result.part1 = [self solvePartOne: blueprint];
	result.part2 = [self solvePartTwo: blueprint];
	
	return result;
}

- (NSString *)solvePartOne:(NSMutableDictionary<NSString *, D25State *> *)blueprint {
	/*
	 Begin in state A.
	 Perform a diagnostic checksum after 6 steps. (TEST)
	 Perform a diagnostic checksum after 12964419 steps. (CHALLENGE)
	 */
	NSString *stateName = @"A";
	AOCGrid2D *tape = [[AOCGrid2D alloc] initWithDefault:@0 adjacency:ROOK];
	AOCCoord2D *pos = [AOCCoord2D x:0 y:0];
	
	NSInteger limit = blueprint.count == 2 ? 6 : 12964419;
	for (NSInteger iter = 0; iter < limit; iter++)
	{
		NSNumber *val = (NSNumber *)[tape objectAtCoord:pos];
		D25State *state = blueprint[stateName];
		if ([val intValue] == 0) {
			[tape setObject:@(state.writeIfZero) atCoord:pos];
			pos = [AOCCoord2D x:pos.x+state.moveIfZero y:0];
			stateName = state.nextStateIfZero;
		}
		else {
			[tape setObject:@(state.writeIfOne) atCoord:pos];
			pos = [AOCCoord2D x:pos.x+state.moveIfOne y:0];
			stateName = state.nextStateIfOne;
		}
	}
	
	//[tape printInvertedY:NO withOverlay:@{pos: @"*"}];
	NSInteger checksum = [tape coordsWithValue:@1].count;
	
	return[NSString stringWithFormat:@"%ld", checksum];
}

- (NSString *)solvePartTwo:(NSMutableDictionary<NSString *, D25State *> *)blueprint {
	
	return @"Christmas!!!";
}

@end




@implementation D25State

- (D25State *)init:(NSArray<NSString *> *)defn
{
	self = [super init];
	_name = [defn[0] getAllCharacters][9];
	_writeIfZero = [defn[2] getAllCharacters][22].intValue;
	_writeIfOne = [defn[6] getAllCharacters][22].intValue;
	_moveIfZero = [defn[3] hasSuffix:@"right."] ? 1 : -1;
	_moveIfOne = [defn[7] hasSuffix:@"right."] ? 1 : -1;
	_nextStateIfZero = [defn[4] getAllCharacters][26];
	_nextStateIfOne = [defn[8] getAllCharacters][26];
	
	return self;
}

@end
