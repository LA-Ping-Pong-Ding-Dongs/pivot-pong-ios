#import "HomeController.h"
#import "IdentificationController.h"
#import "AttestationController.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(HomeControllerSpec)

describe(@"HomeController", ^{
    __block HomeController *homeController;
    __block id<BSInjector, BSBinder> injector;
    __block UINavigationController *nav;

    beforeEach(^{
        injector = [Factory injector];
        homeController = (HomeController *)[Factory viewControllerFromStoryBoard:[HomeController class] injector:injector];
        nav = [[UINavigationController alloc] initWithRootViewController:homeController];
    });

    describe(@"When a user has not yet been identified", ^{
        beforeEach(^{
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:PivotPongCurrentUserKey];
            (void)homeController.view;
        });

        it(@"presents the Identification Controller as a modal", ^{
            expect(homeController.presentedViewController).to(be_instance_of([UINavigationController class]));
            expect(((UINavigationController *)homeController.presentedViewController).topViewController).to(be_instance_of([IdentificationController class]));
        });
    });

    describe(@"making a win/loss declaration", ^{
        beforeEach(^{
            [[NSUserDefaults standardUserDefaults] setObject:@"Bob Tuna" forKey:@"currentUser"];
            (void)homeController.view;
        });

        context(@"winning", ^{
            it(@"takes the user to the attestation controller", ^{
                [homeController.wonButton tap];
                AttestationController *destinationController = (AttestationController *)homeController.navigationController.topViewController;
                expect(destinationController).to(be_instance_of([AttestationController class]));
                expect(destinationController.won).to(equal(YES));
            });
        });

        context(@"losing", ^{
            it(@"takes the user to the attestation controller", ^{
                [homeController.lostButton tap];
                AttestationController *destinationController = (AttestationController *)homeController.navigationController.topViewController;
                expect(destinationController).to(be_instance_of([AttestationController class]));
                expect(destinationController.won).to(equal(NO));
            });
        });
    });
});

SPEC_END
