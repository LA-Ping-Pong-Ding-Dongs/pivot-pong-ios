#import "HomeController.h"
#import "IdentificationController.h"
#import "AttestationController.h"
#import "Configurator.h"

@interface HomeController ()
@end

@implementation HomeController
@synthesize injector = _injector;


-(void)viewDidLoad {
    [self labelButtons];
    if (![[NSUserDefaults standardUserDefaults] objectForKey:PivotPongCurrentUserKey]) {
        [self performSegueWithIdentifier:@"presentIdentification" sender:nil];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isKindOfClass:[AttestationController class]]) {
        ((AttestationController *)segue.destinationViewController).won = [segue.identifier isEqualToString:@"pushAttestationsWon"];
    }
}

-(void)labelButtons {
    NSArray *wonValues = @[
                           @"I WON!",
                           @"Winning!",
                           @"I sucked less"
                           ];
    NSArray *lostValues = @[
                            @"I need to play harder",
                            @"I sucked",
                            @"I have some room for improvement",
                            @"I lost… :-("
                            ];

    NSString *wonString = [wonValues objectAtIndex:arc4random_uniform(wonValues.count)];
    [self.wonButton setTitle:wonString forState:UIControlStateNormal];

    NSString *lostString = [lostValues objectAtIndex:arc4random_uniform(lostValues.count)];
    [self.lostButton setTitle:lostString forState:UIControlStateNormal];
}

@end
