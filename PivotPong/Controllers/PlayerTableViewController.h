#import "Injectable.h"
#import <UIKit/UIKit.h>

@interface PlayerTableViewController : UITableViewController<Injectable>
@property (nonatomic, strong) NSArray *players;
-(NSDictionary *)selectedPlayer;
@end
