//
//  Person.m
//  Simplixity
//
//  Created by Donald Ritter on 9/20/14.
//  Copyright (c) 2014 Simplixity. All rights reserved.
//

#import "Person.h"

@implementation Person
@synthesize uid = _uid;
@synthesize name = _name;
@synthesize addresses = _addresses;
@synthesize birthAddress = _birthAddress;
@synthesize socialSecurity = _socialSecurity;
@synthesize sex = _sex;
@synthesize maritalStatus = _maritalStatus;
@synthesize race = _race;
@synthesize birthDate = _birthDate;
@synthesize emails = _emails;
@synthesize phones = _phones;

#pragma mark - Getters and Setters
-(NSString*)uid {
    if (!_uid) {
        _uid = @"";
    }
    
    return _uid;
}

-(Name*)name {
    if (!_name) {
        _name = [[Name alloc] init];
    }
    
    return _name;
}

-(NSMutableArray*)addresses {
    if (!_addresses) {
        _addresses = [[NSMutableArray alloc] init];
    }
    
    return _addresses;
}

-(Address*)birthAddress {
    if (!_birthAddress) {
        _birthAddress = [[Address alloc] init];
    }
    
    return _birthAddress;
}

-(NSString*)socialSecurity {
    if (!_socialSecurity) {
        _socialSecurity = @"";
    }
    
    return _socialSecurity;
}

-(NSDate*)birthDate {
    if (!_birthDate) {
        _birthDate = [NSDate dateWithTimeIntervalSince1970:0];
    }
    
    return _birthDate;
}

-(NSMutableArray*)emails {
    if (!_emails) {
        _emails = [[NSMutableArray alloc] init];
    }
    
    return _emails;
}

-(NSMutableArray*)phones {
    if (!_phones) {
        _phones = [[NSMutableArray alloc] init];
    }
    
    return _phones;
}
@end
