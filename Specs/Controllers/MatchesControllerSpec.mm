#import "MatchesController.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(MatchesControllerSpec)

describe(@"MatchesController", ^{
    __block MatchesController *controller;
    __block id<BSBinder, BSInjector>injector;
    
    beforeEach(^{
        injector = [Factory injector];
        controller = (MatchesController *)[Factory viewControllerFromStoryBoard:[MatchesController class] injector:injector];
    });
    
    describe(@"when the view loads", ^{
        beforeEach(^{
            PivotPongClient<CedarDouble> *client = nice_fake_for([PivotPongClient class]);
            [injector bind:[PivotPongClient class] toInstance:client];
            KSDeferred *deferred = [injector getInstance:[KSDeferred class]];
            [deferred resolveWithValue:@[
                                         @{PivotPongApiMatchesWinnerKey: @"Bob Tuna",
                                           PivotPongApiMatchesLoserKey:  @"Zargon"},
                                         @{PivotPongApiMatchesWinnerKey: @"Suzanne Reilley",
                                           PivotPongApiMatchesLoserKey:  @"Jerry Seinfeld"}
                                         ]];
            client stub_method("getMatches").and_return(deferred.promise);
            (void)controller.view;
        });
        
        it(@"sets itself as the datasource and delegate",^{
            expect(controller.tableView.dataSource).to(be_same_instance_as(controller));
            expect(controller.tableView.delegate).to(be_same_instance_as(controller));
        });
        
        it(@"displays the matches in the table view", ^{
            expect([controller.tableView numberOfRowsInSection:0]).to(equal(2));
            UITableViewCell *cell = [controller.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            expect(cell.textLabel.text).to(equal(@"Bob Tuna"));
            expect(cell.detailTextLabel.text).to(equal(@"Bob Tuna"));
        });
    });
});

SPEC_END
