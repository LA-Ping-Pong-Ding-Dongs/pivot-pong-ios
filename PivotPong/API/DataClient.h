#import "KSDeferred.h"
#import "Injectable.h"

@interface DataClient : NSObject<Injectable>

-(KSPromise *)fetchUrl:(NSString *)urlString;
-(KSPromise *)postData:(NSDictionary *)data url:(NSString *)urlString;

@end
