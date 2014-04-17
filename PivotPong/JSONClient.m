#import "JSONClient.h"
#import "HTTPClient.h"

@interface JSONClient ()
@property (nonatomic, strong) HTTPClient *httpClient;
@end

@implementation JSONClient

@synthesize injector = _injector;

+(BSInitializer *)bsInitializer {
    return [BSInitializer initializerWithClass:self
                                      selector:@selector(initWithHTTPClient:)
                                  argumentKeys:[HTTPClient class], nil];
}

-(instancetype)initWithHTTPClient:(HTTPClient *)httpClient {
    if (self = [super init]) {
        self.httpClient = httpClient;
    }
    return self;
}

-(KSPromise *)fetchUrl:(NSString *)urlString {
    KSDeferred *deferred = [self.injector getInstance:[KSDeferred class]];

    [[self.httpClient fetchUrl:urlString] then:^NSDictionary *(NSData *data) {
        NSError *error;
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];

        if (error) {
            [deferred rejectWithError:error];
        } else {
            [deferred resolveWithValue:result];
        }
        return result;
    } error:^id(NSError *error) {
        [deferred rejectWithError:error];
        return error;
    }];

    return deferred.promise;
}

@end
