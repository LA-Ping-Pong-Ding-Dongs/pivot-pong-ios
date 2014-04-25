#import "Injectable.h"
#import "KSPromise.h"

@interface PivotPongClient : NSObject <Injectable>

-(KSPromise *)getPlayers;
-(KSPromise *)getMatches;
-(KSPromise *)postMatch:(NSDictionary *)data;

@end
