//
//  GradientView.h
//  Simplixity
//
//  Created by Donald Ritter on 9/20/14.
//  Copyright (c) 2014 Simplixity. All rights reserved.
//

@interface GradientView : UIView

@property(nonatomic, strong)UIColor *topColor;
@property(nonatomic, strong)UIColor *bottomColor;

-(id) initWithFrame:(CGRect)frame andTopColor:(UIColor *)topColor bottomColor:(UIColor *)bottomColor;
@end

