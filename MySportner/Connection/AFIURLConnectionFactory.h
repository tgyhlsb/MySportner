//
//  AFIURLConnectionFactory.h
//  sFetch
//
//  Created by Tanguy Hélesbeux on 13/11/2013.
//  Copyright (c) 2013 AnyFetch - INSA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MSURLConnection.h"

#define GET_CONTACTS_URL @"http://api.anyfetch.com/documents?semantic_document_type=5252ce4ce4cfcd16f55cfa3a"

@interface AFIURLConnectionFactory : NSObject

+ (MSURLConnection *)connectionGetContactWithDelegate:(id<AFIURLConnectionDelegate>)delegate;

+ (MSURLConnection *)connectionGetTimeLineForUserName:(NSString *)name andDelegate:(id<AFIURLConnectionDelegate>)delegate;

@end
