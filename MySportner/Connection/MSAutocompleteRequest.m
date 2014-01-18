//
//  MSAutocompleteRequest.m
//  MySportner
//
//  Created by Tanguy Hélesbeux on 18/01/2014.
//  Copyright (c) 2014 MySportner. All rights reserved.
//

#import "MSAutocompleteRequest.h"
#import "MSURLConnection.h"

#define GOOGLE_PLACE_API_KEY @"AIzaSyD0tUcYWxjL0iw56FHIK-TqY9e5NkhT63s"
#define PLACE_TYPE @"(cities)"
#define PLACE_RADIUS 500000

#define GOOGLE_KEY_PREDICTIONS @"predictions"
#define GOOGLE_KEY_PREDICTION_DESCRIPTION @"description"

@interface MSAutocompleteRequest() <MSURLConnectionDelegate>

@property (strong, nonatomic) MSURLConnection *activeConnection;

@end

@implementation MSAutocompleteRequest

- (void)requestWithString:(NSString *)string andLocation:(CGPoint)location
{
    NSString *sURL = @"https://maps.googleapis.com/maps/api/place/autocomplete/json";
    
    sURL = [sURL stringByAppendingFormat:@"?input=%@",string];
    sURL = [sURL stringByAppendingFormat:@"&sensor=true"];
    sURL = [sURL stringByAppendingFormat:@"&key=%@",GOOGLE_PLACE_API_KEY];
    sURL = [sURL stringByAppendingFormat:@"&types=%@",PLACE_TYPE];
    sURL = [sURL stringByAppendingFormat:@"&location=%f,%f",location.x, location.y];
    sURL = [sURL stringByAppendingFormat:@"&radius=%d",PLACE_RADIUS];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:sURL]];
    
    self.activeConnection = [MSURLConnection connectionWithRequest:request delegate:self];
    [self.activeConnection startConnection];
}

#pragma mark MSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    
}

- (void)connection:(NSURLConnection *)connection didReceiveJson:(NSDictionary *)json
{
    if ([connection isEqual:self.activeConnection]) {
        NSArray *predictions = [json objectForKey:GOOGLE_KEY_PREDICTIONS];
        NSMutableArray *places = [[NSMutableArray alloc] init];
        
        for (NSDictionary *prediction in predictions) {
            NSString *placeDescription = [prediction objectForKey:GOOGLE_KEY_PREDICTION_DESCRIPTION];
            [places addObject:placeDescription];
        }
        
        if ([self.delegate respondsToSelector:@selector(autocompleteRequestDidFinishWithPredictions:)]) {
            [self.delegate autocompleteRequestDidFinishWithPredictions:places];
        }
    }
}

- (void)connectionDidStart:(MSURLConnection *)connection
{
    
}

@end
