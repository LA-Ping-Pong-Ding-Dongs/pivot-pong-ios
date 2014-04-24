#import "PivotPongClient.h"
#import "DataClient.h"
#import "HTTPClient.h"
#import "IdentificationController.h"
#import "PlayerTableViewController.h"
#import "AppDelegate.h"
#import "HTTPClient.h"

#ifndef PivotPong_OpenerUpper_h
#define PivotPong_OpenerUpper_h

@interface PivotPongClient (OpenerUpper)
-(DataClient *)dataClient;
-(NSDictionary *)apiURLs;
@end

@interface DataClient (OpenerUpper)
-(HTTPClient *)httpClient;
@end

@interface IdentificationController (OpenerUpper)
@end

@interface PlayerTableViewController (OpenerUpper)
@end

@interface AppDelegate (OpenerUpper)
-(id<BSInjector>)injector;
@end

@interface HTTPClient (OpenerUpper)
-(NSURLSession *)session;
@end

#endif
