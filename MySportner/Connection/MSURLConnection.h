//
//  AFIURLConnection.h
//  sFetch
//
//  Created by Tanguy Hélesbeux on 13/11/2013.
//  Copyright (c) 2013 AnyFetch - INSA. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AFIURLConnectionDelegate;

@interface MSURLConnection : NSURLConnection <NSURLConnectionDataDelegate>

@property (weak, nonatomic) id <AFIURLConnectionDelegate> afiDelegate;

@property (strong, nonatomic) NSString *login;
@property (strong, nonatomic) NSString *password;

- (id)initWithRequest:(NSMutableURLRequest *)request
             delegate:(id) delegate
                login:(NSString *)login
          andPassword:(NSString *)password;

+ (MSURLConnection *)connectionWithRequest:(NSMutableURLRequest *)request
                                   delegate:(id)delegate login:(NSString *)login
                                andPassword:(NSString *)password;

- (id)initWithRequest:(NSURLRequest *)request
             delegate:(id)delegate;

+ (MSURLConnection *)connectionWithRequest:(NSMutableURLRequest *)request
                                   delegate:(id)delegate;

- (void)setHTTPAuthorizationHeaderToRequest:(NSMutableURLRequest *)request;

- (void)startConnection;

@end

@protocol AFIURLConnectionDelegate <NSObject>

- (void)connectionDidStart:(MSURLConnection *)connection;
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error;
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data;

@end

