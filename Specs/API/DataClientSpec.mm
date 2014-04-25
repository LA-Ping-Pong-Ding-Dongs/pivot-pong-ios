#import "DataClient.h"
#import "HTTPClient.h"
#import "KSDeferred.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(DataClientSpec)

describe(@"DataClient", ^{
    __block DataClient *client;
    __block id<BSInjector,BSBinder> injector;
    __block HTTPClient<CedarDouble> *httpClient;
    __block KSDeferred *requestDeferred;

    beforeEach(^{
        injector = [Factory injector];
        httpClient = nice_fake_for([HTTPClient class]);
        [injector bind:[HTTPClient class] toInstance:httpClient];
        client = [injector getInstance:[DataClient class]];

        requestDeferred = [KSDeferred defer];
    });

    describe(@"-initWithHTTPClient:", ^{
        it(@"sets the http client", ^{
            expect(client.httpClient).to(be_same_instance_as(httpClient));
        });
    });

    describe(@"-fetchUrl:", ^{
        beforeEach(^{
            httpClient stub_method("fetchUrl:").and_return(requestDeferred.promise);
        });

        it(@"resolves with a dictionary representation of the HTTP response data", ^{
            NSData *data = [@"{\"foo\":\"bar\"}" dataUsingEncoding:NSUTF8StringEncoding];
            [requestDeferred resolveWithValue:data];
            KSPromise *result = [client fetchUrl:@"http://example.com/index.json"];
            expect(result).to(be_instance_of([KSPromise class]));
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

    describe(@"-postData:url:", ^{
        __block NSDictionary *postData;

        beforeEach(^{
            httpClient stub_method("postData:url:").and_return(requestDeferred.promise);
        });

        describe(@"when the response is parseable", ^{
            beforeEach(^{
                NSData *responseData = [@"{\"foo\":\"bar\"}" dataUsingEncoding:NSUTF8StringEncoding];
                [requestDeferred resolveWithValue:responseData];
                postData = @{@"match": @{@"winner": @"Bob Tuna", @"loser": @"Zargon"}};
            });
            it(@"resolves with a dictionary representation of the HTTP response data", ^{
                KSPromise *result = [client postData:postData url:@"http://example.com/lol"];
                expect(result).to(be_instance_of([KSPromise class]));
                expect(result.value).to(equal(@{@"foo": @"bar"}));
                expect(result.error).to(be_nil);
            });
        });

        describe(@"when the response is not parseable", ^{
            beforeEach(^{
                NSData *responseData = [@"naughty-data" dataUsingEncoding:NSUTF8StringEncoding];
                [requestDeferred resolveWithValue:responseData];
                postData = @{@"match": @{@"winner": @"Bob Tuna", @"loser": @"Zargon"}};
            });
            it(@"resolves with a dictionary representation of the HTTP response data", ^{
                KSPromise *result = [client postData:postData url:@"http://example.com/lol"];
                expect(result).to(be_instance_of([KSPromise class]));
                expect(result.value).to(be_nil);
                expect(result.error).to_not(be_nil);
            });
        });
    });
});

SPEC_END
