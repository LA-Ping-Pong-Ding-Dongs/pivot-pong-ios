#import "Injectable.h"

@class KSPromise;

@interface PivotPongClient : NSObject <Injectable>

-(KSPromise *)getPlayers;
-(KSPromise *)postMatch:(NSDictionary *)data;

@end
