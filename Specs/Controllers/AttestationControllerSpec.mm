#import "AttestationController.h"
#import "MatchesController.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(AttestationControllerSpec)

describe(@"AttestationController", ^{
    __block AttestationController *controller;
    __block id<BSBinder, BSInjector> injector;
    __block UINavigationController *nav;
    __block NSArray *players = @[
                                 @{@"name": @"Bob Tuna",
                                   @"url": @"/players/btuna",
                                   @"mean": @1112,
                                   @"key": @"btuna"},

                                 @{@"name": @"Zargon",
                                   @"url": @"/players/zargon",
                                   @"mean": @3434,
                                   @"key": @"zargon"}
                                 ];

    beforeEach(^{
        injector = [Factory injector];
        controller = (AttestationController *)[Factory viewControllerFromStoryBoard:[AttestationController class] injector:injector];
        nav = [[UINavigationController alloc] initWithRootViewController:controller];
        [[NSUserDefaults standardUserDefaults] setObject:players.firstObject forKey:PivotPongCurrentUserKey];
    });

    it(@"is a PlayerTableViewController", ^{
        expect([controller isKindOfClass:[PlayerTableViewController class]]).to(be_truthy);
    });

    describe(@"when the view loads", ^{
        beforeEach(^{
            PivotPongClient<CedarDouble> *client = nice_fake_for([PivotPongClient class]);
            [injector bind:[PivotPongClient class] toInstance:client];
            KSDeferred *deferred = [injector getInstance:[KSDeferred class]];
            [deferred resolveWithValue:players];
            client stub_method("getPlayers").and_return(deferred.promise);
            (void)controller.view;
        });
        
        it(@"disables the GO button", ^{
            expect(controller.navigationItem.rightBarButtonItem.enabled).to_not(be_truthy);
        });

        it(@"sets itself as the datasource and delegate",^{
            expect(controller.tableView.dataSource).to(be_same_instance_as(controller));
            expect(controller.tableView.delegate).to(be_same_instance_as(controller));
        });

        it(@"displays the players without the current user in the table view", ^{
            expect([controller.tableView numberOfRowsInSection:0]).to(equal(1));
            UITableViewCell *cell = [controller.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            expect(cell.textLabel.text).to(equal(@"Zargon"));
        });

        describe(@"title", ^{
            it(@"knows when a player won", ^{
                controller.won = NO;
                [controller viewDidLoad];
                expect(controller.title).to(contain(@"lost"));
            });

            it(@"knows when a player lost", ^{
                controller.won = YES;
                [controller viewDidLoad];
                expect(controller.title).to(contain(@"won"));
            });
        });
        
        describe(@"choosing a user", ^{
            beforeEach(^{
                (void)[controller.tableView numberOfRowsInSection:0];
            });
            
            it(@"enables the GO button", ^{
                [[controller.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]] tap];
                expect(controller.navigationItem.rightBarButtonItem.enabled).to(be_truthy);
            });
        });
        
        describe(@"tapping the GO button", ^{
            beforeEach(^{
                (void)[controller.tableView numberOfRowsInSection:0];
                [[controller.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]] tap];
            });

            it(@"goes to the matches controller", ^{
                [controller.navigationItem.rightBarButtonItem tap];
                expect(controller.navigationController.topViewController).to(be_instance_of([MatchesController class]));
            });
        });
    });
    
});

SPEC_END
