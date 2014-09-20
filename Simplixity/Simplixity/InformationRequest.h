//
//  InformationRequest.h
//  Simplixity
//
//  Created by Donald Ritter on 9/20/14.
//  Copyright (c) 2014 Simplixity. All rights reserved.
//

#import <Foundation/Foundation.h>

//  Defines what information is being requested.
@interface InformationRequest : NSObject
//  Whether to include personal information including social security, religious, and organ doner.
@property(nonatomic)BOOL personal;

//  Whether to include employer information.
@property(nonatomic)BOOL employer;

//  Whether to include your mothers information.
@property(nonatomic)BOOL mother;

//  Whether to include your fathers information.
@property(nonatomic)BOOL father;

//  Whether to include your guardians information.
@property(nonatomic)BOOL guardian;

//  Whether to include your emergency contact information.
@property(nonatomic)BOOL emergency;

//  Whether to include your medical insurance policy information.
@property(nonatomic)BOOL medicalInsurancePolicies;

//  Whether to include your dental insurance policy information.
@property(nonatomic)BOOL dentalInsurancePolicies;

//  Whether to include your vision insurance policy information.
@property(nonatomic)BOOL visionInsurancePolicies;

//  Whether to include your life insurance policy information.
@property(nonatomic)BOOL lifeInsurancePolicies;

//  Whether to include your conditions.
@property(nonatomic)BOOL conditions;
@end
