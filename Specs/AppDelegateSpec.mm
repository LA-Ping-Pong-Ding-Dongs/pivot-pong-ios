#import "AppDelegate.h"
#import "Configurator.h"
#import "HomeController.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(AppDelegateSpec)

describe(@"AppDelegate", ^{
    __block AppDelegate *delegate;
    __block id<BSInjector> injector;

    beforeEach(^{
        injector = [Blindside injectorWithModule:[[Configurator alloc] init]];
        delegate = [injector getInstance:[AppDelegate class]];
        delegate.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    });

    describe(@"-application:didFinishLaunchingWithOptions:", ^{
        __block HomeController *homeController;
        beforeEach(^{
            homeController = [[HomeController alloc] init];
            delegate.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:homeController];
        });
        
        it(@"sets the injector on the home controller", ^{
            expect(homeController.injector).to(be_nil);
            [delegate application:nil didFinishLaunchingWithOptions:nil];
            expect([(id)homeController.injector conformsToProtocol:@protocol(BSInjector)]).to(be_truthy);
        });
    });
});

SPEC_END
