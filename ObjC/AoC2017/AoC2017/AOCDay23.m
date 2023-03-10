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
- (void)printRegisters;

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
	//result.part2 = [self solvePartTwoLiterally]; // Takes 7 hours
	result.part2 = [self solvePartTwoOptimally];

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
//		if (coproc.ptr == 20) {
//			NSLog(@"20");
//			[coproc printRegisters];
//		}
//		if (coproc.ptr == 24) {
//			/*
//			 When this gets here, registers are
//			 b: 67 c: 67 d: 67 e: 67 f: 1 g: 0
//			 */
//			NSLog(@"24");
//			[coproc printRegisters];
//		}
//		if (coproc.ptr == 30) {
//			NSLog(@"30");
//			[coproc printRegisters];
//		}
	}
	
	return [NSString stringWithFormat:@"%ld", mulCount];
}

- (NSString *)solvePartTwoLiterally {
	NSInteger a = 0; NSInteger b = 0; NSInteger c = 0; NSInteger d = 0;
	NSInteger e = 0; NSInteger f = 0; NSInteger g = 0; NSInteger h = 0;
	
	a = 1;
	b = 67; //set b 67
	c = b; //set c b
	//jnz a 2  <-- debug mode, a is 1
	//jnz 1 5  <-- jumped
	b *= 100; 	 //mul b 100
	b += 100000; //sub b -100000
	//set c b
	//sub c -17000
	c = b + 17000;
	while (YES) {
		f = 1; //set f 1
		d = 2; //set d 2
		do {
			e = 2; //set e 2
			do {
				//set g d
				//mul g e
				//sub g b
				g = d * e - b;
				//jnz g 2
				if (g == 0) {
					f = 0; //set f 0
				}
				e++; //sub e -1
				//set g e
				//sub g b
				g = e - b;
			} while (g != 0); //jnz g -8
			
			d++; //sub d -1
			//set g d
			//sub g b
			g = d - b;
		} while (g != 0); //jnz g -13
		//jnz f 2
		if (f == 0) {
			h++; //sub h -1
			NSLog(@"a: %ld b: %ld c: %ld d: %ld e: %ld f: %ld g: %ld h: %ld", a, b, c, d, e, f, g, h);
		}
		//set g b
		//sub g c
		g = b - c;
		//jnz g 2
		if (g == 0) {
			//jnz 1 3
			break;
		}
		b += 17; //sub b -17
		
	}//jnz 1 -23
	
	return [NSString stringWithFormat:@"%ld", h]; // 1000, 999 too high, 900 too low
}

- (NSString *)solvePartTwoOptimally
{
	NSInteger h = 0;
	for (int i = 106700; i <= 123700; i += 17) {
		if (![self isPrime: i]) {
			h++;
		}
	}
	return [NSString stringWithFormat:@"%ld", h];
}

- (BOOL)isPrime:(NSInteger)num
{
	NSInteger i = 2;
	while (i*i < num) {
		if (num % i == 0) {
			return NO;
		}
		i++;
	}
	return YES;
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

- (void)printRegisters
{
	for (NSString *key in [self.registers.allKeys sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)])
	{
		[[NSString stringWithFormat:@"%@: %@ ", key, self.registers[key]] print];
	}
	[@"" println];
}

@end
