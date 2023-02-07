//
//  AOCCoord2D.h
//  AoC2017
//
//  Created by Simon Biickert on 2023-01-28.
//

extern NSString * const NORTH;
extern NSString * const SOUTH;
extern NSString * const WEST;
extern NSString * const EAST;
extern NSString * const NW;
extern NSString * const NE;
extern NSString * const SW;
extern NSString * const SE;
extern NSString * const HN;  // hex grid
extern NSString * const HS;  // hex grid
extern NSString * const HNW; // hex grid
extern NSString * const HNE; // hex grid
extern NSString * const HSW; // hex grid
extern NSString * const HSE; // hex grid
extern NSString * const UP;
extern NSString * const DOWN;
extern NSString * const LEFT;
extern NSString * const RIGHT;

@interface AOCCoord2D : NSObject <NSCopying>

+ (AOCCoord2D *)origin;
+ (AOCCoord2D *)x:(int)x y:(int)y;
+ (AOCCoord2D *)copyOf:(AOCCoord2D *)other;
+ (AOCCoord2D *)offset:(NSString *)direction;

- (AOCCoord2D *)initX:(int)x y:(int)y;

@property (readonly) int x;
@property (readonly) int y;

- (int)row;
- (int)col;

- (BOOL)isEqualToCoord2D:(AOCCoord2D *)other;

- (AOCCoord2D *)add:(AOCCoord2D *)other;
- (AOCCoord2D *)delta:(AOCCoord2D *)other;
- (AOCCoord2D *)offset:(NSString *)direction;

- (double)distanceTo:(AOCCoord2D *)other;
- (int)manhattanDistanceTo:(AOCCoord2D *)other;

@end
