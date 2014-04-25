#import "Injectable.h"

@class PivotPongClient;

@interface PlayerTableViewController : UITableViewController<Injectable>
@property (nonatomic, strong, readonly) PivotPongClient *client;
@property (nonatomic, strong, readonly) NSArray *players;
-(NSDictionary *)selectedPlayer;
@end
