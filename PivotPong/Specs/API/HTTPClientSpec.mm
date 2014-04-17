#import "HTTPClient.h"
#import "KSDeferred.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

@interface HTTPClient (Specs)
@property (strong) NSURLSession *session;
@end

SPEC_BEGIN(HTTPClientSpec)

describe(@"HTTPClient", ^{
    __block HTTPClient *client;
    __block id<BSBinder, BSInjector> injector;
    __block id<CedarDouble> session;

    beforeEach(^{
        injector = [Factory injector];
        session = nice_fake_for([NSURLSession class]);
        [injector bind:[NSURLSession class] toInstance:session];
        client = [injector getInstance:[HTTPClient class]];
    });

    describe(@"initWithNSURLSession:", ^{
        it(@"sets the session", ^{
            expect(client.session).to(be_instance_of([NSURLSession class]));
            expect(client.injector).to(be_same_instance_as(injector));
        });
    });

    describe(@"-fetchUrl:", ^{
        __block KSDeferred *deferred;

        it(@"delegates to NSURLSession", ^{
            id<CedarDouble> dataTask = nice_fake_for([NSURLSessionDataTask class]);

            session stub_method("dataTaskWithURL:completionHandler:").and_return(dataTask);

            [client fetchUrl:@"http://example.com/url.json"];
            expect(session).to(have_received("dataTaskWithURL:completionHandler:"));
            expect(dataTask).to(have_received("resume"));
            __autoreleasing NSURL *url;
            NSInvocation *invocation = [[session sent_messages] lastObject];
            [invocation getArgument:&url atIndex:2];
            expect(url.path).to(equal(@"/url.json"));
        });

        describe(@"when it is successful", ^{
            __block NSData *data;
            __block NSHTTPURLResponse *response;
            __block NSError *error;


            beforeEach(^{
                data = [@"datadatadata" dataUsingEncoding:NSUTF8StringEncoding];
                response = [[NSHTTPURLResponse alloc] initWithURL:nil statusCode:200 HTTPVersion:nil headerFields:nil];
                error = nil;
                deferred = [injector getInstance:[KSDeferred class]];
                spy_on(deferred);
                [injector bind:[KSDeferred class] toInstance:deferred];
            });

            it(@"resolves with value on the KSDeferred object", ^{
                __autoreleasing void(^completionHandler)(NSData *data, NSURLResponse *response, NSError *error);
                [client fetchUrl:@"http://example.com/url.json"];
                NSInvocation *invocation = [[session sent_messages] lastObject];
                [invocation getArgument:&completionHandler atIndex:3];
                completionHandler(data, response, error);
                expect(deferred).to(have_received("resolveWithValue:"));
                expect(deferred.promise.value).to(equal(data));
                expect(deferred.promise.error).to(be_nil);
            });
        });

        describe(@"when it is not successful", ^{
            __block NSData *data;
            __block NSHTTPURLResponse *response;
            __block NSError *error;


            beforeEach(^{
                data = [@"datadatadata" dataUsingEncoding:NSUTF8StringEncoding];
                response = [[NSHTTPURLResponse alloc] initWithURL:nil statusCode:500 HTTPVersion:nil headerFields:nil];
                error = nil;
                deferred = [injector getInstance:[KSDeferred class]];
                spy_on(deferred);
                [injector bind:[KSDeferred class] toInstance:deferred];
            });

            it(@"resolves with value on the KSDeferred object", ^{
                __autoreleasing void(^completionHandler)(NSData *data, NSURLResponse *response, NSError *error);
                [client fetchUrl:@"http://example.com/url.json"];
                NSInvocation *invocation = [[session sent_messages] lastObject];
                [invocation getArgument:&completionHandler atIndex:3];
                completionHandler(data, response, error);
                expect(deferred).to(have_received("rejectWithError:"));
                expect(deferred.promise.error).to_not(be_nil);
            });
        });

    });
});

SPEC_END
