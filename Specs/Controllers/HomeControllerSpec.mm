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
        UIWindow *window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        window.rootViewController = nav;
    });

    describe(@"When a user has not yet been identified", ^{
        beforeEach(^{
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"currentUser"];
            (void)homeController.view;
        });

        it(@"presents the Identification Controller as a modal", ^{
            expect(homeController.presentedViewController).to(be_instance_of([IdentificationController class]));
        });

        it(@"assigns the injector", ^{
            IdentificationController *identification = (IdentificationController *)homeController.presentedViewController;
            expect(identification.injector).to(be_same_instance_as(injector));
        });
    });
});

SPEC_END
