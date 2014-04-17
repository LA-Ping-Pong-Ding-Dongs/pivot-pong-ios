#import "JSONClient.h"
#import "HTTPClient.h"
#import "KSDeferred.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(JSONClientSpec)

describe(@"JSONClient", ^{
    __block JSONClient *client;
    __block id<BSInjector,BSBinder> injector;
    __block HTTPClient<CedarDouble> *httpClient;
    __block KSDeferred *requestDeferred;

    beforeEach(^{
        injector = [Factory injector];
        httpClient = nice_fake_for([HTTPClient class]);
        [injector bind:[HTTPClient class] toInstance:httpClient];
        client = [injector getInstance:[JSONClient class]];

        requestDeferred = [KSDeferred defer];
        httpClient stub_method("fetchUrl:").and_return(requestDeferred.promise);
    });

    describe(@"-initWithHTTPClient:", ^{
        it(@"sets the http client", ^{
            expect(client.httpClient).to(be_same_instance_as(httpClient));
        });
    });

    describe(@"-fetchUrl", ^{
        it(@"returns a dictionary represesntation of the json the requested url", ^{
            NSData *data = [@"{\"foo\":\"bar\"}" dataUsingEncoding:NSUTF8StringEncoding];
            [requestDeferred resolveWithValue:data];

            KSPromise *result = [client fetchUrl:@"http://example.com/index.json"];
            expect(result.value).to(equal(@{@"foo":@"bar"}));
            expect(result.error).to(be_nil);
        });

        describe(@"when the response is not parseable", ^{
            it(@"rejects with an error", ^{
                NSData *data = [@"bad data" dataUsingEncoding:NSUTF8StringEncoding];
                [requestDeferred resolveWithValue:data];

                KSPromise *result = [client fetchUrl:@"http://example.com/index.json"];
                expect(result.error).to_not(be_nil);
            });
        });
    });
});

SPEC_END
