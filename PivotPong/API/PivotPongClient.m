#import "PivotPongClient.h"
#import "KSDeferred.h"
#import "JSONClient.h"

@interface PivotPongClient ()

@property (nonatomic, strong) JSONClient *jsonClient;
@property (nonatomic, strong) NSDictionary *apiURLs;

@end

@implementation PivotPongClient

@synthesize injector = _injector;

+(BSInitializer *)bsInitializer {
    return [BSInitializer initializerWithClass:self
                                      selector:@selector(initWithJSONClient:apiURLs:)
                                  argumentKeys:[JSONClient class], PivotPongApiURLs, nil];
}

-(instancetype)initWithJSONClient:(JSONClient *)jsonClient
                        apiURLs:(NSDictionary *)apiURLs {
    if (self = [super init]) {
        self.jsonClient = jsonClient;
        self.apiURLs    = apiURLs;
    }
    return self;
}

-(KSPromise *)getPlayers {
    return [self.jsonClient fetchUrl:[self.apiURLs objectForKey:PivotPongGetPlayers]];
}

@end

