#import "Injectable.h"
#import <UIKit/UIKit.h>

@interface HomeController : UIViewController <Injectable>
@property (weak, nonatomic) IBOutlet UIButton *wonButton;
@property (weak, nonatomic) IBOutlet UIButton *lostButton;
@end
