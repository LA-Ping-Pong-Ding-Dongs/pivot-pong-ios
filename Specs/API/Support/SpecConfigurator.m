#import <objc/runtime.h>
#import "SpecConfigurator.h"
#import "Configurator.h"

@interface Configurator ()
-(NSString *)environmentConfigFile;
@end

@implementation Configurator (SpecOverrides)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        
        Method original = class_getInstanceMethod(class, @selector(environmentConfigFile));
        Method swizzled = class_getInstanceMethod(class, @selector(swizzledEnvironmentConfigFile));
        
        method_exchangeImplementations(original, swizzled);
    });
}
                  
-(NSString *)swizzledEnvironmentConfigFile {
    return @"environment_test";
}

@end

@implementation SpecConfigurator

-(void)configure:(id<BSBinder, BSInjector>)binder {
}

@end

