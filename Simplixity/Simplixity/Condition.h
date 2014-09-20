//
//  Condition.h
//  Simplixity
//
//  Created by Donald Ritter on 9/20/14.
//  Copyright (c) 2014 Simplixity. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const CONDITION_TYPE_ALLERGY;
extern NSString * const CONDITION_TYPE_DISEASE;

//  Defines a condition
@interface Condition : NSObject
//  Unique identifier for the condition.
@property(nonatomic)NSString *uid;

//  Type of the condition with constants starting with CONDITION_TYPE_.
@property(nonatomic)NSString *type;

//  Underwriters code for the specific condition.
@property(nonatomic)NSString *code;
@end
