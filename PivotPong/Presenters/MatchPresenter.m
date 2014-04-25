#import "MatchPresenter.h"

@interface MatchPresenter ()
@property (nonatomic, strong) NSString *winnerKey;
@property (nonatomic, strong) NSString *loserKey;
@end

@implementation MatchPresenter

+(BSInitializer *)bsInitializer {
    return [BSInitializer initializerWithClass:self
                                      selector:@selector(initWithWinner:loser:)
                                  argumentKeys:BS_DYNAMIC, BS_DYNAMIC, nil];
}

-(instancetype)initWithWinner:(NSDictionary *)winner
                        loser:(NSDictionary *)loser {
    if (self = [super init]) {
        self.winnerKey = [winner objectForKey:@"key"];
        self.loserKey  = [loser objectForKey:@"key"];
    }
    return self;
}

-(NSDictionary *)present {
    return @{ @"match":
                @{
                      @"winner": self.winnerKey,
                      @"loser":  self.loserKey
                 }
            };
}

@end
