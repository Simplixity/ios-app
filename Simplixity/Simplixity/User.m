//
//  User.m
//  Simplixity
//
//  Created by Donald Ritter on 9/20/14.
//  Copyright (c) 2014 Simplixity. All rights reserved.
//

#import "User.h"
//  Defines the information for a user.
@implementation User
@synthesize uid = _uid;
@synthesize personUid = _personUid;
@synthesize employerUid = _employerUid;
@synthesize guardianUid = _guardianUid;
@synthesize motherUid = _motherUid;
@synthesize fatherUid = _fatherUid;
@synthesize emergencyUid = _emergencyUid;
@synthesize religiousPreference = _religiousPreference;
@synthesize organDonor = _organDonor;
@synthesize conditions = _conditions;

#pragma mark - Getters and Setters
-(NSString*)uid {
    if (!_uid) {
        _uid = @"";
    }
    
    return _uid;
}

-(NSString*)personUid {
    if (!_personUid) {
        _personUid = @"";
    }
    
    return _personUid;
}

-(NSString*)employerUid {
    if (!_employerUid) {
        _employerUid = @"";
    }
    
    return _employerUid;
}

-(NSString*)guardianUid {
    if (!_guardianUid) {
        _guardianUid = @"";
    }
    
    return _guardianUid;
}

-(NSString*)motherUid {
    if (!_motherUid) {
        _motherUid = @"";
    }
    
    return _motherUid;
}

-(NSString*)fatherUid {
    if (!_fatherUid) {
        _fatherUid = @"";
    }
    
    return _fatherUid;
}

-(NSString*)emergencyUid {
    if (!_emergencyUid) {
        _emergencyUid = @"";
    }
    
    return _emergencyUid;
}

-(NSString*)religiousPreference {
    if (!_religiousPreference) {
        _religiousPreference = @"";
    }
    
    return _religiousPreference;
}

-(NSMutableArray*)conditions {
    if (!_conditions) {
        _conditions = [[NSMutableArray alloc] init];
    }
    
    return _conditions;
}
@end
