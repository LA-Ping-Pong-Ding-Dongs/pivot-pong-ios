#import "Factory.h"
#import "Configurator.h"
#import "SpecConfigurator.h"

@implementation Factory

+(id<BSInjector>)injector {
    Configurator *configurator = [[Configurator alloc] init];
    SpecConfigurator *specConfigurator = [[SpecConfigurator alloc] init];

    return [Blindside injectorWithModules:@[configurator, specConfigurator]];
}

+(UIViewController *)viewControllerFromStoryBoard:(Class)viewControllerClass
                                         injector:(id<BSInjector, BSBinder>)injector {
    UIStoryboard *storyBoard = [injector getInstance:[UIStoryboard class]];
    UIViewController<Injectable> *controller = [storyBoard instantiateViewControllerWithIdentifier:NSStringFromClass(viewControllerClass)];
    controller.injector = injector;
    return controller;
}

@end
