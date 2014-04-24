#import "Configurator.h"

@interface Configurator ()
@property (nonatomic, strong) NSDictionary *environment;
@end

@implementation Configurator

-(void)configure:(id<BSBinder, BSInjector>)binder {

    [binder bind:[UIStoryboard class] toBlock:^id(NSArray *args, id<BSInjector> injector) {
        return [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    }];

    [binder bind:PivotPongApiURLs toInstance:@{PivotPongApiGetPlayersKey: [self urlWithPath:@"/api/players.json"]}];

    [binder bind:[NSURLSession class] toInstance:[NSURLSession sharedSession]];
    [binder bind:[NSOperationQueue class] toInstance:[NSOperationQueue mainQueue]];
}

-(NSString *)urlWithPath:(NSString *)path {
    return [[self.environment objectForKey:@"endpoint"] stringByAppendingString:path];
}

-(NSDictionary *)environment {
    if (!_environment) {
        NSError *error = nil;
        NSString *dataPath = [[NSBundle mainBundle] pathForResource:[self environmentConfigFile] ofType:@"json"];
        _environment = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:dataPath] options:kNilOptions error:&error];
    }
    return _environment;
}

-(NSString *)environmentConfigFile {
    return @"environment";
}

@end
