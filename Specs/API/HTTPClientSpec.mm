#import "HTTPClient.h"
#import "KSDeferred.h"
#import "FakeOperationQueue.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(HTTPClientSpec)

describe(@"HTTPClient", ^{
    __block HTTPClient *client;
    __block id<BSBinder, BSInjector> injector;
    __block id<CedarDouble> session;
    __block id<CedarDouble> dataTask = nice_fake_for([NSURLSessionDataTask class]);
    __block NSData *data;
    __block NSHTTPURLResponse *response;
    __block NSError *error;
    __block KSDeferred *deferred;
    __block void(^completionHandler)(NSData *data, NSURLResponse *response, NSError *error);

    beforeEach(^{
        injector = [Factory injector];
        FakeOperationQueue *fakeQueue = [FakeOperationQueue new];
        fakeQueue.runSynchronously = YES;
        [injector bind:[NSOperationQueue class] toInstance:fakeQueue];
        session = nice_fake_for([NSURLSession class]);
        [injector bind:[NSURLSession class] toInstance:session];
        client = [injector getInstance:[HTTPClient class]];
        deferred = [injector getInstance:[KSDeferred class]];
        spy_on(deferred);
        [injector bind:[KSDeferred class] toInstance:deferred];
    });

    describe(@"initWithNSURLSession:", ^{
        it(@"sets the session", ^{
            expect(client.session).to(be_instance_of([NSURLSession class]));
            expect(client.injector).to(be_same_instance_as(injector));
        });
    });

    describe(@"-fetchUrl:", ^{
        it(@"makes a GET request to the url session", ^{
            session stub_method("dataTaskWithURL:completionHandler:").and_return(dataTask);
            [client fetchUrl:@"http://example.com/url.json"];
            expect(session).to(have_received("dataTaskWithURL:completionHandler:"));
            expect(dataTask).to(have_received("resume"));
            __autoreleasing NSURL *url;
            NSInvocation *invocation = [[session sent_messages] lastObject];
            [invocation getArgument:&url atIndex:2];
            expect(url.path).to(equal(@"/url.json"));
        });

        describe(@"when a request is made", ^{
            describe(@"and the response is successful", ^{
                beforeEach(^{
                    data = [@"datadatadata" dataUsingEncoding:NSUTF8StringEncoding];
                    response = [[NSHTTPURLResponse alloc] initWithURL:nil statusCode:200 HTTPVersion:nil headerFields:nil];
                    error = nil;
                });

                it(@"resolves with value on the KSDeferred object", ^{
                    [client fetchUrl:@"http://example.com/url.json"];
                    NSInvocation *invocation = [[session sent_messages] lastObject];
                    [invocation getArgument:&completionHandler atIndex:3];
                    completionHandler(data, response, error);
                    expect(deferred).to(have_received("resolveWithValue:"));
                    expect(deferred.promise.value).to(equal(data));
                    expect(deferred.promise.error).to(be_nil);
                });
            });

            describe(@"and the response is unsuccessful", ^{
                beforeEach(^{
                    data = [@"datadatadata" dataUsingEncoding:NSUTF8StringEncoding];
                    response = [[NSHTTPURLResponse alloc] initWithURL:nil statusCode:500 HTTPVersion:nil headerFields:nil];
                    error = nil;
                });

                it(@"rejects with error on the KSDeferred object", ^{
                    [client fetchUrl:@"http://example.com/url.json"];
                    NSInvocation *invocation = [[session sent_messages] lastObject];
                    [invocation getArgument:&completionHandler atIndex:3];
                    completionHandler(data, response, error);
                    expect(deferred).to_not(have_received("resolveWithValue:"));
                    expect(deferred).to(have_received("rejectWithError:"));
                    expect(deferred.promise.error.localizedDescription)
                        .to(contain([NSString stringWithFormat:NSLocalizedString(@"ServerResponseError", nil), 500]));
                });
            });
        });

        describe(@"when a request cannot be made", ^{
            beforeEach(^{
                data = [@"datadatadata" dataUsingEncoding:NSUTF8StringEncoding];
                response = [[NSHTTPURLResponse alloc] initWithURL:nil statusCode:200 HTTPVersion:nil headerFields:nil];
                error = [[NSError alloc] initWithDomain:@"failure!" code:PivotPongErrorCodeServerError userInfo:nil];
            });

            it(@"rejects with error on the KSDeferred object", ^{
                [client fetchUrl:@"http://example.com/url.json"];
                NSInvocation *invocation = [[session sent_messages] lastObject];
                [invocation getArgument:&completionHandler atIndex:3];
                completionHandler(data, response, error);
                expect(deferred).to_not(have_received("resolveWithValue:"));
                expect(deferred).to(have_received("rejectWithError:"));
                expect(deferred.promise.error).to_not(be_nil);
                expect(deferred.promise.error.localizedDescription).
                    to(contain(NSLocalizedString(@"NetworkConnectivityError", nil)));
            });
        });
    });
    
    describe(@"postData:url", ^{
        __block NSURLRequest<CedarDouble> *request;

        beforeEach(^{
            data = [@"lol" dataUsingEncoding:NSUTF8StringEncoding];
            request = [injector getInstance:[NSMutableURLRequest class]];
            [injector bind:[NSMutableURLRequest class] toInstance:request];
            session stub_method("dataTaskWithRequest:completionHandler:").and_return(dataTask);
        });
        
        it(@"makes a POST request object", ^{
            (void)[client postData:data url:@"http://example.com/lol"];
            expect(request.HTTPMethod).to(equal(@"POST"));
            expect(request.HTTPBody).to(equal(data));
            expect([request.URL absoluteString]).to(equal(@"http://example.com/lol"));
            expect(dataTask).to(have_received("resume"));
        });
        
        it(@"returns a promise", ^{
            expect([client postData:nil url:nil]).to(be_instance_of([KSPromise class]));
        });
        
        describe(@"when a request is made", ^{
            describe(@"and the response is successful", ^{
                beforeEach(^{
                    response = [[NSHTTPURLResponse alloc] initWithURL:nil statusCode:201 HTTPVersion:nil headerFields:nil];
                    error = nil;
                });
                
                it(@"resolves with value on the KSDeferred object", ^{
                    [client postData:data url:@"http://example.com/lol"];
                    NSInvocation *invocation = [[session sent_messages] lastObject];
                    [invocation getArgument:&completionHandler atIndex:3];
                    NSData *responseBody = [@"lol" dataUsingEncoding:NSUTF8StringEncoding];
                    completionHandler(responseBody, response, error);
                    expect(deferred).to(have_received("resolveWithValue:"));
                    expect(deferred.promise.value).to(equal(data));
                    expect(deferred.promise.error).to(be_nil);
                });
            });
            
            describe(@"and the response not successful", ^{
                beforeEach(^{
                    response = [[NSHTTPURLResponse alloc] initWithURL:nil statusCode:500 HTTPVersion:nil headerFields:nil];
                    error = nil;
                });
                
                it(@"rejects with error on the KSDeferred object", ^{
                    [client postData:data url:@"http://example.com/lol"];
                    NSInvocation *invocation = [[session sent_messages] lastObject];
                    [invocation getArgument:&completionHandler atIndex:3];
                    NSData *receivedData = [@"lol" dataUsingEncoding:NSUTF8StringEncoding];
                    completionHandler(receivedData, response, error);
                    expect(deferred).to_not(have_received("resolveWithValue:"));
                    expect(deferred).to(have_received("rejectWithError:"));
                    expect(deferred.promise.error.localizedDescription).to(contain([NSString stringWithFormat:NSLocalizedString(@"ServerResponseError", nil), 500]));
                });
            });
        });
        
        describe(@"when a request cannot be made", ^{
            beforeEach(^{
                response = [[NSHTTPURLResponse alloc] initWithURL:nil statusCode:200 HTTPVersion:nil headerFields:nil];
                error = [[NSError alloc] initWithDomain:@"failure!" code:PivotPongErrorCodeServerError userInfo:nil];
            });
            
            it(@"rejects with error on the KSDeferred object", ^{
                [client postData:data url:@"http://example.com/lol"];
                NSInvocation *invocation = [[session sent_messages] lastObject];
                [invocation getArgument:&completionHandler atIndex:3];
                completionHandler(data, response, error);
                expect(deferred).to_not(have_received("resolveWithValue:"));
                expect(deferred).to(have_received("rejectWithError:"));
                expect(deferred.promise.error).to_not(be_nil);
                expect(deferred.promise.error.localizedDescription).to(contain(NSLocalizedString(@"NetworkConnectivityError", nil)));
            });
        });
    });
});

SPEC_END
