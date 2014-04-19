#import "IdentificationController.h"
#import "PivotPongClient.h"
#import "KSDeferred.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(IdentificationControllerSpec)

describe(@"IdentificationController", ^{
    __block IdentificationController *controller;
    __block id<BSBinder, BSInjector> injector;

    beforeEach(^{
        injector = [Factory injector];
        controller = (IdentificationController *)[Factory viewControllerFromStoryBoard:[IdentificationController class] injector:injector];
    });

    it(@"is a UITableViewDelegate", ^{
        expect([controller conformsToProtocol:@protocol(UITableViewDelegate)]).to(be_truthy);
    });

    describe(@"when the view loads", ^{
        beforeEach(^{
            PivotPongClient<CedarDouble> *client = nice_fake_for([PivotPongClient class]);
            [injector bind:[PivotPongClient class] toInstance:client];
            KSDeferred *deferred = [injector getInstance:[KSDeferred class]];
            [deferred resolveWithValue:@{@"players":
                                             @[
                                                 @{@"name": @"Bob Tuna",
                                                   @"url": @"/players/btuna",
                                                   @"mean": @1112,
                                                   @"key": @"btuna"},

                                                 @{@"name": @"Zargon",
                                                   @"url": @"/players/zargon",
                                                   @"mean": @3434,
                                                   @"key": @"zargon"}

                                                 ]}];

            client stub_method("getPlayers").and_return(deferred.promise);
            (void)controller.view;
        });

        it(@"sets itself as the UITableView datasource",^{
            expect(controller.tableView.dataSource).to(be_same_instance_as(controller));
        });

    });
});

SPEC_END
