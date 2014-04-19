#import "HTTPClient.h"
#import "KSDeferred.h"
#import "FakeOperationQueue.h"

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
    KSDeferred *deferred = [self.injector getInstance:[KSDeferred class]];
    NSURL *url = [[NSURL alloc] initWithString:urlString];

    [[self.session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        [self.mainQueue addOperationWithBlock:^{
            NSUInteger statusCode = ((NSHTTPURLResponse *)response).statusCode;
            if (!error && statusCode == 200) {
                [deferred resolveWithValue:data];
            } else {
                [deferred rejectWithError:[self deferredErrorFor:error statusCode:statusCode]];
            }
        }];
    }] resume];

    return deferred.promise;
}

-(NSError *)deferredErrorFor:(NSError *)dataTaskWithURlError
                  statusCode:(NSUInteger)statusCode {
    NSString *message;

    if (dataTaskWithURlError) {
        message = NSLocalizedString(@"NetworkConnectivityError", nil);
    } else {
        message = [NSString stringWithFormat:NSLocalizedString(@"ServerResponseError", nil), statusCode];
    }

    return [NSError errorWithDomain:message code:PivotPongErrorCodeServerError userInfo:nil];
}

@end
