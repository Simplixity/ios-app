//
//  Organization.h
//  Simplixity
//
//  Created by Donald Ritter on 9/20/14.
//  Copyright (c) 2014 Simplixity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Address.h"

//  Defines information about an organization.  An organization can be an employer, insurance company, pretty much anything that is not a single person.
@interface Organization : NSObject
//  Unique identifier for the organization.
@property(nonatomic)NSString *uid;

//  Full name of the organization.
@property(nonatomic)NSString *name;

//  Array of addresses the organization uses with the first as primary.
@property(nonatomic)NSMutableArray *addresses;

//  Array of emails the organization can be contacted at with the first as primary.
@property(nonatomic)NSMutableArray *emails;

//  Array of phone numbers the organization can be contacted at with the first as primary.
@property(nonatomic)NSMutableArray *phones;
@end
