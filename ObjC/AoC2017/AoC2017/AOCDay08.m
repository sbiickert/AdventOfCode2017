//
//  AOCDay08.m
//  AoC2017
//

#import <Foundation/Foundation.h>
#import "AOCDay08.h"

@interface AOCInstruction : NSObject

@property (readonly) NSString *targetRegister;
@property (readonly) int factor; // +1 or -1
@property (readonly) int value;
@property (readonly) NSString *compRegister;
@property (readonly) NSString *comparator;
@property (readonly) int compValue;

- (AOCInstruction *)initFromString:(NSString *)defn;
- (BOOL)evalForRegisterValue:(int)rValue;

@end

@implementation AOCDay08

- (AOCDay08 *)init {
	self = [super initWithDay:8 name:@"I Heard You Like Registers"];
	return self;
}

- (struct AOCResult)solveInputIndex:(int)index inFile:(NSString *)filename {
	struct AOCResult result = [super solveInputIndex:index inFile:filename];
	
	NSArray<NSString *> *input = [AOCInput readGroupedInputFile:filename atIndex:index];
	
	NSMutableArray<AOCInstruction *> *instructions = [NSMutableArray array];
	[input enumerateObjectsUsingBlock:^(NSString *line, NSUInteger idx, BOOL *stop) {
		[instructions addObject:[[AOCInstruction alloc] initFromString:line]];
	}];
	
	result.part1 = [self solveParts: instructions];
	result.part2 = @"See part 1";
	
	return result;
}

- (NSString *)solveParts:(NSArray<AOCInstruction *> *)instructions {
	NSMutableDictionary<NSString *, NSNumber *> *registers = [NSMutableDictionary dictionary];

	int peakValue = -1000000;

	for (AOCInstruction *i in instructions) {
		if (registers[i.targetRegister] == nil) {
			[registers setValue:@0 forKey:i.targetRegister];
		}
		if (registers[i.compRegister] == nil) {
			[registers setValue:@0 forKey:i.compRegister];
		}
		if ([i evalForRegisterValue:registers[i.compRegister].intValue]) {
			int newValue = registers[i.targetRegister].intValue + (i.factor * i.value);
			registers[i.targetRegister] = @(newValue);
		}
		int currentMax = [[[registers allValues] valueForKeyPath:@"@max.intValue"] intValue];
		if (currentMax > peakValue) {
			peakValue = currentMax;
		}
	}
	
	int maxValue = [[[registers allValues] valueForKeyPath:@"@max.intValue"] intValue];
	
	return [NSString stringWithFormat:@"Max value: %d, peaked at %d", maxValue, peakValue];
}

@end

@implementation AOCInstruction

- (AOCInstruction *)initFromString:(NSString *)defn
{
	self = [super init];
	NSArray<NSString *> *components = [defn componentsSeparatedByString:@" "];
	
	_targetRegister = components[0];
	_factor = ([components[1] isEqualToString:@"inc"]) ? 1 : -1;
	_value = [components[2] intValue];
	// components[3] is "if"
	_compRegister = components[4];
	_comparator = components[5];
	_compValue = [components[6] intValue];
	
	return self;
}

- (BOOL)evalForRegisterValue:(int)rValue
{
	if ([self.comparator isEqualToString:@"<"]) {
		return rValue < self.compValue;
	}
	if ([self.comparator isEqualToString:@">"]) {
		return rValue > self.compValue;
	}
	if ([self.comparator isEqualToString:@"=="]) {
		return rValue == self.compValue;
	}
	if ([self.comparator isEqualToString:@"!="]) {
		return rValue != self.compValue;
	}
	if ([self.comparator isEqualToString:@"<="]) {
		return rValue <= self.compValue;
	}
	if ([self.comparator isEqualToString:@">="]) {
		return rValue >= self.compValue;
	}
	NSLog(@"Unknown comparator: %@", self.comparator);
	return NO;
}

@end
