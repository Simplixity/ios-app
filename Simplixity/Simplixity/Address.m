//
//  Address.m
//  Simplixity
//
//  Created by Donald Ritter on 9/20/14.
//  Copyright (c) 2014 Simplixity. All rights reserved.
//

#import "Address.h"

@implementation Address
@synthesize street = _street;
@synthesize unit = _unit;
@synthesize city = _city;
@synthesize state = _state;
@synthesize zip = _zip;
@synthesize country = _country;

#pragma mark - Getters and Setters
-(NSString*)street {
    if (!_street) {
        _street = @"";
    }
    
    return _street;
}

-(NSString*)unit {
    if (!_unit) {
        _unit = @"";
    }
    
    return _unit;
}

-(NSString*)city {
    if (!_city) {
        _city = @"";
    }
    
    return _city;
}

-(NSString*)state {
    if (!_state) {
        _state = @"";
    }
    
    return _state;
}

-(NSString*)zip {
    if (!_zip) {
        _zip = @"";
    }
    
    return _zip;
}

-(NSString*)country {
    if (!_country) {
        _country = @"";
    }
    
    return _country;
}
@end
