#import "Configurator.h"

@implementation Configurator

-(void)configure:(id<BSBinder, BSInjector>)binder {

    [binder bind:[UIStoryboard class] toBlock:^id(NSArray *args, id<BSInjector> injector) {
        return [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    }];

    [binder bind:PivotPongApiURLs toInstance:@{PivotPongGetPlayers: @"http://pivot-pong-staging.cfapps.io/api/players.json"}];

    [binder bind:[NSURLSession class] toInstance:[NSURLSession sharedSession]];
    [binder bind:[NSOperationQueue class] toInstance:[NSOperationQueue mainQueue]];
}
@end
