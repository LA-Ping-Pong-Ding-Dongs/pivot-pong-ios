#import "AttestationController.h"
#import "PivotPongClient.h"
#import "KSPromise.h"
#import "MatchPresenter.h"

@interface AttestationController ()
@property (nonatomic, strong) NSDictionary *winner;
@property (nonatomic, strong) NSDictionary *loser;
@end

@implementation AttestationController

-(void)viewDidLoad {
    [super viewDidLoad];
    NSString *localizationTitleKey = self.won ? @"AttestationControllerWonTitle" : @"AttestationControllerLostTitle";
    self.title = NSLocalizedString(localizationTitleKey, nil);
}

-(NSPredicate *)playerFilterPredicate {
    NSDictionary *currentUser = [[NSUserDefaults standardUserDefaults] objectForKey:PivotPongCurrentUserKey];
    NSString *name = [currentUser objectForKey:PivotPongPlayerNameKey];
    return [NSPredicate predicateWithFormat:[PivotPongPlayerNameKey stringByAppendingString:@"!= %@"], name];
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.navigationItem.rightBarButtonItem.enabled = YES;
}

#pragma mark - Actions

-(IBAction)doneTapped:(id)sender {
    self.navigationItem.rightBarButtonItem.enabled = NO;
    [self determinePlacementOfOtherPlayer];
    MatchPresenter *matchPresenter = [self.injector getInstance:[MatchPresenter class] withArgs:self.winner, self.loser, nil];
    __weak typeof (self) weakSelf = self;
    (void)[[self.client postMatch:[matchPresenter present]] then:^id(NSDictionary *data) {
        [weakSelf performSegueWithIdentifier:@"pushMatches" sender:nil];
        return nil;
    } error:^id(NSError *error) {
        weakSelf.navigationItem.rightBarButtonItem.enabled = YES;
        return nil;
    }];
}

-(void)setWon:(BOOL)won {
    _won = won;
    NSDictionary *currentUser = [[NSUserDefaults standardUserDefaults] objectForKey:PivotPongCurrentUserKey];
    if (won) {
        self.winner = currentUser;
    } else {
        self.loser  = currentUser;
    }
}

-(void)determinePlacementOfOtherPlayer {
    NSDictionary *player = [self selectedPlayer];
    if (self.won) {
        self.loser  = player;
    } else {
        self.winner = player;
    }
}

@end
