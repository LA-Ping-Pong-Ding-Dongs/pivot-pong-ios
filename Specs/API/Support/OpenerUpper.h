#import "PivotPongClient.h"
#import "JSONClient.h"
#import "HTTPClient.h"
#import "IdentificationController.h"
#import "PlayerTableViewController.h"
#import "AppDelegate.h"

#ifndef PivotPong_OpenerUpper_h
#define PivotPong_OpenerUpper_h

@interface PivotPongClient (OpenerUpper)
-(JSONClient *)jsonClient;
-(NSDictionary *)apiURLs;
@end

@interface JSONClient (OpenerUpper)
-(HTTPClient *)httpClient;
@end

@interface IdentificationController (OpenerUpper)
@end

@interface PlayerTableViewController (OpenerUpper)
@end

@interface AppDelegate (OpenerUpper)
-(id<BSInjector>)injector;
@end

#endif
