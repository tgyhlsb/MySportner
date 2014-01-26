//
//  MSCircleView.m
//  MySportner
//
//  Created by Tanguy Hélesbeux on 26/01/2014.
//  Copyright (c) 2014 MySportner. All rights reserved.
//

#import "MSCircleView.h"

@interface MSCircleView()

@property (strong, nonatomic) UIImageView *imageView;

@end

@implementation MSCircleView

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"redCircle.png"]];
        _imageView.frame = CGRectMake(0, 0, 0, 0);
        [self addSubview:_imageView];
    }
    return _imageView;
}

- (void)drawMapRect:(MKMapRect)mapRect
          zoomScale:(MKZoomScale)zoomScale
          inContext:(CGContextRef)ctx
{
    
    //the circle center
    MKMapPoint mpoint = MKMapPointForCoordinate([[self overlay] coordinate]);
    
    //geting the radius in map point
    double radius = [(MKCircle*)[self overlay] radius];
    double mapRadius = radius * MKMapPointsPerMeterAtLatitude([[self overlay] coordinate].latitude);
    
    //calculate the rect in map coordination
    MKMapRect mrect = MKMapRectMake(mpoint.x - mapRadius, mpoint.y - mapRadius, mapRadius * 2, mapRadius * 2);
    
    //get the rect in pixel coordination and set to the imageView
    CGRect rect = [self rectForMapRect:mrect];
    
    self.imageView.frame = rect;

}

@end
