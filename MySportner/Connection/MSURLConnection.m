//
//  AFIURLConnection.m
//  sFetch
//
//  Created by Tanguy Hélesbeux on 13/11/2013.
//  Copyright (c) 2013 AnyFetch - INSA. All rights reserved.
//

#import "MSURLConnection.h"

@interface MSURLConnection()

@property (strong, nonatomic) NSMutableData *data;

@end;

@implementation MSURLConnection

- (id)initWithRequest:(NSMutableURLRequest *)request
             delegate:(id)delegate
                login:(NSString *)login
          andPassword:(NSString *)password
{
    _login = login;
    _password = password;
    _afiDelegate = delegate;
    [self setHTTPAuthorizationHeaderToRequest:request];
    self = [super initWithRequest:request delegate:self];
    if (self) {
        
    }
    return self;
}

+ (MSURLConnection *)connectionWithRequest:(NSMutableURLRequest *)request
                                   delegate:(id)delegate
                                      login:(NSString *)login
                                andPassword:(NSString *)password
{
    MSURLConnection *connection = [[MSURLConnection alloc] initWithRequest:request
                                                                    delegate:delegate
                                                                       login:login
                                                                 andPassword:password];
    return connection;
}

- (id)initWithRequest:(NSMutableURLRequest *)request delegate:(id)delegate
{
    AFIUser *user = [AFIUser sharedUser];
    
    self = [self initWithRequest:request delegate:delegate login:user.login andPassword:user.password];
    if (self) {
        
    }
    return self;
}

+ (MSURLConnection *)connectionWithRequest:(NSMutableURLRequest *)request delegate:(id)delegate
{
    return [[MSURLConnection alloc] initWithRequest:request delegate:delegate];
}

- (void)startConnection
{
    NSLog(@"%@:%@\n%@", self.login, self.password, self);
    self.data = [[NSMutableData alloc] init];
    [super start];
    if ([self.afiDelegate respondsToSelector:@selector(connectionDidStart:)])
    {
        [self.afiDelegate connectionDidStart:self];
    }
}

- (void)setHTTPAuthorizationHeaderToRequest:(NSMutableURLRequest *)request
{
    NSString *loginPassword = [NSString stringWithFormat:@"%@:%@",self.login,self.password];
    
    NSData *plainData = [loginPassword dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64String = [plainData base64EncodedStringWithOptions:0];
    
    NSString *value = [NSString stringWithFormat:@"Basic %@",base64String];
    
    NSLog(@"Authorization = %@", value);
    [request setValue:value forHTTPHeaderField:@"Authorization"];
}

#pragma mark NSURLConnectionDataDelegate

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if ([self.afiDelegate respondsToSelector:@selector(connection:didFailWithError:)]) {
        [self.afiDelegate connection:self didFailWithError:error];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.data appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    //NSLog([NSString stringWithUTF8String:[data bytes]]);
    if ([self.afiDelegate respondsToSelector:@selector(connection:didReceiveData:)]) {
        [self.afiDelegate connection:self didReceiveData:self.data];
    }
}

@end
