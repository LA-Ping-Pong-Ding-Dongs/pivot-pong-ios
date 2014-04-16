#import "HomeController.h"
#import "IdentificationController.h"
#import "AttestationController.h"
#import "Configurator.h"

@interface HomeController ()
@end

@implementation HomeController
@synthesize injector = _injector;


-(void)viewDidLoad {

    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"currentUser"]) {
        [self performSegueWithIdentifier:@"pushAttestation" sender:nil];
    } else {
        [self performSegueWithIdentifier:@"presentIdentification" sender:nil];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    ((id<Injectable>)(segue.destinationViewController)).injector = self.injector;
}

@end
