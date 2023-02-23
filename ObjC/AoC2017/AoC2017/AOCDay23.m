//
//  AOCDay23.m
//  AoC2017
//

#import <Foundation/Foundation.h>
#import "AOCDay.h"
#import "AOCStrings.h"

@interface CoprocInstruction : NSObject

+ (CoprocInstruction *) instruction:(NSString *)definition;
- (CoprocInstruction *)init:(NSString *)instruction regX:(NSString *)regX regY:(NSString *)regY value:(NSNumber *)value;

@property (readonly) NSString *instruction;
@property (readonly) NSString *regX;
@property (readonly) NSString *regY;
@property (readonly) NSNumber *value;

@end

@interface Coprocessor : NSObject

- (Coprocessor *)init;

@property NSInteger ptr;
@property NSMutableDictionary<NSString *, NSNumber *> *registers;
@property BOOL debugMode;

- (void)executeInstruction:(CoprocInstruction *)cpi;
- (NSNumber *)valueInRegister:(NSString *)reg;

@end

@implementation AOCDay23

- (AOCDay23 *)init {
	self = [super initWithDay:23 name:@"Coprocessor Conflagration"];
	return self;
}

- (struct AOCResult)solveInputIndex:(int)index inFile:(NSString *)filename {
	struct AOCResult result = [super solveInputIndex:index inFile:filename];
	
	NSArray<NSString *> *input = [AOCInput readGroupedInputFile:filename atIndex:index];
	
	NSMutableArray<CoprocInstruction *> *instructions = [NSMutableArray array];
	for (NSString *line in input) {
		[instructions addObject:[CoprocInstruction instruction:line]];
	}
	
	result.part1 = [self solvePartOne: instructions];
	result.part2 = [self solvePartTwo: instructions];
	
	return result;
}

- (NSString *)solvePartOne:(NSArray<CoprocInstruction *> *)instructions {
	Coprocessor *coproc = [[Coprocessor alloc] init];
	coproc.debugMode = NO;
	NSInteger mulCount = 0;
	
	while (YES) {
		CoprocInstruction *i = instructions[coproc.ptr];
		//[[NSString stringWithFormat:@"%ld", coproc.ptr] println];
		if ([i.instruction isEqualToString:@"mul"]) {
			mulCount++;
		}
		[coproc executeInstruction:i];
		if (coproc.ptr < 0 || coproc.ptr >= instructions.count) {
			break;
		}
	}
	
	return [NSString stringWithFormat:@"%ld", mulCount];
}

- (NSString *)solvePartTwo:(NSArray<CoprocInstruction *> *)instructions {
	
	
	return [NSString stringWithFormat:@"World"];
}

@end

@implementation CoprocInstruction

+ (CoprocInstruction *) instruction:(NSString *)definition
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
	return [[CoprocInstruction alloc] init:parts[0] regX:parts[1] regY:y value:value];
}

- (CoprocInstruction *)init:(NSString *)instruction regX:(NSString *)regX regY:(NSString *)regY value:(NSNumber *)value
{
	self = [super init];
	_instruction = instruction;
	_regX = regX;
	_regY = regY;
	_value = value;
	return self;
}

@end

@implementation Coprocessor

- (Coprocessor *)init
{
	self = [super init];
	self.ptr = 0;
	self.registers = [NSMutableDictionary dictionary];
	self.debugMode = NO;
	return self;
}

- (void)executeInstruction:(CoprocInstruction *)cpi
{
	NSNumber *yValue = cpi.value == nil ? [self valueInRegister:cpi.regY] : cpi.value;
	if ([cpi.instruction isEqualToString:@"set"]) {
		if (self.debugMode) { [[NSString stringWithFormat:@"%@ [%@] to %@", cpi.instruction, cpi.regX, yValue] println]; }
		self.registers[cpi.regX] = yValue;
		self.ptr++;
	}
	else if ([cpi.instruction isEqualToString:@"sub"]) {
		NSInteger newValue = self.registers[cpi.regX].integerValue - yValue.integerValue;
		if (self.debugMode) { [[NSString stringWithFormat:@"%@ [%@] = %ld", cpi.instruction, cpi.regX, newValue] println]; }
		self.registers[cpi.regX] = @(newValue);
		self.ptr++;
	}
	else if ([cpi.instruction isEqualToString:@"mul"]) {
		NSInteger newValue = self.registers[cpi.regX].integerValue * yValue.integerValue;
		if (self.debugMode) { [[NSString stringWithFormat:@"%@ [%@] = %ld", cpi.instruction, cpi.regX, newValue] println]; }
		self.registers[cpi.regX] = @(newValue);
		self.ptr++;
	}
	else if ([cpi.instruction isEqualToString:@"jnz"]) {
		// There are some jnz instructions with literal "1"
		if (self.registers[cpi.regX].integerValue != 0 || [cpi.regX isEqualToString:@"1"]) {
			if (self.debugMode) { [[NSString stringWithFormat:@"%@ %@", cpi.instruction, yValue] println]; }
			self.ptr += yValue.integerValue;
		}
		else {
			self.ptr++;
		}
	}
	else {
		NSLog(@"Unknown instruction %@", cpi.instruction);
	}
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
