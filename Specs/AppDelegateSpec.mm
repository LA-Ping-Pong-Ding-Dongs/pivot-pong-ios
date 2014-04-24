#import "AppDelegate.h"
#import "Configurator.h"
#import "HomeController.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(AppDelegateSpec)

fdescribe(@"AppDelegate", ^{
    __block AppDelegate *delegate;
    __block id<BSInjector> injector;

    beforeEach(^{
        injector = [Blindside injectorWithModule:[[Configurator alloc] init]];
        delegate = [injector getInstance:[AppDelegate class]];
        delegate.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    });

    describe(@"-application:didFinishLaunchingWithOptions:", ^{
        it(@"sets the injector on the root view controller", ^{
            [delegate application:nil didFinishLaunchingWithOptions:nil];
            UINavigationController *nav = (UINavigationController *)delegate.window.rootViewController;

            HomeController *homeController = (HomeController *)nav.topViewController;
            expect(homeController.injector).to(be_same_instance_as(delegate.injector));
        });
    });
});

SPEC_END
