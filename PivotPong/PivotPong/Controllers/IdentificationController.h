#import "Injectable.h"
#import <UIKit/UIKit.h>

@interface IdentificationController : UIViewController <Injectable>
@property (nonatomic, weak) id<BSInjector>injector;
@end
