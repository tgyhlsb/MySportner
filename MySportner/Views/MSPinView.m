//
//  MSPinView.m
//  MySportner
//
//  Created by Tanguy Hélesbeux on 27/01/2014.
//  Copyright (c) 2014 MySportner. All rights reserved.
//

#import "MSPinView.h"

#define VERTICAL_OFFSET 5
#define HORIZONTAL_OFFSET 0

@interface MSPinView()

@property (strong, nonatomic) UIImageView *pinCenterView;

@end

@implementation MSPinView

- (id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [[UIColor orangeColor] colorWithAlphaComponent:0.3];
        self.pinCenterView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pin.png"]];
        [self setPinCenterFrame];
        [self addSubview:self.pinCenterView];
    }
    return self;
}

- (void)setSize:(CGSize)size
{
    CGFloat x = self.frame.origin.x + (self.frame.size.width - size.width)/2;
    CGFloat y = self.frame.origin.y + (self.frame.size.height - size.height)/2;
    
    self.frame = CGRectMake(x, y, size.width, size.height);
    self.layer.cornerRadius = size.width/2;
    
    [self setPinCenterFrame];
}

- (void)setPinCenterFrame
{
    CGFloat width = self.pinCenterView.frame.size.width;
    CGFloat height = self.pinCenterView.frame.size.height;
    CGFloat x = (self.bounds.size.width - self.pinCenterView.frame.size.width)/2 + HORIZONTAL_OFFSET;
    CGFloat y = self.bounds.size.height/2 - self.pinCenterView.frame.size.height + VERTICAL_OFFSET;
    
    self.pinCenterView.frame = CGRectMake(x, y, width, height);
}

@end
