#import <Foundation/Foundation.h>

@protocol Injectable <NSObject>
@property (nonatomic, weak) id<BSInjector>injector;
@end
