#import "HTTPClient.h"
#import "KSDeferred.h"

@interface HTTPClient ()
@property (strong, nonatomic) NSURLSession *session;
@property (strong, nonatomic) NSOperationQueue *mainQueue;
@end

@implementation HTTPClient

@synthesize injector = _injector;

+(BSInitializer *)bsInitializer {
    return [BSInitializer initializerWithClass:self
                                      selector:@selector(initWithNSURLSession:mainQueue:)
                                  argumentKeys:[NSURLSession class], [NSOperationQueue class], nil];
}

-(instancetype)initWithNSURLSession:(NSURLSession *)session mainQueue:(NSOperationQueue*)mainQueue {
    if (self = [self init]) {
        self.session = session;
        self.mainQueue = mainQueue;
    }

    return self;
}

-(KSPromise *)fetchUrl:(NSString *)urlString {
    KSDeferred *deferred = [self deferred];
    __weak typeof(self) weakSelf = self;
    [[self.session dataTaskWithURL:[NSURL URLWithString:urlString] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        [weakSelf.mainQueue addOperationWithBlock:^{
            [weakSelf resolveOrReject:deferred
                                 data:data
                             response:response
                                error:error
                       expectedStatus:200];
        }];
    }] resume];

    return deferred.promise;
}

-(KSPromise *)postData:(NSData *)data url:(NSString *)urlString {
    KSDeferred *deferred = [self deferred];
    NSMutableURLRequest *request = [self.injector getInstance:[NSMutableURLRequest class]];
    request.HTTPMethod = @"POST";
    request.HTTPBody   = data;
    request.URL        = [NSURL URLWithString:urlString];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
    __weak typeof(self) weakSelf = self;
    [[self.session dataTaskWithRequest:request
                    completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                        [weakSelf resolveOrReject:deferred
                                         data:data
                                     response:response
                                        error:error
                               expectedStatus:201];
                    }] resume];

    return deferred.promise;
}

-(void)resolveOrReject:(KSDeferred *)deferred
                  data:(NSData *)data
              response:(NSURLResponse *)response
                 error:(NSError *)error
        expectedStatus:(NSUInteger)expectedStatus {
    NSUInteger statusCode = ((NSHTTPURLResponse *)response).statusCode;
    if (!error && statusCode == expectedStatus) {
        [deferred resolveWithValue:data];
    } else {
        [deferred rejectWithError:[self errorForStatusCode:statusCode sessionError:error]];
    }
}

-(NSError *)errorForStatusCode:(PivotPongErrorCode)statusCode sessionError:(NSError *)sessionError {
    NSString *message;
    if (sessionError) {
        message = NSLocalizedString(@"NetworkConnectivityError", nil);
    } else {
        message = [NSString stringWithFormat:NSLocalizedString(@"ServerResponseError", nil), statusCode];
    }

    return [NSError errorWithDomain:message code:PivotPongErrorCodeServerError userInfo:nil];
}

-(KSDeferred *)deferred {
    return [self.injector getInstance:[KSDeferred class]];
}

@end
