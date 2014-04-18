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

        describe(@"fetching players", ^{
            it(@"sets the table view with players fetched from the API", ^{
                expect([controller tableView:controller.tableView numberOfRowsInSection:0]).to(equal(2));
            });

            it(@"populates the cells with the player data", ^{
                NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
                UITableViewCell *cell = [controller.tableView cellForRowAtIndexPath:path];
                expect([cell valueForKey:@"name"]).to(equal(@"Bob Tuna")); // need to setup table view cells with name property...
            });
        });


    });
});

SPEC_END
