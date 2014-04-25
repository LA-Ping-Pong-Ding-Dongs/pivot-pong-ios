#import "PivotPongClient.h"
#import "KSDeferred.h"
#import "DataClient.h"

@interface PivotPongClient ()

@property (nonatomic, strong) DataClient *dataClient;
@property (nonatomic, strong) NSDictionary *apiURLs;

@end

@implementation PivotPongClient

@synthesize injector = _injector;

+(BSInitializer *)bsInitializer {
    return [BSInitializer initializerWithClass:self
                                      selector:@selector(initWithDataClient:apiURLs:)
                                  argumentKeys:[DataClient class], PivotPongApiURLs, nil];
}

-(instancetype)initWithDataClient:(DataClient *)dataClient
                        apiURLs:(NSDictionary *)apiURLs {
    if (self = [super init]) {
        self.dataClient = dataClient;
        self.apiURLs    = apiURLs;
    }
    return self;
}

-(KSPromise *)getPlayers {
    NSString *url = [self.apiURLs objectForKey:PivotPongApiGetPlayersKey];
    return [[self.dataClient fetchUrl:url] then:^NSArray *(NSDictionary *jsonData) {
        return [jsonData objectForKey:PivotPongApiGetPlayersJSONResponseKey];
    } error:nil];
}

-(KSPromise *)getMatches {
    NSString *url = [self.apiURLs objectForKey:PivotPongApiGetMatchesKey];
    return [[self.dataClient fetchUrl:url] then:^NSArray *(NSDictionary *jsonData) {
        return [jsonData objectForKey:PivotPongApiGetMatchesJSONResponseKey];
    } error:nil];
}

-(KSPromise *)postMatch:(NSDictionary *)data {
    NSString *url = [self.apiURLs objectForKey:PivotPongApiPostMatchKey];
    return [[self.dataClient postData:data url:url] then:^NSArray *(NSDictionary *jsonData) {
        return [jsonData objectForKey:PivotPongApiPostMatchJSONResponseKey];
    } error:nil];
}

@end

