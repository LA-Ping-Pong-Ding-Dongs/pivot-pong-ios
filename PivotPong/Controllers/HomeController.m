#import "HomeController.h"
#import "IdentificationController.h"
#import "AttestationController.h"
#import "Configurator.h"

@interface HomeController ()
@property (weak, nonatomic) IBOutlet UIButton *wonButton;
@property (weak, nonatomic) IBOutlet UIButton *lostButton;
@end

@implementation HomeController
@synthesize injector = _injector;


-(void)viewDidLoad {
    [self labelButtons];
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"currentUser"]) {
        [self performSegueWithIdentifier:@"presentIdentification" sender:nil];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UIViewController *destinationController = segue.destinationViewController;
    if ([destinationController isKindOfClass:[UINavigationController class]]) {
        destinationController = [((UINavigationController *)destinationController) topViewController];
    }
    ((id<Injectable>)destinationController).injector = self.injector;
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
