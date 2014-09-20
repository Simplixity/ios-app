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

//  Type of policy with constants starting with POLICY_TYPE_.
@property(nonatomic)NSString *type;

//  Underwrites/insurers identifier for the policy.  This usually is from the insurance card.
@property(nonatomic)NSString *policyId;

//  Identifier for who is supposed to pay.  This usually is from the insurance card.
@property(nonatomic)NSString *payorId;

//  Identifier for the policies group.  This usually is from the insurance card.
@property(nonatomic)NSString *groupId;

//  Name of the policies group.  This usually is from the insurance card.
@property(nonatomic)NSString *groupName;

//  Uid of the user who is the primary policy holder.
@property(nonatomic)NSString *subscriberUid;

//  Uid of the user using this specific policy.
@property(nonatomic)NSString *userUid;

//  Uid of the employer the policy is under.
@property(nonatomic)NSString *employerUid;

//  Uid of the underwriter or insurance organization running the policy.
@property(nonatomic)NSString *underwriterUid;

//  Date the policy starts.  Defaults to Epoc.
@property(nonatomic)NSDate *effectiveStart;

//  Date the policy ends.  Defaults to Epoc.
@property(nonatomic)NSDate *effectiveEnd;

//  Gets whether the policy is in effect.
@property(nonatomic,readonly)BOOL isInEffect;
@end
