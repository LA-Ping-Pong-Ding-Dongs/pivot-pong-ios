#import "SpecConfigurator.h"

@implementation SpecConfigurator

-(void)configure:(id<BSBinder, BSInjector>)binder {
    [binder bind:PivotPongApiURLs toInstance:@{PivotPongGetPlayers: @"http://www.example.com/players.json"}];
}

@end
