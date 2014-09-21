//
//  MockUserInformation.h
//  Simplixity
//
//  Created by Donald Ritter on 9/21/14.
//  Copyright (c) 2014 Simplixity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInformation.h"
#import "User.h"

@interface MockPersonInformation : NSObject<PersonInformation>
//  User currently loading.
@property(nonatomic, readonly)NSString *personUid;
@end
