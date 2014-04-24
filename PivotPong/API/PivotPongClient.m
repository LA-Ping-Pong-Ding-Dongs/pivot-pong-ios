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
    return [[self.dataClient fetchUrl:[self.apiURLs objectForKey:PivotPongApiGetPlayersKey]] then:^NSArray *(NSDictionary *jsonData) {
        return [jsonData objectForKey:PivotPongApiGetPlayersJSONResponseKey];
    } error:nil];
}

-(KSPromise *)postMatch:(NSDictionary *)data {
    return [[self.dataClient postData:data url:[self.apiURLs objectForKey:PivotPongApiPostMatchKey]] then:^NSArray *(NSDictionary *jsonData) {
        return [jsonData objectForKey:PivotPongApiPostMatchJSONResponseKey];
    } error:nil];
    
}

@end

