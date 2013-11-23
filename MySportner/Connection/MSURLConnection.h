//
//  AFIURLConnection.h
//  sFetch
//
//  Created by Tanguy Hélesbeux on 13/11/2013.
//  Copyright (c) 2013 AnyFetch - INSA. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MSURLConnectionDelegate;

@interface MSURLConnection : NSURLConnection <NSURLConnectionDataDelegate>

@property (weak, nonatomic) id <MSURLConnectionDelegate> connectionDelegate;

- (id)initWithRequest:(NSURLRequest *)request
             delegate:(id)delegate;

+ (MSURLConnection *)connectionWithRequest:(NSURLRequest *)request
                                   delegate:(id)delegate;


- (void)startConnection;

@end

@protocol MSURLConnectionDelegate <NSObject>

- (void)connectionDidStart:(MSURLConnection *)connection;
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error;

@optional

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data;
- (void)connection:(NSURLConnection *)connection didReceiveJson:(NSDictionary *)json;

@end

