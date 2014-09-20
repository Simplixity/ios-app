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

#define POLICY_TYPE_MEDICAL_INSURANCE = @"policy-type-medical-insurance";
#define POLICY_TYPE_DENTAL_INSURANCE = @"policy-type-dental-insurance";
#define POLICY_TYPE_LIFE_INSURANCE = @"policy-type-life-insurance";
#define POLICY_TYPE_VISION_INSURANCE = @"policy-type-vision-insurance";

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
@end
