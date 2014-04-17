#import "PivotPongClient.h"
#import "JSONClient.h"
#import "HTTPClient.h"

#ifndef PivotPong_OpenerUpper_h
#define PivotPong_OpenerUpper_h

@interface PivotPongClient ()
-(JSONClient *)jsonClient;
-(NSDictionary *)apiURLs;
@end

@interface JSONClient ()
-(HTTPClient *)httpClient;
@end

#endif
