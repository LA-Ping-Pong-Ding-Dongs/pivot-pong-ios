#import "AttestationController.h"
#import "PivotPongClient.h"
#import "KSPromise.h"

@interface AttestationController ()
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

@end
