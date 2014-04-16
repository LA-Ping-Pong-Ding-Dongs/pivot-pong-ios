#import "Configurator.h"

@implementation Configurator

-(void)configure:(id<BSBinder, BSInjector>)binder {
    
    [binder bind:[UIStoryboard class] toBlock:^id(NSArray *args, id<BSInjector> injector) {
        return [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    }];

}
@end
