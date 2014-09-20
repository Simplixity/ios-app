//
//  PersonName.m
//  Simplixity
//
//  Created by Donald Ritter on 9/20/14.
//  Copyright (c) 2014 Simplixity. All rights reserved.
//

#import "Name.h"

@implementation Name
@synthesize first = _first;
@synthesize middle = _middle;
@synthesize last = _last;
@synthesize maiden = _maiden;

#pragma mark - Getters and Setters
-(NSString*)first {
    if (!_first) {
        _first = @"";
    }
    
    return _first;
}

-(NSString*)middle {
    if (!_middle) {
        _middle = @"";
    }
    
    return _middle;
}

-(NSString*)last {
    if (!_last) {
        _last = @"";
    }
    
    return _last;
}

-(NSString*)maiden {
    if (!_maiden) {
        _maiden = @"";
    }
    
    return _maiden;
}
@end
