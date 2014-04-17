#import "Factory.h"
#import "Configurator.h"
#import "SpecConfigurator.h"

@implementation Factory

+(id<BSInjector>)injector {
    Configurator *configurator = [[Configurator alloc] init];
    SpecConfigurator *specConfigurator = [[SpecConfigurator alloc] init];

    return [Blindside injectorWithModules:@[configurator, specConfigurator]];
}

@end
