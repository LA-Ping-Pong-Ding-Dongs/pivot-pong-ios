#import "IdentificationController.h"
#import "PivotPongClient.h"
#import "KSDeferred.h"

@interface IdentificationController ()
@property (nonatomic, strong) UINavigationController *nav;
@property (nonatomic, strong) NSArray *players;
@end

@implementation IdentificationController

@synthesize injector = _injector;

-(void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
}

-(NSArray *)players {
    if (!_players) {
        __weak IdentificationController *weakSelf = self;
        PivotPongClient *client = [self.injector getInstance:[PivotPongClient class]];
        KSPromise *promise = [client getPlayers];
        [promise then:^id(NSDictionary *dictionary) {
            weakSelf.players = [dictionary objectForKey:PivotPongJSONResponsePlayersKey];
            [weakSelf.tableView reloadData];
            return nil;
        } error:nil];
    }
    return _players;
}

#pragma mark Actions
- (IBAction)doneTapped:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[self selectedPlayer] forKey:@"currentUser"];
    [defaults synchronize];
    [self dismissViewControllerAnimated:YES completion:nil];
}


# pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return [self.players count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PlayerCellPrototype"];
    NSDictionary *player = self.players[indexPath.row];
    cell.textLabel.text = [player objectForKey:@"name"];
    return cell;
}

# pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

#pragma mark - UIViewController

-(BOOL)prefersStatusBarHidden { return YES; }


#pragma mark Private methods
-(NSDictionary *)selectedPlayer {
    return [self.players objectAtIndex:[self.tableView indexPathForSelectedRow].row];
}

@end
