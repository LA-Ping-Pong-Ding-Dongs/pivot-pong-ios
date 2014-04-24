#import "MatchesController.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(MatchesControllerSpec)

describe(@"MatchesController", ^{
    __block MatchesController *controller;
    __block id<BSBinder, BSInjector>injector;
    
    beforeEach(^{
        injector = [Factory injector];
        controller = (MatchesController *)[Factory viewControllerFromStoryBoard:[MatchesController class] injector:injector];
    });
    
    describe(@"when the view loads", ^{
        beforeEach(^{
            (void)controller.view;
        });
        
        it(@"shows list of matches", ^{
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            UITableViewCell *cell = [controller.tableView cellForRowAtIndexPath:indexPath];
            expect(cell.textLabel.text).to(equal(@"Bob Tuna vs. Zargon"));
        });
    });
});

SPEC_END
