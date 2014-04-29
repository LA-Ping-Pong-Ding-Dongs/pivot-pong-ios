#import "MatchesController.h"
#import "PivotPongClient.h"
#import "MatchesTableViewCell.h"

@interface MatchesController ()
@property (nonatomic, strong) PivotPongClient *client;
@property (nonatomic, strong) NSArray *matches;
@end

@implementation MatchesController
@synthesize injector = _injector;

-(void)viewDidLoad {
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self loadMatches];
}

-(void)loadMatches {
    __weak typeof(self) weakSelf = self;
    [[self.client getMatches] then:^NSArray *(NSArray *matches) {
        weakSelf.matches = matches;
        [weakSelf.tableView reloadData];
        return matches;
    } error:nil];
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
    return [self.matches count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MatchesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PivotPongMatchesTableViewCellKey];
    NSDictionary *match = self.matches[indexPath.row];
    cell.winner.text = [match objectForKey:PivotPongApiMatchesWinnerKey];
    cell.loser.text  = [match objectForKey:PivotPongApiMatchesLoserKey];
    return cell;
}

@end
