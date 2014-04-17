#import "Injectable.h"
#import "KSPromise.h"

@interface HTTPClient : NSObject <Injectable>

-(KSPromise *)fetchUrl:(NSString *)urlString;

@end
