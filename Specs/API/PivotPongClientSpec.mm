#import "PivotPongClient.h"
#import "Blindside.h"
#import "KSDeferred.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(PivotPongClientSpec)

describe(@"PivotPongClient", ^{
    __block PivotPongClient *client;
    __block DataClient<CedarDouble> *dataClient;
    __block id<BSBinder, BSInjector> injector;

    beforeEach(^{
        injector = [Factory injector];
        dataClient = nice_fake_for([DataClient class]);
        [injector bind:[DataClient class] toInstance:dataClient];
        client = [injector getInstance:[PivotPongClient class]];
    });

    describe(@"initWithApiURLs:dataClient:", ^{
        it(@"sets the session and the apiURLs", ^{
            expect(client.dataClient).to(be_same_instance_as(dataClient));
            expect([client.apiURLs objectForKey:PivotPongApiGetPlayersKey]).to_not(be_nil);
            expect([client.apiURLs objectForKey:PivotPongApiPostMatchKey]).to_not(be_nil);
            expect(client.injector).to(be_same_instance_as(injector));
        });
    });

    describe(@"-getUsers", ^{
        __block KSDeferred *dataClientDeferred;
        beforeEach(^{
            dataClientDeferred = [injector getInstance:[KSDeferred class]];
            NSDictionary *result = @{PivotPongApiGetPlayersJSONResponseKey: @[@"foo", @"bar"]};
            [dataClientDeferred resolveWithValue:result];
            dataClient stub_method("fetchUrl:").and_return(dataClientDeferred.promise);
        });

        it(@"makes a request to the get players endpoint", ^{
            [client getPlayers];
            NSString *getPlayersURLString = [[injector getInstance:PivotPongApiURLs] objectForKey:PivotPongApiGetPlayersKey];
            expect(dataClient).to(have_received("fetchUrl:").with(getPlayersURLString));
        });

        it(@"returns a promise", ^{
            expect([client getPlayers]).to(be_instance_of([KSPromise class]));
        });

        it(@"returns data from the players key of the response", ^{
            KSPromise *resultPromise = [client getPlayers];
            expect(resultPromise.value).to(equal(@[@"foo", @"bar"]));
        });
    });

    describe(@"-postMatch:", ^{
        __block KSDeferred *dataClientDeferred;
        __block NSDictionary *postData;

        beforeEach(^{
            dataClientDeferred = [injector getInstance:[KSDeferred class]];
            NSDictionary *result = @{PivotPongApiPostMatchJSONResponseKey: @[@"foo", @"bar"]};
            postData = @{@"winner": @"Bob Tuna", @"loser": @"Zargon"};

            [dataClientDeferred resolveWithValue:result];
            dataClient stub_method("postData:url:").and_return(dataClientDeferred.promise);
        });

        it(@"makes a request to the create matches endpoint", ^{
            NSString *postMatchURLString = [[injector getInstance:PivotPongApiURLs] objectForKey:PivotPongApiPostMatchKey];
            [client postMatch:postData];
            expect(dataClient).to(have_received("postData:url:").with(postData).and_with(postMatchURLString));
        });

        it(@"returns a promise with the response as a dictionary", ^{
            KSPromise *resultPromise = [client postMatch:postData];

            expect(resultPromise.value).to(equal(@[@"foo", @"bar"]));
        });
    });
});

SPEC_END
