#import "PivotPongClient.h"
#import "Blindside.h"
#import "KSDeferred.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(PivotPongClientSpec)

describe(@"PivotPongClient", ^{
    __block PivotPongClient *client;
    __block JSONClient<CedarDouble> *jsonClient;
    __block id<BSBinder, BSInjector> injector;

    beforeEach(^{
        injector = [Factory injector];
        jsonClient = nice_fake_for([JSONClient class]);
        [injector bind:[JSONClient class] toInstance:jsonClient];
        client = [injector getInstance:[PivotPongClient class]];
    });

    describe(@"initWithApiURLs:jsonClient:", ^{
        it(@"sets the session and the apiURLs", ^{
            expect(client.jsonClient).to(be_same_instance_as(jsonClient));
            expect([client.apiURLs objectForKey:PivotPongGetPlayers]).to_not(be_nil);
            expect(client.injector).to(be_same_instance_as(injector));
        });
    });

    describe(@"-getUsers", ^{
        __block KSDeferred *jsonClientDeferred;
        beforeEach(^{
            jsonClientDeferred = [injector getInstance:[KSDeferred class]];
            NSDictionary *result = @{@"foo": @"bar"};
            [jsonClientDeferred resolveWithValue:result];
            jsonClient stub_method("fetchUrl:").and_return(jsonClientDeferred.promise);
        });

        it(@"makes a request to the get players endpoint", ^{
            [client getPlayers];
            NSString *getPlayersURLString = [[injector getInstance:PivotPongApiURLs] objectForKey:PivotPongGetPlayers];
            expect(jsonClient).to(have_received("fetchUrl:").with(getPlayersURLString));
        });

        it(@"returns a promise", ^{
            expect([client getPlayers]).to(be_instance_of([KSPromise class]));
        });
    });
});

SPEC_END
