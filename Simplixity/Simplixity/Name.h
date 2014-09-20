//
//  PersonName.h
//  Simplixity
//
//  Created by Donald Ritter on 9/20/14.
//  Copyright (c) 2014 Simplixity. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Name : NSObject
//  Persons first name.
@property(nonatomic)NSString *first;

//  Persons middle name.
@property(nonatomic)NSString *middle;

//  Persons last name.
@property(nonatomic)NSString *last;

//  Optional maiden name.
@property(nonatomic)NSString *maiden;
@end
