#import "HTTPClient.h"
#import "KSDeferred.h"

@interface HTTPClient ()
@property (strong, nonatomic) NSURLSession *session;
@end

@implementation HTTPClient

@synthesize injector = _injector;

+(BSInitializer *)bsInitializer {
    return [BSInitializer initializerWithClass:self
                                      selector:@selector(initWithNSURLSession:)
                                  argumentKeys:[NSURLSession class], nil];
}

-(instancetype)initWithNSURLSession:(NSURLSession *)session {
    if (self = [self init]) {
        self.session = session;
    }

    return self;
}

-(KSPromise *)fetchUrl:(NSString *)urlString {
    KSDeferred *deferred = [self.injector getInstance:[KSDeferred class]];
    NSURL *url = [[NSURL alloc] initWithString:urlString];

    [[self.session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSUInteger statusCode = ((NSHTTPURLResponse *)response).statusCode;
        if (!error && statusCode == 200) {
            [deferred resolveWithValue:data];
        } else {
            [deferred rejectWithError:[self deferredErrorFor:error statusCode:statusCode]];
        }
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
