#import "DataClient.h"
#import "HTTPClient.h"

@interface DataClient ()
@property (nonatomic, strong) HTTPClient *httpClient;
@end

@implementation DataClient

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
    KSDeferred *deferred = [self deferred];
    __weak typeof(self) weakSelf = self;
    [[self.httpClient fetchUrl:urlString] then:^NSDictionary *(NSData *responseData) {
        return [weakSelf resolveOrReject:deferred
                                    data:responseData];
    } error:^id(NSError *error) {
        [deferred rejectWithError:error];
        return error;
    }];

    return deferred.promise;
}

-(KSPromise *)postData:(NSDictionary *)data url:(NSString *)urlString {
    KSDeferred *deferred = [self deferred];

    NSError *parseError;
    NSData *postData = [NSJSONSerialization dataWithJSONObject:data
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&parseError];

    if (!parseError && postData) {
        __weak typeof(self) weakSelf = self;
        [[self.httpClient postData:postData url:urlString] then:^NSDictionary *(NSData *responseData) {
            return [weakSelf resolveOrReject:deferred
                                        data:responseData];
        } error:^id(NSError *error) {
            [deferred rejectWithError:error];
            return error;
        }];
    } else {
        [deferred rejectWithError:parseError];
    }
    return deferred.promise;
}

-(NSDictionary *)resolveOrReject:(KSDeferred *)deferred
                            data:(NSData *)data {
     NSError *parseError;
     NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data
                                                            options:NSJSONReadingMutableContainers
                                                              error:&parseError];

     if (!parseError && result) {
         [deferred resolveWithValue:result];
     } else {
         [deferred rejectWithError:parseError];
     }
     return result;
 }

-(KSDeferred *)deferred {
    return [self.injector getInstance:[KSDeferred class]];
}

@end
