//
//  AOCDay03.m
//  AoC2017
//

#import <Foundation/Foundation.h>
#import "AOCDay.h"
#import "AOCGrid2D.h"

@implementation AOCDay03

- (AOCDay03 *)init {
	self = [super initWithDay:3 name:@"Spiral Memory"];
	return self;
}

- (struct AOCResult)solveInputIndex:(int)index inFile:(NSString *)filename {
	struct AOCResult result = [super solveInputIndex:index inFile:filename];
	
	NSArray<NSString *> *input = [AOCInput readGroupedInputFile:filename atIndex:index];
	
	result.part1 = [self solvePartOne: [input objectAtIndex:0]];
	result.part2 = [self solvePartTwo: [input objectAtIndex:0]];
	
	return result;
}

- (NSString *)solvePartOne:(NSString *)input {
	int target = [input intValue];
	AOCCoord2D *coord = [self spiralTo:target];
	int md = [coord manhattanDistanceTo:[AOCCoord2D origin]];
	
	return [NSString stringWithFormat:@"%d", md];
}

- (NSString *)solvePartTwo:(NSString *)input {
	int target = [input intValue];
	int num = [self aggregatingSpiralTo:target];
	
	return [NSString stringWithFormat:@"%d", num];
}

- (AOCCoord2D *)spiralTo:(int)num {
	int val = 1;
	AOCCoord2D *ptr = [AOCCoord2D origin];
	while (pow(val, 2) < num) {
		ptr = [ptr offset:SE];
		val += 2;
	}
	int valueAtPtr = pow(val, 2);

	AOCExtent2D *fullExtent = [AOCExtent2D xMin:-ptr.x yMin:-ptr.y xMax:ptr.x yMax:ptr.y];
	NSMutableArray<NSString *> *searchDirections = [@[LEFT, UP, RIGHT, DOWN] mutableCopy];
	NSString *dir = [searchDirections firstObject];
	[searchDirections removeObjectAtIndex:0];

	while (YES)
	{
		if (valueAtPtr == num) {
			break;
		}
		AOCCoord2D *next = [ptr offset:dir];
		if (![fullExtent contains:next]) {
			dir = [searchDirections firstObject];
			[searchDirections removeObjectAtIndex:0];
			next = [ptr offset:dir];
		}
		ptr = next;
		//NSLog(@"%@", ptr);
		valueAtPtr--;
	}

	NSLog(@"Number %d is at %@", num, ptr);
	return ptr;
}

- (int)aggregatingSpiralTo:(int)num {
	int val = 1;
	AOCGrid2D *grid = [[AOCGrid2D alloc] initWithDefault:@0 adjacency:QUEEN];
	AOCCoord2D *ptr = [AOCCoord2D origin];
	[grid setObject:@(val) atCoord:ptr];
	NSArray<NSString *> *fillDirections = @[RIGHT, UP, LEFT, DOWN];
	int dirIndex = 0;
	int nextDirIndex = dirIndex + 1;
	
	while (val <= num) {
		val = 0;
		ptr = [ptr offset:[fillDirections objectAtIndex:dirIndex]];
		for (AOCCoord2D *neighbor in [grid adjacentTo:ptr]) {
			val += [grid intAtCoord:neighbor];
		}
		[grid setObject:@(val) atCoord:ptr];
//		NSLog(@"Set value %d at coord %@", val, ptr);
		if ([grid intAtCoord:[ptr offset:[fillDirections objectAtIndex:nextDirIndex]]] == 0) {
			// Need to turn
			dirIndex++;
			dirIndex = dirIndex % 4;
			nextDirIndex++;
			nextDirIndex = nextDirIndex % 4;
		}
	}
	
	return val;
}
@end
