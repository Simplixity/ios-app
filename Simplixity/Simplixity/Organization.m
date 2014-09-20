//
//  Organization.m
//  Simplixity
//
//  Created by Donald Ritter on 9/20/14.
//  Copyright (c) 2014 Simplixity. All rights reserved.
//

#import "Organization.h"

@implementation Organization
@synthesize uid = _uid;
@synthesize name = _name;
@synthesize addresses = _addresses;
@synthesize emails = _emails;
@synthesize phones = _phones;

#pragma mark - Getters and Setters
-(NSString*)uid {
    if (!_uid) {
        _uid = @"";
    }
    
    return _uid;
}

-(NSString*)name {
    if (!_name) {
        _name = @"";
    }
    
    return _name;
}

-(NSMutableArray*)addresses {
    if (!_addresses) {
        _addresses = [[NSMutableArray alloc] init];
    }
    
    return _addresses;
}

-(NSMutableArray*)phones {
    if (!_phones) {
        _phones = [[NSMutableArray alloc] init];
    }
    
    return _phones;
}
@end
