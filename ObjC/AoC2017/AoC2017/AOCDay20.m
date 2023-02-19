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
	
	result.part1 = [self solvePartOne: [self parseParticles:input]];
	result.part2 = [self solvePartTwo: [self parseParticles:input]];
	
	return result;
}

- (NSString *)solvePartOne:(NSArray<D20Particle *> *)particles {
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
	
	return [NSString stringWithFormat:@"%d", sorted[0].pid];
}

- (NSString *)solvePartTwo:(NSArray<D20Particle *> *)particles {
	NSArray<D20Particle *> *remaining = [self collide:particles];
	BOOL isStable = NO;
	int i = 0;
	NSInteger prevCount = remaining.count+1;
	while (!isStable) {
		if (i % 500 == 0) {
			//NSLog(@"%@", topTen);
			if (remaining.count == prevCount) {
				isStable = YES;
			}
			prevCount = remaining.count;
		}
		for (D20Particle *particle in remaining) {
			[particle update];
		}
		remaining = [self collide:remaining];
		i++;
	}
	
	return [NSString stringWithFormat:@"%ld", remaining.count];
}

- (NSArray<D20Particle *> *)parseParticles:(NSArray<NSString *> *)input
{
	NSMutableArray<D20Particle *> *particles = [NSMutableArray array];
	int i = 0;
	for (NSString *line in input) {
		D20Particle *p = [D20Particle particle:line];
		p.pid = i;
		[particles addObject:p];
		i++;
	}
	return particles;
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

- (NSArray<D20Particle *> *)collide:(NSArray<D20Particle *> *)particles
{
	NSMutableDictionary<AOCCoord3D *, NSMutableArray<D20Particle *> *> *dict = [NSMutableDictionary dictionary];
	
	for (D20Particle *p in particles) {
		if (dict[p.p] == nil) {
			dict[p.p] = [NSMutableArray array];
		}
		[dict[p.p] addObject:p];
	}
	
	NSMutableArray<D20Particle *> *result = [NSMutableArray array];
	for (NSArray *arr in dict.allValues) {
		if (arr.count == 1) {
			[result addObject:arr.firstObject];
		}
	}
	
	return result;
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
