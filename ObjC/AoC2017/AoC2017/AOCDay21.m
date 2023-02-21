//
//  AOCDay21.m
//  AoC2017
//

#import <Foundation/Foundation.h>
#import "AOCDay.h"
#import "AOCGrid2D.h"
#import "AOCStrings.h"

@interface D21Rule : NSObject

@property NSArray<AOCGrid2D *> *patterns;
@property AOCGrid2D *output;

- (D21Rule *)init:(NSString *)defn;
- (BOOL)matches:(AOCGrid2D *)grid;
- (int)size;

@end

@implementation AOCDay21

- (AOCDay21 *)init {
	self = [super initWithDay:21 name:@"Fractal Art"];
	return self;
}

- (struct AOCResult)solveInputIndex:(int)index inFile:(NSString *)filename {
	struct AOCResult result = [super solveInputIndex:index inFile:filename];
	
	NSArray<NSString *> *input = [AOCInput readGroupedInputFile:filename atIndex:index];
	
//		.#.
//		..#
//		###
	
	AOCGrid2D *image = [AOCGrid2D grid];
	[image setObject:@"#" atCoord:[AOCCoord2D x:1 y:0]];
	[image setObject:@"#" atCoord:[AOCCoord2D x:2 y:1]];
	[image setObject:@"#" atCoord:[AOCCoord2D x:0 y:2]];
	[image setObject:@"#" atCoord:[AOCCoord2D x:1 y:2]];
	[image setObject:@"#" atCoord:[AOCCoord2D x:2 y:2]];

	NSArray<D21Rule *> *rules = [self parseRules:input];
	
	result.part1 = [self solvePartOne: image rules:rules];
	result.part2 = [self solvePartTwo: image rules:rules];
	
	return result;
}

- (NSString *)solvePartOne:(AOCGrid2D *)image rules:(NSArray<D21Rule *> *)rules {
	// Test shows 2 iterations, challenge is 5
	return [self solvePart:image rules:rules count:(rules.count > 2 ? 5 : 2)];
}

- (NSString *)solvePartTwo:(AOCGrid2D *)image rules:(NSArray<D21Rule *> *)rules {
	// Just brute forcing it. Only takes 1.5 minutes.
	return [self solvePart:image rules:rules count:18];
}

- (NSString *)solvePart:(AOCGrid2D *)image rules:(NSArray<D21Rule *> *)rules count:(int)count
{
	for (int iter = 1; iter <= count; iter++) {
		// Split image
		NSArray<AOCGrid2D *> *images = [self splitImage:image];
		
		// Apply rules
		NSMutableArray<AOCGrid2D *> *outputImages = [NSMutableArray array];
		for (AOCGrid2D *image in images) {
			for (D21Rule *rule in rules) {
				if ([rule matches:image]) {
					[outputImages addObject:rule.output];
					//[rule.output print];
					break;
				}
			}
		}
		assert(images.count == outputImages.count);
		
		// Join image
		image = [self joinImages:outputImages];
	}
	//[image print];
	
	return [NSString stringWithFormat:@"%ld", [image coordsWithValue:@"#"].count];
}

- (NSArray<D21Rule *> *)parseRules:(NSArray<NSString *> *)input
{
	NSMutableArray<D21Rule *> *result = [NSMutableArray array];
	
	for (NSString *line in input) {
		[result addObject:[[D21Rule alloc] init:line]];
	}
	
	return result;
}

- (NSArray<AOCGrid2D *> *)splitImage:(AOCGrid2D *)image
{
	NSMutableArray<AOCGrid2D *> *result = [NSMutableArray array];
	
	int step = (image.extent.width % 2 == 0) ? 2 : 3;
	
	//[image print];
	
	int x = 0;
	int y = 0;
	while (y < image.extent.height) {
		while (x < image.extent.width) {
			AOCGrid2D *g = [AOCGrid2D grid];
			for (int r = 0; r < step; r++) {
				for (int c = 0; c < step; c++) {
					int r0 = y + r;
					int c0 = x + c;
					NSObject *value = [image objectAtCoord:[AOCCoord2D x:c0 y:r0]];
					[g setObject:value atCoord:[AOCCoord2D x:c y:r]];
				}
			}
			x += step;
			//[g print];
			[result addObject:g];
		}
		x = 0;
		y += step;
	}
	return result;
}

- (AOCGrid2D *)joinImages:(NSArray<AOCGrid2D *> *)images
{
	AOCGrid2D *result = [AOCGrid2D grid];

	int size = (int)sqrt(images.count);
	
	int x = 0;
	int y = 0;
	int i = 0;
	while (y < size) {
		while (x < size) {
			AOCGrid2D *g = images[i];
			for (AOCCoord2D *c in g.extent.allCoords) {
				NSObject *value = [g objectAtCoord:c];
				[result setObject:value atCoord:[AOCCoord2D x:(x * g.extent.width) + c.x
															y:(y * g.extent.height) + c.y]];
			}
			x++;
			i++;
		}
		x = 0;
		y++;
	}
	//[result print];
	return result;
}

@end

@implementation D21Rule

- (D21Rule *)init:(NSString *)defn
{
	self = [super init];
	NSArray<NSString *> *inputOutput = [defn componentsSeparatedByString:@" => "];
	
	AOCGrid2D *original = [AOCGrid2D grid];
	NSArray<NSString *> *lines = [inputOutput[0] componentsSeparatedByString:@"/"];
	for (int r = 0; r < lines.count; r++) {
		NSArray<NSString *> *pixels = [lines[r] getAllCharacters];
		for (int c = 0; c < pixels.count; c++) {
			[original setObject:pixels[c] atCoord:[AOCCoord2D x:c y:r]];
		}
	}
	
	NSMutableArray<AOCGrid2D *> *grids = [NSMutableArray array];
	_patterns = grids;
	[grids addObject:original];
	AOCGrid2D *flipped = [self flipX:original];
	[grids addObject:flipped];
	flipped = [self flipY:original];
	[grids addObject:flipped];
	
	for (int i = 1; i <=3; i++) {
		original = [self rotateCW:original];
		if (![self array:grids contains:original]) { [grids addObject:original]; }
		flipped = [self flipX:original];
		if (![self array:grids contains:flipped]) { [grids addObject:flipped]; };
		flipped = [self flipY:original];
		if (![self array:grids contains:flipped]) { [grids addObject:flipped]; };
	}
	
	self.output = [AOCGrid2D grid];
	lines = [inputOutput[1] componentsSeparatedByString:@"/"];
	for (int r = 0; r < lines.count; r++) {
		NSArray<NSString *> *pixels = [lines[r] getAllCharacters];
		for (int c = 0; c < pixels.count; c++) {
			[self.output setObject:pixels[c] atCoord:[AOCCoord2D x:c y:r]];
		}
	}
	//[self.output print];
	
	return self;
}

- (BOOL)matches:(AOCGrid2D *)grid
{
	if (grid.extent.width != self.size) { return NO; }
	
	for (AOCGrid2D *pattern in self.patterns)  {
		if ([grid isEqualToGrid:pattern]) {
			return YES;
		}
	}
	return NO;
}

- (int)size
{
	return self.patterns.firstObject.extent.width;
}

/* Private methods */

- (BOOL)array:(NSArray<AOCGrid2D *> *)arr contains:(AOCGrid2D *)pattern
{
	for (AOCGrid2D *grid in arr) {
		if ([grid isEqualToGrid:pattern]) {
			return YES;
		}
	}
	return NO;
}

- (AOCGrid2D *)flipX:(AOCGrid2D *)input
{
	AOCGrid2D *flipped = [AOCGrid2D grid];
	for (AOCCoord2D *c in [input coords]) {
		int newY = c.y; // default
		if (c.y == 0) {
			newY = input.extent.max.y;
		}
		else if (c.y == input.extent.max.y) {
			newY = 0;
		}
		[flipped setObject:[input objectAtCoord:c]
				   atCoord:[AOCCoord2D x:c.x y:newY]];
	}
	return flipped;
}

- (AOCGrid2D *)flipY:(AOCGrid2D *)input
{
	AOCGrid2D *flipped = [AOCGrid2D grid];
	for (AOCCoord2D *c in [input coords]) {
		int newX = c.x; // default
		if (c.x == 0) {
			newX = input.extent.max.x;
		}
		else if (c.x == input.extent.max.x) {
			newX = 0;
		}
		[flipped setObject:[input objectAtCoord:c]
				   atCoord:[AOCCoord2D x:newX y:c.y]];
	}
	return flipped;
}

- (AOCGrid2D *)rotateCW:(AOCGrid2D *)input
{
	AOCGrid2D *rotated = [AOCGrid2D grid];
	AOCCoord2D *c = [AOCCoord2D x:0 y:0];
	[rotated setObject:[input objectAtCoord:c] atCoord:[AOCCoord2D x:input.extent.max.x y:0]];
	c = [AOCCoord2D x:input.extent.max.x y:0];
	[rotated setObject:[input objectAtCoord:c] atCoord:[AOCCoord2D x:input.extent.max.x y:input.extent.max.y]];
	c = [AOCCoord2D x:input.extent.max.x y:input.extent.max.y];
	[rotated setObject:[input objectAtCoord:c] atCoord:[AOCCoord2D x:0 y:input.extent.max.y]];
	c = [AOCCoord2D x:0 y:input.extent.max.y];
	[rotated setObject:[input objectAtCoord:c] atCoord:[AOCCoord2D x:0 y:0]];
	
	if (self.size == 3) {
		c = [AOCCoord2D x:1 y:0];
		[rotated setObject:[input objectAtCoord:c] atCoord:[AOCCoord2D x:2 y:1]];
		c = [AOCCoord2D x:2 y:1];
		[rotated setObject:[input objectAtCoord:c] atCoord:[AOCCoord2D x:1 y:2]];
		c = [AOCCoord2D x:1 y:2];
		[rotated setObject:[input objectAtCoord:c] atCoord:[AOCCoord2D x:0 y:1]];
		c = [AOCCoord2D x:0 y:1];
		[rotated setObject:[input objectAtCoord:c] atCoord:[AOCCoord2D x:1 y:0]];
		c = [AOCCoord2D x:1 y:1];
		[rotated setObject:[input objectAtCoord:c] atCoord:c];
	}

	return rotated;
}
@end
