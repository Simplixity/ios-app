//
//  Policy.h
//  Simplixity
//
//  Created by Donald Ritter on 9/20/14.
//  Copyright (c) 2014 Simplixity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Address.h"
#import "Name.h"
#import "Organization.h"

extern NSString * const POLICY_TYPE_MEDICAL_INSURANCE;
extern NSString * const POLICY_TYPE_DENTAL_INSURANCE;
extern NSString * const POLICY_TYPE_LIFE_INSURANCE;
extern NSString * const POLICY_TYPE_VISION_INSURANCE;

//  Defines basic information for a policy
@interface Policy : NSObject
@property(nonatomic)NSString *uid;
@property(nonatomic)NSString *type;

@property(nonatomic)NSString *policyId;
@property(nonatomic)NSString *payorId;
@property(nonatomic)NSString *groupId;
@property(nonatomic)NSString *groupName;

@property(nonatomic)NSString *subscriberUid;
@property(nonatomic)NSString *userUid;

@property(nonatomic)NSString *employerUid;
@property(nonatomic)NSString *underwriterUid;

@property(nonatomic)NSDate *effectiveStart;
@property(nonatomic)NSDate *effectiveEnd;

//  Gets whether the policy is in effect.
@property(nonatomic,readonly)BOOL isInEffect;
@end
