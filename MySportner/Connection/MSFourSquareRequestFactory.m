//
//  MSFourSquareRequestFactory.m
//  MySportner
//
//  Created by Tanguy Hélesbeux on 23/11/2013.
//  Copyright (c) 2013 MySportner. All rights reserved.
//

#import "MSFourSquareRequestFactory.h"

#define FOURSQUARE_CLIENT_ID @"YSN1H3ZAQIR31ZPSMI3FHSENBBZKIAFCZD5P3Y45NQMQ2ZIL"
#define FOURSQUARE_CLIENT_SECRET @"O4RJM2NTR1U1U50BBC2H2GWJX4Z1HVZTFZ5QUY0JF3ZCPKIP"
#define FOURSQUARE_VERSION_DATE @"20131123"

@implementation MSFourSquareRequestFactory

+ (NSString *)stringWithClientAuthorizationToStringURL:(NSString *)url
{
    return [url stringByAppendingFormat:@"?client_id=%@&client_secret=%@&v=%@", FOURSQUARE_CLIENT_ID, FOURSQUARE_CLIENT_SECRET, FOURSQUARE_VERSION_DATE];
}

+ (MSURLConnection *)requestVenuesNear:(CGPoint)location
                          withCategory:(MSFourSquareCategory)category
                           andDelegate:(id)delegate
{
    NSString *URL = @"https://api.foursquare.com/v2/venues/search";
    
    URL = [MSFourSquareRequestFactory stringWithClientAuthorizationToStringURL:URL];
    
    URL = [URL stringByAppendingFormat:@"&ll=%f,%f", location.x, location.y];
    
    URL = [URL stringByAppendingFormat:@"&categoryId=%@",[MSFourSquareKeyFactory keyForCategory:category]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URL]];
    
    return [MSURLConnection connectionWithRequest:request delegate:delegate];
}

@end
