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
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:PivotPongCurrentUserKey];
    });

    it(@"is a PlayerTableViewController", ^{
        expect([controller isKindOfClass:[PlayerTableViewController class]]).to(be_truthy);
    });

    describe(@"when the view loads", ^{
        beforeEach(^{
            PivotPongClient<CedarDouble> *client = nice_fake_for([PivotPongClient class]);
            [injector bind:[PivotPongClient class] toInstance:client];
            KSDeferred *deferred = [injector getInstance:[KSDeferred class]];
            [deferred resolveWithValue:@[
                                         @{@"name": @"Bob Tuna",
                                             @"url": @"/players/btuna",
                                             @"mean": @1112,
                                             @"key": @"btuna"},

                                         @{@"name": @"Zargon",
                                             @"url": @"/players/zargon",
                                             @"mean": @3434,
                                             @"key": @"zargon"}
                                       ]];
            client stub_method("getPlayers").and_return(deferred.promise);
            (void)controller.view;
        });

        it(@"sets itself as the datasource and delegate",^{
            expect(controller.tableView.dataSource).to(be_same_instance_as(controller));
            expect(controller.tableView.delegate).to(be_same_instance_as(controller));
        });

        it(@"displays the players in the table view", ^{
            expect([controller.tableView numberOfRowsInSection:0]).to(equal(2));
            UITableViewCell *cell = [controller.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            expect(cell.textLabel.text).to(equal(@"Bob Tuna"));

            cell = [controller.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
            expect(cell.textLabel.text).to(equal(@"Zargon"));
        });

        describe(@"choosing a user", ^{
            it(@"persists the user in the standard user defaults", ^{
                expect([controller.tableView numberOfRowsInSection:0]).to(equal(2));
                expect([[NSUserDefaults standardUserDefaults] objectForKey:PivotPongCurrentUserKey]).to(be_nil);
                [[controller.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]] tap];
                [controller.navigationItem.rightBarButtonItem tap];
                expect([[NSUserDefaults standardUserDefaults] objectForKey:PivotPongCurrentUserKey][@"name"]).to(equal(@"Bob Tuna"));
            });
        });
    });

});

SPEC_END
