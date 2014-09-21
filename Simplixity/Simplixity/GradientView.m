//
//  GradientView.m
//  Simplixity
//
//  Created by Donald Ritter on 9/20/14.
//  Copyright (c) 2014 Simplixity. All rights reserved.
//

#import "GradientView.h"

@implementation GradientView
@synthesize topColor = _topColor;
@synthesize bottomColor = _bottomColor;

- (id) initWithFrame:(CGRect)frame andTopColor:(UIColor *)topColor bottomColor:(UIColor *)bottomColor
{
    self = [super initWithFrame:frame];
    if (self) {
        self.topColor = topColor;
        self.bottomColor = bottomColor;
    }
    return self;
}

- (void) setTopColor:(UIColor *)topColor
{
    _topColor = topColor;
    [self setNeedsDisplay];
}

- (UIColor *)topColor
{
    if (!_topColor) {
        //_topColor = [UIColor colorWithRed:51/255.0 green:121/255.0 blue:190/255.0 alpha:1.0f];
        _topColor = [UIColor colorWithRed:88/255.0 green:161/255.0 blue:208/255.0 alpha:1.0f];
    }
    
    return [[UIColor alloc] initWithCGColor:_topColor.CGColor];
}

- (void) setBottomColor:(UIColor *)bottomColor
{
    _bottomColor = bottomColor;
    [self setNeedsDisplay];
}

- (UIColor *)bottomColor
{
    if (!_bottomColor) {
        //_bottomColor = [UIColor colorWithRed:51/255.0 green:121/255.0 blue:190/255.0 alpha:1.0f];
        _bottomColor = [UIColor colorWithRed:88/255.0 green:161/255.0 blue:208/255.0 alpha:1.0f];
    }
    
    return [[UIColor alloc] initWithCGColor:_bottomColor.CGColor];
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[] = {0.0, 1.0};
    
    NSArray *colors = [NSArray arrayWithObjects: (id)self.topColor.CGColor,
                       (id)self.bottomColor.CGColor,
                       nil];
    
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) colors, locations);
    
    CGPoint start = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
    CGPoint end = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
    
    CGContextSaveGState(context);
    CGContextAddRect(context, rect);
    CGContextClip(context);
    CGContextDrawLinearGradient(context, gradient, start, end, 0);
    CGContextRestoreGState(context);
    
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
}
@end
