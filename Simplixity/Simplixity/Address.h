//
//  Address.h
//  Simplixity
//
//  Created by Donald Ritter on 9/20/14.
//  Copyright (c) 2014 Simplixity. All rights reserved.
//

#import <Foundation/Foundation.h>

//  Defines a simple address structure
@interface Address : NSObject
//  Street not including the unit or apartment number.
@property(nonatomic)NSString *street;
@property(nonatomic)NSString *unit;
@property(nonatomic)NSString *city;
@property(nonatomic)NSString *state;
@property(nonatomic)NSString *zip;
@property(nonatomic)NSString *country;
@end
