//
//  AOCDay20.m
//  AoC2017
//

#import <Foundation/Foundation.h>
#import "AOCDay.h"
#import "AOCCoord.h"
#import "AOCStrings.h"

@interface D20Particle : NSObject

+ (D20Particle *)particle:(NSString *)defn;

- (D20Particle *)init:(NSString *)defn;

@property int pid;
@property AOCCoord3D *p;
@property AOCCoord3D *v;
@property AOCCoord3D *a;

- (void)update;

@end

@implementation AOCDay20

- (AOCDay20 *)init {
	self = [super initWithDay:20 name:@"Particle Swarm"];
	return self;
}

- (struct AOCResult)solveInputIndex:(int)index inFile:(NSString *)filename {
	struct AOCResult result = [super solveInputIndex:index inFile:filename];
	
	NSArray<NSString *> *input = [AOCInput readGroupedInputFile:filename atIndex:index];
	NSMutableArray<D20Particle *> *particles = [NSMutableArray array];
	int i = 0;
	for (NSString *line in input) {
		D20Particle *p = [D20Particle particle:line];
		p.pid = i;
		[particles addObject:p];
		i++;
	}
	
	result.part1 = [self solvePartOne: particles];
	result.part2 = [self solvePartTwo: input];
	
	return result;
}

- (NSString *)solvePartOne:(NSArray<D20Particle *> *)particles {
	AOCCoord3D *origin = [AOCCoord3D origin];
	NSArray<D20Particle *> *sorted = [self sortByMD:particles];
	BOOL isStable = NO;
	int i = 0;
	NSString *prevTopTen = @"";
	while (!isStable) {
		if (i % 500 == 0) {
			NSMutableString *topTen = [NSMutableString string];
			sorted = [self sortByMD:particles];
			for (int i = 0; i < 10 && i < sorted.count; i++) {
				[topTen appendFormat: @"%d,", sorted[i].pid];
			}
			//NSLog(@"%@", topTen);
			if ([topTen isEqualToString:prevTopTen]) {
				isStable = YES;
			}
			prevTopTen = topTen;
		}
		for (D20Particle *particle in sorted) {
			[particle update];
		}
		i++;
	}
	
	// 251 too high
	return [NSString stringWithFormat:@"%d", sorted[0].pid];
}

- (NSString *)solvePartTwo:(NSArray<NSString *> *)input {
	
	return @"World";
}

- (NSArray<D20Particle *> *)sortByMD:(NSArray<D20Particle *> *)particles
{
	AOCCoord3D *origin = [AOCCoord3D origin];
	return [particles sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
		D20Particle *p1 = (D20Particle *)obj1;
		D20Particle *p2 = (D20Particle *)obj2;
		NSInteger md1 = [p1.p manhattanDistanceTo:origin];
		NSInteger md2 = [p2.p manhattanDistanceTo:origin];
		if ( md1 < md2 ) {
			return (NSComparisonResult)NSOrderedAscending;
		} else if ( md1 > md2 ) {
			return (NSComparisonResult)NSOrderedDescending;
		}
		return (NSComparisonResult)NSOrderedSame;
	}];
}

@end

@implementation D20Particle

+ (D20Particle *)particle:(NSString *)defn
{
	return [[D20Particle alloc] init:defn];
}

- (D20Particle *)init:(NSString *)defn
{
	// Example defn: p=< 3,0,0>, v=< 2,0,0>, a=<-1,0,0>
	self = [super init];
	NSString *csv = [defn stringByReplacingWithPattern:@"[^\\d,-]" withTemplate:@"" error:nil];
	NSArray<NSNumber *> *nums = [[csv componentsSeparatedByString:@","] valueForKey:@"integerValue"];
	
	_pid = 0;
	_p = [AOCCoord3D x:nums[0].intValue y:nums[1].intValue z:nums[2].intValue];
	_v = [AOCCoord3D x:nums[3].intValue y:nums[4].intValue z:nums[5].intValue];
	_a = [AOCCoord3D x:nums[6].intValue y:nums[7].intValue z:nums[8].intValue];

	return self;
}

- (void)update
{
	self.v = [self.v add:self.a];
	self.p = [self.p add:self.v];
}

@end
