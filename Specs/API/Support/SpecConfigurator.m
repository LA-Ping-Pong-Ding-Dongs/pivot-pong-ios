#import "SpecConfigurator.h"

@implementation SpecConfigurator

-(void)configure:(id<BSBinder, BSInjector>)binder {
    [super configure:binder];
}

-(NSString *)environmentConfigFile {
    return @"environment_test";
}

@end
