#import "Injectable.h"
#import <UIKit/UIKit.h>

@interface IdentificationController : UIViewController <Injectable, UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, weak) id<BSInjector>injector;
@end
