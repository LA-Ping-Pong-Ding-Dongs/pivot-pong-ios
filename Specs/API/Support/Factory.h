#import "Injectable.h"

@interface Factory : NSObject

+(id<BSBinder, BSInjector>)injector;
+(UIViewController *)viewControllerFromStoryBoard:(Class)viewControllerClass
                                         injector:(id<BSInjector, BSBinder>)injector;

@end
