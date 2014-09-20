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

//  Optional apartment or unit number.
@property(nonatomic)NSString *unit;

//  City, town, or village the address is in.
@property(nonatomic)NSString *city;

//  State or province the address is in.
@property(nonatomic)NSString *state;

//  Zip or postal code for the address.
@property(nonatomic)NSString *zip;

//  Country the address is in.
@property(nonatomic)NSString *country;
@end
