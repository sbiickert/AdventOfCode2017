//
//  main.m
//  AoC2017
//
//  Created by Simon Biickert on 2023-01-28.
//

#import <Foundation/Foundation.h>
#import "AOCSolution.h"
#import "AOCInput.h"
#import "AOCDay01.h"

int main(int argc, const char * argv[]) {
	@autoreleasepool {
	    // insert code here...
	    NSLog(@"Advent of Code 2017");
		
		AOCSolution *s = [[AOCDay01 alloc] init];
		
//		AOCInput *i = [[AOCInput getTestsForSolution:s] objectAtIndex:8];
		AOCInput *i = [AOCInput getChallengeForSolution:s];
		
		struct AOCResult r = [s solveInputIndex:i.index inFile:i.filename];
		
		NSLog(@"Part 1: %@, Part 2: %@", r.part1, r.part2);
	}
	return 0;
}
