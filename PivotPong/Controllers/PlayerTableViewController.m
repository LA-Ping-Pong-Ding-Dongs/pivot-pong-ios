#import "PlayerTableViewController.h"
#import "PivotPongClient.h"
#import "KSPromise.h"

@interface PlayerTableViewController ()
@end

@implementation PlayerTableViewController
@synthesize injector = _injector,
            players  = _players;

-(void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:PivotPongPlayerTableViewCellKey bundle:nil] forCellReuseIdentifier:PivotPongPlayerTableViewCellKey];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
}

-(NSArray *)players {
    if (!_players) {
        __weak typeof(self) weakSelf = self;
        PivotPongClient *client = [self.injector getInstance:[PivotPongClient class]];
        KSPromise *promise = [client getPlayers];
        [promise then:^NSArray *(NSArray *players) {
            NSPredicate *filter = [self playerFilterPredicate];
            weakSelf.players = filter ? [players filteredArrayUsingPredicate:[self playerFilterPredicate]] : players;
            [weakSelf.tableView reloadData];
            return players;
        } error:nil];
    }
    return _players;
}

-(NSPredicate *)playerFilterPredicate {
    return nil;
}

# pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView
numberOfRowsInSection:(NSInteger)section {
    return [self.players count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PivotPongPlayerTableViewCellKey];
    NSDictionary *player = self.players[indexPath.row];
    cell.textLabel.text = [player objectForKey:PivotPongPlayerNameKey];
    return cell;
 }

#pragma mark Private methods
-(NSDictionary *)selectedPlayer {
    return [self.players objectAtIndex:[self.tableView indexPathForSelectedRow].row];
}

@end
