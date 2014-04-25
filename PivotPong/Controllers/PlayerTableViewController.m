#import "PlayerTableViewController.h"
#import "PivotPongClient.h"
#import "KSPromise.h"

@interface PlayerTableViewController ()
@property (nonatomic, strong, readwrite) PivotPongClient *client;
@property (nonatomic, strong, readwrite) NSArray *players;
@end

@implementation PlayerTableViewController
@synthesize injector = _injector,
            players  = _players;

-(void)viewDidLoad {
    [self.tableView registerNib:[UINib nibWithNibName:PivotPongPlayerTableViewCellKey bundle:nil] forCellReuseIdentifier:PivotPongPlayerTableViewCellKey];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self loadPlayers];
}

-(void)loadPlayers {
    __weak typeof(self) weakSelf = self;
    [[self.client getPlayers] then:^NSArray *(NSArray *players) {
        NSPredicate *filter = [weakSelf playerFilterPredicate];
        weakSelf.players = filter ? [players filteredArrayUsingPredicate:[weakSelf playerFilterPredicate]] : players;
        [weakSelf.tableView reloadData];
        return players;
    } error:nil];
}

-(NSPredicate *)playerFilterPredicate {
    return nil;
}

-(PivotPongClient *)client {
    if (!_client) {
        _client = [self.injector getInstance:[PivotPongClient class]];
    }
    return _client;
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

#pragma mark - private methods
-(NSDictionary *)selectedPlayer {
    return [self.players objectAtIndex:[self.tableView indexPathForSelectedRow].row];
}

@end
