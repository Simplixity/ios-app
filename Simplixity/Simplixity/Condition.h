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
@property(nonatomic)NSString *uid;
@property(nonatomic)NSString *type;
@property(nonatomic)NSString *code;
@end
