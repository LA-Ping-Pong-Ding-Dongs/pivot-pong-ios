#import "KSDeferred.h"
#import "Injectable.h"

@interface JSONClient : NSObject<Injectable>

-(KSPromise *)fetchUrl:(NSString *)urlString;

@end
