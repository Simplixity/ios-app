//
//  Policy.m
//  Simplixity
//
//  Created by Donald Ritter on 9/20/14.
//  Copyright (c) 2014 Simplixity. All rights reserved.
//

#import "Policy.h"

NSString * const POLICY_TYPE_MEDICAL_INSURANCE = @"medical-insurance";
NSString * const POLICY_TYPE_DENTAL_INSURANCE = @"dental-insurance";
NSString * const POLICY_TYPE_LIFE_INSURANCE = @"life-insurance";
NSString * const POLICY_TYPE_VISION_INSURANCE = @"vision-insurance";

@implementation Policy
@synthesize uid = _uid;
@synthesize type = _type;
@synthesize policyId = _policyId;
@synthesize payorId = _payorId;
@synthesize groupId = _groupId;
@synthesize groupName = _groupName;
@synthesize subscriberUid = _subscriberUid;
@synthesize userUid = _userUid;
@synthesize employerUid = _employerUid;
@synthesize underwriterUid = _underwriterUid;
@synthesize effectiveStart = _effectiveStart;
@synthesize effectiveEnd = _effectiveEnd;

#pragma mark - Getters and Setters
-(NSString*)uid {
    if (!_uid) {
        _uid = @"";
    }
    
    return _uid;
}

-(NSString*)type {
    if (!_type) {
        _type = @"";
    }
    
    return _type;
}

-(NSString*)policyId {
    if (!_policyId) {
        _policyId = @"";
    }
    
    return _policyId;
}

-(NSString*)payorId {
    if (!_payorId) {
        _payorId = @"";
    }
    
    return _payorId;
}

-(NSString*)groupId {
    if (!_groupId) {
        _groupId = @"";
    }
    
    return _groupId;
}

-(NSString*)groupName {
    if (!_groupName) {
        _groupName = @"";
    }
    
    return _groupName;
}

-(NSString*)subscriberUid {
    if (!_subscriberUid) {
        _subscriberUid = @"";
    }
    
    return _subscriberUid;
}

-(NSString*)userUid {
    if (!_userUid) {
        _userUid = @"";
    }
    
    return _userUid;
}

-(NSString*)employerUid {
    if (!_employerUid) {
        _employerUid = @"";
    }
    
    return _employerUid;
}

-(NSString*)underwriterUid {
    if (!_underwriterUid) {
        _underwriterUid = @"";
    }
    
    return _underwriterUid;
}

-(NSDate*)effectiveStart {
    if (!_effectiveStart) {
        _effectiveStart = [NSDate dateWithTimeIntervalSince1970:0];
    }
    
    return _effectiveStart;
}

-(NSDate*)effectiveEnd {
    if (!_effectiveEnd) {
        _effectiveEnd = [NSDate dateWithTimeIntervalSince1970:0];
    }
    
    return _effectiveEnd;
}

-(BOOL)isInEffect {
    NSTimeInterval today = [[NSDate date] timeIntervalSince1970];
    
    if (today >= [self.effectiveStart timeIntervalSince1970] && today <= [self.effectiveEnd timeIntervalSince1970]) {
        return YES;
    }
    
    return NO;
}

@end
