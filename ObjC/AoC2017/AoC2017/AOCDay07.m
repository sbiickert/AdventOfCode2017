//
//  AOCDay07.m
//  AoC2017
//

#import <Foundation/Foundation.h>
#import "AOCDay07.h"


@interface BalancingTower : NSObject

@property (readonly) NSString *name;
@property NSArray<NSString *> *subTowerNames;
@property NSInteger weight;

- (BalancingTower *)initFromString:(NSString *)defn;

@end

@implementation AOCDay07

- (AOCDay07 *)init {
	self = [super initWithDay:7 name:@"Recursive Circus"];
	return self;
}

- (struct AOCResult)solveInputIndex:(int)index inFile:(NSString *)filename {
	struct AOCResult result = [super solveInputIndex:index inFile:filename];
	
	NSArray<NSString *> *input = [AOCInput readGroupedInputFile:filename atIndex:index];
	
	NSDictionary<NSString *, BalancingTower *> *towers = [self parseTowers:input];
	
	result.part1 = [self solvePartOne: towers];
	result.part2 = [self solvePartTwo: input];
	
	return result;
}

- (NSString *)solvePartOne:(NSDictionary<NSString *, BalancingTower *> *)towers {
	NSMutableSet *names = [[NSMutableSet alloc] initWithArray:towers.allKeys];
	
	for (BalancingTower *tower in towers.allValues) {
		for (NSString *name in tower.subTowerNames) {
			[names removeObject:name];
		}
	}
	
	return names.allObjects[0];
}

- (NSString *)solvePartTwo:(NSArray<NSString *> *)input {
	
	return @"World";
}

- (NSDictionary<NSString *, BalancingTower *> *)parseTowers:(NSArray<NSString *> *)input {
	NSMutableDictionary<NSString *, BalancingTower *> *towers = [NSMutableDictionary dictionary];
	
	for (NSString *line in input) {
		BalancingTower *t = [[BalancingTower alloc] initFromString:line];
		[towers setObject:t forKey:t.name];
	}
	
	
	return towers;
}

@end

@implementation BalancingTower

- (BalancingTower *)initFromString:(NSString *)defn {
	self = [super init];
	
	NSArray<NSString *> *towerAndSubs = [defn componentsSeparatedByString:@" -> "];
	NSArray<NSString *> *nameAndWeight = [towerAndSubs[0] componentsSeparatedByString:@" "];
	_name = nameAndWeight[0];
	_weight = [[nameAndWeight[1] stringByTrimmingCharactersInSet:NSCharacterSet.punctuationCharacterSet] intValue];
	
	NSMutableArray<NSString *> *subs = [NSMutableArray array];
	if (towerAndSubs.count > 1) {
		_subTowerNames = [towerAndSubs[1] componentsSeparatedByString:@", "];
	}
	else {
		_subTowerNames = [NSArray array];
	}

	return self;
}

@end
