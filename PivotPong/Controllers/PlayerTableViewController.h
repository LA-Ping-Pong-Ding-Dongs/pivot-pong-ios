#import "Injectable.h"

@interface PlayerTableViewController : UITableViewController<Injectable>
@property (nonatomic, strong) NSArray *players;
-(NSDictionary *)selectedPlayer;
@end
