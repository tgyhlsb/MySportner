//
//  AFIURLConnectionFactory.m
//  sFetch
//
//  Created by Tanguy Hélesbeux on 13/11/2013.
//  Copyright (c) 2013 AnyFetch - INSA. All rights reserved.
//

#import "AFIURLConnectionFactory.h"

@implementation AFIURLConnectionFactory

+ (MSURLConnection *)connectionGetContactWithDelegate:(id<AFIURLConnectionDelegate>)delegate
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:GET_CONTACTS_URL]];
    
    return [MSURLConnection connectionWithRequest:request delegate:delegate];
}

+ (MSURLConnection *)connectionGetTimeLineForUserName:(NSString *)name andDelegate:(id<AFIURLConnectionDelegate>)delegate
{
    NSString *url = [NSString stringWithFormat:@"http://api.anyfetch.com/documents?search=%@", name];
    //    URL = @"http://bde.insa-lyon.fr/raid/wp-content/uploads/2013/11/bite1.txt";
    NSString *properlyEscapedURL = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"URL = %@", properlyEscapedURL);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:properlyEscapedURL]];
    
    return [MSURLConnection connectionWithRequest:request delegate:delegate];
}

@end
