#import "Injectable.h"
#import "KSPromise.h"

@interface HTTPClient : NSObject <Injectable>

-(KSPromise *)fetchUrl:(NSString *)urlString;
-(KSPromise *)postData:(NSData *)data url:(NSString *)urlString;

@end
