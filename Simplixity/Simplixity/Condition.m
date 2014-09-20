//
//  Condition.m
//  Simplixity
//
//  Created by Donald Ritter on 9/20/14.
//  Copyright (c) 2014 Simplixity. All rights reserved.
//

#import "Condition.h"

NSString * const CONDITION_TYPE_ALLERGY = @"allergy";
NSString * const CONDITION_TYPE_DISEASE = @"disease";

@implementation Condition
@synthesize uid = _uid;
@synthesize type = _type;
@synthesize code = _code;

#pragma mark - Getters and Setters
-(NSString*)uid {
    if (!_uid) {
        _uid = @"";
    }
    
    return _uid;
}

-(NSString*)type {
    if (!_type) {
        _type = CONDITION_TYPE_ALLERGY;
    }
    
    return _type;
}

-(NSString*)code {
    if (!_code) {
        _code = @"";
    }
    
    return _code;
}
@end
