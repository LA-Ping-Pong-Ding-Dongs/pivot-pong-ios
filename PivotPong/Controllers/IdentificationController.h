#import "Injectable.h"
#import <UIKit/UIKit.h>

@interface IdentificationController : UITableViewController <Injectable, UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, weak) id<BSInjector>injector;
@end
