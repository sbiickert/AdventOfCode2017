//
//  AOCDay18.m
//  AoC2017
//

#import <Foundation/Foundation.h>
#import "AOCDay18.h"
#import "AOCStrings.h"

@interface DuetInstruction : NSObject

+ (DuetInstruction *) instruction:(NSString *)definition;
- (DuetInstruction *)init:(NSString *)instruction regX:(NSString *)regX regY:(NSString *)regY value:(NSNumber *)value;

@property (readonly) NSString *instruction;
@property (readonly) NSString *regX;
@property (readonly) NSString *regY;
@property (readonly) NSNumber *value;

@end

@interface DuetPlayer : NSObject

- (DuetPlayer *)init;

@property NSNumber *lastPlayedFrequency;
@property NSMutableDictionary<NSString *, NSNumber *> *registers;

- (NSNumber *)valueInRegister:(NSString *)reg;

@end

@implementation AOCDay18

- (AOCDay18 *)init {
	self = [super initWithDay:18 name:@"Duet"];
	return self;
}

- (struct AOCResult)solveInputIndex:(int)index inFile:(NSString *)filename {
	struct AOCResult result = [super solveInputIndex:index inFile:filename];
	
	NSArray<NSString *> *input = [AOCInput readGroupedInputFile:filename atIndex:index];
	
	NSMutableArray<DuetInstruction *> *instructions = [NSMutableArray array];
	for (NSString *line in input) {
		[instructions addObject:[DuetInstruction instruction:line]];
	}
	
	result.part1 = [self solvePartOne: instructions];
	result.part2 = [self solvePartTwo: input];
	
	return result;
}

- (NSString *)solvePartOne:(NSArray<DuetInstruction *> *)instructions {
	DuetPlayer *player = [[DuetPlayer alloc] init];
	int ptr = 0;
	NSNumber *firstRecoveredFrequency = nil;
	
	while (YES) {
		DuetInstruction *i = instructions[ptr];
		if ([i.instruction isEqualToString:@"snd"]) {
			player.lastPlayedFrequency = [player valueInRegister:i.regX];
			ptr++;
		}
		else if ([i.instruction isEqualToString:@"set"]) {
			NSNumber *yValue = i.value == nil ? [player valueInRegister:i.regY] : i.value;
			player.registers[i.regX] = yValue;
			ptr++;
		}
		else if ([i.instruction isEqualToString:@"add"]) {
			NSNumber *yValue = i.value == nil ? [player valueInRegister:i.regY] : i.value;
			player.registers[i.regX] = @(player.registers[i.regX].integerValue + yValue.integerValue);
			ptr++;
		}
		else if ([i.instruction isEqualToString:@"mul"]) {
			NSNumber *yValue = i.value == nil ? [player valueInRegister:i.regY] : i.value;
			player.registers[i.regX] = @(player.registers[i.regX].integerValue * yValue.integerValue);
			ptr++;
		}
		else if ([i.instruction isEqualToString:@"mod"]) {
			NSNumber *yValue = i.value == nil ? [player valueInRegister:i.regY] : i.value;
			player.registers[i.regX] = @(player.registers[i.regX].integerValue % yValue.integerValue);
			ptr++;
		}
		else if ([i.instruction isEqualToString:@"rcv"]) {
			if (player.registers[i.regX].integerValue != 0) {
				firstRecoveredFrequency = player.lastPlayedFrequency;
				break;
			}
			ptr++;
		}
		else if ([i.instruction isEqualToString:@"jgz"]) {
			if (player.registers[i.regX].integerValue > 0) {
				NSNumber *yValue = i.value == nil ? [player valueInRegister:i.regY] : i.value;
				ptr += yValue.integerValue;
			}
			else {
				ptr++;
			}
		}
	}
	
	return [NSString stringWithFormat:@"%@", firstRecoveredFrequency];
}

- (NSString *)solvePartTwo:(NSArray<NSString *> *)input {
	
	return @"World";
}

@end

@implementation DuetInstruction

+ (DuetInstruction *) instruction:(NSString *)definition
{
	NSArray<NSString *> *parts = [definition componentsSeparatedByString:@" "];
	NSString *y = nil;
	NSNumber *value = nil;
	if (parts.count > 2) {
		if (parts[2].isAllDigits) {
			value = @(parts[2].integerValue);
		}
		else {
			y = parts[2]; // Register name
		}
	}
	return [[DuetInstruction alloc] init:parts[0] regX:parts[1] regY:y value:value];
}

- (DuetInstruction *)init:(NSString *)instruction regX:(NSString *)regX regY:(NSString *)regY value:(NSNumber *)value
{
	self = [super init];
	_instruction = instruction;
	_regX = regX;
	_regY = regY;
	_value = value;
	return self;
}

@end

@implementation DuetPlayer

- (DuetPlayer *)init
{
	self = [super init];
	self.lastPlayedFrequency = nil;
	self.registers = [NSMutableDictionary dictionary];
	return self;
}

- (NSNumber *)valueInRegister:(NSString *)reg
{
	NSNumber *result = [self.registers objectForKey:reg];
	if (result == nil) {
		result = @0;
	}
	return result;
}


@end
