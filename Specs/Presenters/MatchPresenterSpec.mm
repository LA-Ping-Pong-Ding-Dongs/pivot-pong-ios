#import "MatchPresenter.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(MatchPresenterSpec)

describe(@"MatchPresenter", ^{
    __block MatchPresenter *presenter;
    __block id<BSBinder, BSInjector> injector;

    beforeEach(^{
        injector = [Factory injector];
        NSDictionary *winner = @{@"key": @"the-winner"};
        NSDictionary *loser  = @{@"key": @"the-loser"};
        presenter = [injector getInstance:[MatchPresenter class] withArgs:winner, loser, nil];
    });

    describe(@"present", ^{
        it(@"returns a dictionary representation of a match result", ^{
            expect([presenter present]).to(equal(@{@"match": @{@"winner": @"the-winner", @"loser": @"the-loser"}}));
        });
    });
});

SPEC_END
