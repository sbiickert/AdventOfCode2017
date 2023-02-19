//
//  AOCDay18.m
//  AoC2017
//

#import <Foundation/Foundation.h>
#import "AOCDay.h"
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

@property NSInteger ptr;
@property NSInteger sendCount;
@property NSNumber *lastPlayedFrequency;
@property NSMutableDictionary<NSString *, NSNumber *> *registers;
@property NSMutableArray<NSNumber *> *queue;

- (NSNumber *)valueInRegister:(NSString *)reg;

- (void)push:(NSNumber *)n;
- (NSNumber *)pop;

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
	result.part2 = [self solvePartTwo: instructions];
	
	return result;
}

- (NSString *)solvePartOne:(NSArray<DuetInstruction *> *)instructions {
	DuetPlayer *player = [[DuetPlayer alloc] init];
	NSNumber *firstRecoveredFrequency = nil;
	
	while (YES) {
		DuetInstruction *i = instructions[player.ptr];
		if ([i.instruction isEqualToString:@"snd"]) {
			player.lastPlayedFrequency = [player valueInRegister:i.regX];
			player.ptr++;
		}
		else if ([i.instruction isEqualToString:@"rcv"]) {
			if (player.registers[i.regX].integerValue != 0) {
				firstRecoveredFrequency = player.lastPlayedFrequency;
				break;
			}
			player.ptr++;
		}
		else {
			[self commonInstruction:player instruction:i];
		}
		if (player.ptr >= instructions.count) {
			break;
		}
	}
	
	return [NSString stringWithFormat:@"%@", firstRecoveredFrequency];
}

- (NSString *)solvePartTwo:(NSArray<DuetInstruction *> *)instructions {
	DuetPlayer *currentPlayer = [[DuetPlayer alloc] init];
	currentPlayer.registers[@"p"] = @0;
	currentPlayer.registers[@"player_id"] = @0;
	DuetPlayer *otherPlayer = [[DuetPlayer alloc] init];
	otherPlayer.registers[@"p"] = @1;
	otherPlayer.registers[@"player_id"] = @1;

	BOOL isDeadlock = NO;
	while (!isDeadlock) {
		while (YES) {
			DuetInstruction *i = instructions[currentPlayer.ptr];
			if ([i.instruction isEqualToString:@"snd"]) {
				if (instructions.count < 10 && i.regX.isAllDigits) {
					[otherPlayer push:@(i.regX.integerValue)];
				}
				else {
					[otherPlayer push:[currentPlayer valueInRegister:i.regX]];
				}
				currentPlayer.sendCount++;
				currentPlayer.ptr++;
			}
			else if ([i.instruction isEqualToString:@"rcv"]) {
				NSNumber *value = [currentPlayer pop];
				if (value != nil) {
					currentPlayer.registers[i.regX] = value;
					currentPlayer.ptr++;
				}
				else {
					break;
				}
			}
			else {
				[self commonInstruction:currentPlayer instruction:i];
			}
		}
		
		// swap
		id temp = currentPlayer;
		currentPlayer = otherPlayer;
		otherPlayer = temp;
		
		isDeadlock = currentPlayer.queue.count == 0 && otherPlayer.queue.count == 0;
	}
	
	NSInteger sendCount = 0;
	
	if ([currentPlayer.registers[@"player_id"] isEqualToNumber:@1]) {
		sendCount = currentPlayer.sendCount;
	}
	else {
		sendCount = otherPlayer.sendCount;
	}
	
	return [NSString stringWithFormat:@"%ld", sendCount];
}

- (void)commonInstruction:(DuetPlayer *)player instruction:(DuetInstruction *)i
{
	NSNumber *yValue = i.value == nil ? [player valueInRegister:i.regY] : i.value;
	if ([i.instruction isEqualToString:@"set"]) {
		player.registers[i.regX] = yValue;
		player.ptr++;
	}
	else if ([i.instruction isEqualToString:@"add"]) {
		player.registers[i.regX] = @(player.registers[i.regX].integerValue + yValue.integerValue);
		player.ptr++;
	}
	else if ([i.instruction isEqualToString:@"mul"]) {
		player.registers[i.regX] = @(player.registers[i.regX].integerValue * yValue.integerValue);
		player.ptr++;
	}
	else if ([i.instruction isEqualToString:@"mod"]) {
		player.registers[i.regX] = @(player.registers[i.regX].integerValue % yValue.integerValue);
		player.ptr++;
	}
	else if ([i.instruction isEqualToString:@"jgz"]) {
		// There is one jgz instruction with a literal "1". Ignore -> infinite runtime 🤦‍♂️
		if (player.registers[i.regX].integerValue > 0 || [i.regX isEqualToString:@"1"]) {
			player.ptr += yValue.integerValue;
		}
		else {
			player.ptr++;
		}
	}
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
	self.ptr = 0;
	self.sendCount = 0;
	self.lastPlayedFrequency = nil;
	self.registers = [NSMutableDictionary dictionary];
	self.queue = [NSMutableArray array];
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

- (void)push:(NSNumber *)n
{
	[self.queue addObject:n];
}

- (NSNumber *)pop
{
	NSNumber *result = self.queue.firstObject;
	if (result != nil) {
		[self.queue removeObjectAtIndex:0];
	}
	return result;
}


@end
