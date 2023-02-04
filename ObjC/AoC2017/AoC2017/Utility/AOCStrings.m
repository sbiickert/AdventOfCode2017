//
//  AOCStrings.m
//  AoC2017
//
//  Created by Simon Biickert on 2023-01-28.
//

#import <Foundation/Foundation.h>
#import "AOCStrings.h"

@implementation NSString (AOCString)

-(NSArray<NSString *> *)getAllCharacters {
	NSMutableArray *characters = [[NSMutableArray alloc] initWithCapacity:[self length]];
	for (int i=0; i < [self length]; i++) {
		NSString *ichar  = [NSString stringWithFormat:@"%c", [self characterAtIndex:i]];
		[characters addObject:ichar];
	}
	return characters;
}

- (void)print
{
	printf("%s", [self cStringUsingEncoding:NSUTF8StringEncoding]);
}

- (void)println
{
	printf("%s\n", [self cStringUsingEncoding:NSUTF8StringEncoding]);
}

- (NSString *)stringByReplacingWithPattern:(NSString *)pattern withTemplate:(NSString *)withTemplate error:(NSError **)error {
	NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern
																		   options:NSRegularExpressionCaseInsensitive
																			 error:error];
	return [regex stringByReplacingMatchesInString:self
										   options:0
											 range:NSMakeRange(0, self.length)
									  withTemplate:withTemplate];
}


@end
