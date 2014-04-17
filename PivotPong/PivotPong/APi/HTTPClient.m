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
        NSInteger statusCode = ((NSHTTPURLResponse *)response).statusCode;
        if (statusCode == 200) {
            [deferred resolveWithValue:data];
        } else {
            NSError *responseError = [NSError errorWithDomain:@"Servers borked" code:500 userInfo:nil];
            [deferred rejectWithError:responseError];
        }
    }] resume];

    return deferred.promise;
}

@end
