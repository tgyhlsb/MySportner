//
//  MSReverseGeocodingRequest.m
//  MySportner
//
//  Created by Tanguy Hélesbeux on 13/02/2014.
//  Copyright (c) 2014 MySportner. All rights reserved.
//

#import "MSReverseGeocodingRequest.h"
#import "MSURLConnection.h"

#define GOOGLE_PLACE_API_KEY @"AIzaSyD0tUcYWxjL0iw56FHIK-TqY9e5NkhT63s"
#define GOOGLE_PLACE_API_RESULT_TYPE @"locality"

static MSReverseGeocodingRequest *sharedRequest;

@interface MSReverseGeocodingRequest() <MSURLConnectionDelegate>

@property (strong, nonatomic) MSURLConnection *connection;

@property (strong, nonatomic) void(^completionBlock)(NSDictionary *placeInfo, NSError *error);

@end

@implementation MSReverseGeocodingRequest

- (NSMutableURLRequest *)requestWithLocation:(CLLocationCoordinate2D)location
{
    NSString *sURL = @"https://maps.googleapis.com/maps/api/geocode/json?";
    
    sURL = [sURL stringByAppendingFormat:@"sensor=true"];
    sURL = [sURL stringByAppendingFormat:@"&key=%@",GOOGLE_PLACE_API_KEY];
    sURL = [sURL stringByAppendingFormat:@"&result_type=%@",GOOGLE_PLACE_API_RESULT_TYPE];
    sURL = [sURL stringByAppendingFormat:@"&latlng=%f,%f",location.latitude, location.longitude];
    NSLog(@"%@", sURL);
    return [NSMutableURLRequest requestWithURL:[NSURL URLWithString:sURL]];
    
    
}

+ (void)requestLocation:(CLLocationCoordinate2D)location
                                   completionBlock:(void (^)(NSDictionary *, NSError *))completionBlock
{
    sharedRequest = [[MSReverseGeocodingRequest alloc] init];
    sharedRequest.completionBlock = completionBlock;
    NSMutableURLRequest *request = [sharedRequest requestWithLocation:location];
    sharedRequest.connection = [MSURLConnection connectionWithRequest:request delegate:sharedRequest];
    [sharedRequest.connection startConnection];
}

#pragma mark - MSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didReceiveJson:(NSDictionary *)json
{
    if ([connection isEqual:sharedRequest.connection]) {
        
        NSArray *results = [json objectForKey:@"results"];
        NSArray *addresses = [[results lastObject] objectForKey:@"address_components"];
        
        NSLog(@"%@", addresses);
        NSMutableDictionary *formatedResults = [[NSMutableDictionary alloc] init];
        for (NSDictionary *address in addresses) {
            NSArray *types = [address objectForKey:@"types"];
            NSString *type = [types objectAtIndex:0];
            NSString *name = [address objectForKey:@"long_name"];
            [formatedResults setObject:name forKey:type];
        }
        self.completionBlock(formatedResults, nil);
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if ([connection isEqual:sharedRequest.connection]) {
        self.completionBlock(nil, error);
    }
}

- (void)connectionDidStart:(MSURLConnection *)connection
{
    
}

@end
