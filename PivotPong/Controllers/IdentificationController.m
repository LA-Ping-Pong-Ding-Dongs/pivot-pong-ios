#import "IdentificationController.h"

@interface IdentificationController ()
@property (nonatomic, strong) UINavigationController *nav;
@end

@implementation IdentificationController

@synthesize injector = _injector;

- (void)viewDidLoad
{

    [super viewDidLoad];
    NSLog(@"================> yo my injector is what: %@", _injector);
    // Do any additional setup after loading the view.
}


@end
