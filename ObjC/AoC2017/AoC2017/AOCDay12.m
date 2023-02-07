//
//  AOCDay12.m
//  AoC2017
//

#import <Foundation/Foundation.h>
#import "AOCDay12.h"

@implementation AOCDay12

- (AOCDay12 *)init {
	self = [super initWithDay:12 name:@"Digital Plumber"];
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
	NSDictionary<NSString *, NSSet<NSString *> *> *connections = [self buildConnections:input];
	NSMutableSet<NSString *> *connected = [NSMutableSet setWithObject:@"0"];
	
	[self findConnectedTo:@"0" connections:connections connected:connected];
	
	return [NSString stringWithFormat:@"%ld", connected.count];
}

- (NSString *)solvePartTwo:(NSArray<NSString *> *)input {
	
	return @"World";
}

- (void)findConnectedTo:(NSString *)program
			connections:(NSDictionary<NSString *, NSSet<NSString *> *> *)connections
			  connected:(NSMutableSet *)connected
{
	//NSLog(@"Finding connections to %@", program);
	for (NSString *other in connections[program]) {
		if ([connected containsObject:other]) {
			continue;
		}
		[connected addObject:other];
		[self findConnectedTo:other connections:connections connected:connected];
	}
}

- (NSDictionary<NSString *, NSSet<NSString *> *> *)buildConnections:(NSArray<NSString *> *)input
{
	NSMutableDictionary<NSString *, NSSet<NSString *> *> *result = [NSMutableDictionary dictionary];
	
	for (NSString *line in input) {
		NSArray<NSString *> *parts = [line componentsSeparatedByString:@" <-> "];
		NSSet<NSString *> *linked = [NSSet setWithArray: [parts[1] componentsSeparatedByString:@", "]];
		result[parts[0]] = linked;
	}
	
	return result;
}

@end
