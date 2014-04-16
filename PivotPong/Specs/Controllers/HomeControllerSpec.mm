#import "HomeController.h"
#import "IdentificationController.h"
#import "AttestationController.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(HomeControllerSpec)

describe(@"HomeController", ^{
    __block HomeController *homeController;
    __block id<BSInjector> injector;
    __block UINavigationController *nav;
    
    beforeEach(^{
        injector = [Factory injector];
        UIStoryboard *storyBoard = [injector getInstance:[UIStoryboard class]];
        homeController = [storyBoard instantiateViewControllerWithIdentifier:NSStringFromClass([HomeController class])];
        homeController.injector = injector;
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
            UINavigationController *identificationNav = (UINavigationController *)homeController.presentedViewController;
            expect(identificationNav).to(be_instance_of([UINavigationController class]));
            expect(identificationNav.topViewController).to(be_instance_of([IdentificationController class]));
            expect(homeController.navigationController.topViewController).to(be_same_instance_as(homeController));
        });
        
        it(@"assigns the injector", ^{
            UINavigationController *identificationNav = (UINavigationController *)homeController.presentedViewController;
            IdentificationController *identification = (IdentificationController *)identificationNav.topViewController;
            expect(identification.injector).to(be_same_instance_as(injector));
        });
    });
    
    describe(@"When a user has already been identified", ^{
        beforeEach(^{
            NSDictionary *userData = @{@"name": @"Bob Tuna", @"id": @"ABC-123"};
            [[NSUserDefaults standardUserDefaults] setObject:userData forKey:@"currentUser"];
            (void)homeController.view;
        });
        
        it(@"presents the Attestation Controller", ^{
            expect(homeController.presentedViewController).to(be_nil);
            expect(homeController.navigationController.topViewController).to(be_instance_of([AttestationController class]));
        });
        
        it(@"assigns the injector", ^{
            AttestationController *attestation = (AttestationController *)homeController.navigationController.topViewController;
            expect(attestation.injector).to(be_same_instance_as(injector));
        });
    });
});

SPEC_END
