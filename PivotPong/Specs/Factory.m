#import "Factory.h"
#import "Configurator.h"

@implementation Factory

+(id<BSInjector>)injector {
    Configurator *configurator = [[Configurator alloc] init];
    return [Blindside injectorWithModule:configurator];
}

@end
