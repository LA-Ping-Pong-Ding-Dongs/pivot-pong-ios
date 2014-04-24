#import "IdentificationController.h"

@interface IdentificationController ()
@end

@implementation IdentificationController

-(void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.navigationItem.rightBarButtonItem.enabled = YES;
}

#pragma mark - Actions

- (IBAction)doneTapped:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[self selectedPlayer] forKey:PivotPongCurrentUserKey];
    [defaults synchronize];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIViewController

-(BOOL)prefersStatusBarHidden { return YES; }

@end
