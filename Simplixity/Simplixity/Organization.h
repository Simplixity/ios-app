//
//  Organization.h
//  Simplixity
//
//  Created by Donald Ritter on 9/20/14.
//  Copyright (c) 2014 Simplixity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Address.h"

//  Defines information about an organization.  For each array the first item is the primary.
@interface Organization : NSObject
@property(nonatomic)NSString *uid;
@property(nonatomic)NSString *name;
@property(nonatomic)NSMutableArray *addresses;
@property(nonatomic)NSMutableArray *emails;
@property(nonatomic)NSMutableArray *phones;
@end
