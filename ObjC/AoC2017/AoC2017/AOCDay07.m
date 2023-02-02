//
//  AOCDay07.m
//  AoC2017
//

#import <Foundation/Foundation.h>
#import "AOCDay07.h"


@interface BalancingTower : NSObject

+ (BalancingTower *)towerWithName:(NSString *)name;

@property (readonly) NSString *name;
@property NSArray<NSString *> *subTowerNames;
@property NSInteger weight;

- (BalancingTower *)initFromString:(NSString *)defn;

- (NSInteger)totalWeight;
- (NSDictionary<NSNumber *, NSArray *> *)organizeSubTowersByWeight;

@end

@implementation AOCDay07

- (AOCDay07 *)init {
	self = [super initWithDay:7 name:@"Recursive Circus"];
	return self;
}

- (struct AOCResult)solveInputIndex:(int)index inFile:(NSString *)filename {
	struct AOCResult result = [super solveInputIndex:index inFile:filename];
	
	NSArray<NSString *> *input = [AOCInput readGroupedInputFile:filename atIndex:index];
	
	NSArray<NSString *> *towerNames = [self parseTowers:input];
	
	result.part1 = [self solvePartOne: towerNames];
	result.part2 = [self solvePartTwo: result.part1];
	
	return result;
}

- (NSString *)solvePartOne:(NSArray<NSString *> *)towerNames {
	NSMutableSet *names = [[NSMutableSet alloc] initWithArray:towerNames];
	
	for (NSString *name in towerNames) {
		BalancingTower *tower = [BalancingTower towerWithName:name];
		for (NSString *name in tower.subTowerNames) {
			[names removeObject:name];
		}
	}
	
	return names.allObjects[0];
}

- (NSString *)solvePartTwo:(NSString *)name {
	NSInteger correctTotalWeight = 0;
	BalancingTower *incorrectTower;
	
	BalancingTower *tower = [BalancingTower towerWithName:name];
	NSDictionary<NSNumber *, NSArray *> *subsByTotalWeight = tower.organizeSubTowersByWeight;
	
	NSString *result = nil;
	
	if (subsByTotalWeight.count > 1) {
		for (NSNumber *key in subsByTotalWeight.allKeys) {
			if ([subsByTotalWeight objectForKey:key].count == 1) {
				incorrectTower = [BalancingTower towerWithName:subsByTotalWeight[key][0]];
			}
			else {
				correctTotalWeight = key.integerValue;
			}
		}
		result = [self solvePartTwo:incorrectTower.name];
		if (result == nil) {
			NSInteger diff = correctTotalWeight - incorrectTower.totalWeight;
			NSInteger newWeight = incorrectTower.weight + diff; //4277 too high
			result = [NSString stringWithFormat:@"Tower %@ needs to weigh %d", incorrectTower.name, newWeight];
		}
	}
	return result;
}

- (NSArray<NSString *> *)parseTowers:(NSArray<NSString *> *)input {
	NSMutableDictionary<NSString *, BalancingTower *> *towers = [NSMutableDictionary dictionary];
	
	for (NSString *line in input) {
		BalancingTower *t = [[BalancingTower alloc] initFromString:line];
		[towers setObject:t forKey:t.name];
	}
	// towers are now accessible via [BalancingTower towerWithName]
	return [towers allKeys];
}

@end

static NSMutableDictionary<NSString *, BalancingTower *> *_allTowers = nil;

@implementation BalancingTower

+ (void)initialize {
	if (_allTowers == nil) {
		_allTowers = [NSMutableDictionary dictionary];
	}
}

+ (BalancingTower *)towerWithName:(NSString *)name {
	return [_allTowers objectForKey:name];
}

- (BalancingTower *)initFromString:(NSString *)defn {
	self = [super init];
	
	NSArray<NSString *> *towerAndSubs = [defn componentsSeparatedByString:@" -> "];
	NSArray<NSString *> *nameAndWeight = [towerAndSubs[0] componentsSeparatedByString:@" "];
	_name = nameAndWeight[0];
	_weight = [[nameAndWeight[1] stringByTrimmingCharactersInSet:NSCharacterSet.punctuationCharacterSet] intValue];
	
	if (towerAndSubs.count > 1) {
		_subTowerNames = [towerAndSubs[1] componentsSeparatedByString:@", "];
	}
	else {
		_subTowerNames = [NSArray array];
	}
	
	[_allTowers setObject:self forKey:self.name];

	return self;
}

- (NSInteger)totalWeight {
	NSInteger total = self.weight;
	
	for (NSString *name in self.subTowerNames) {
		BalancingTower *sub = [BalancingTower towerWithName:name];
		total += sub.totalWeight;
	}
	
	return total;
}

- (NSDictionary<NSNumber *, NSArray *> *)organizeSubTowersByWeight
{
	if (self.subTowerNames.count == 0) {
		return nil;
	}
	NSMutableDictionary<NSNumber *, NSMutableArray *> *tracker = [NSMutableDictionary dictionary];
	
	for (NSString *name in self.subTowerNames) {
		NSInteger weight = [BalancingTower towerWithName:name].totalWeight;
		NSNumber *num = @(weight);
		if ([tracker objectForKey:num] == nil) {
			[tracker setObject:[NSMutableArray arrayWithObject:name] forKey:num];
		}
		else {
			[[tracker objectForKey:num] addObject:name];
		}
	}
	return tracker;
}

@end
