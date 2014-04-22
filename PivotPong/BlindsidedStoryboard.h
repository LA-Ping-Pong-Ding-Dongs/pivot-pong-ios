@interface BlindsidedStoryboard : UIStoryboard
@property (nonatomic, weak) id<BSInjector> injector;

+ (instancetype)storyboardWithName:(NSString *)name bundle:(NSBundle *)storyboardBundleOrNil injector:(id<BSInjector>)injector;

@end
