//
//  MockUserAuthentication.h
//  Simplixity
//
//  Created by Donald Ritter on 9/20/14.
//  Copyright (c) 2014 Simplixity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserAuthentication.h"
#import "User.h"

//  Mock authentication system for startup weekend.
@interface MockUserAuthentication : NSObject<UserAuthentication>
//  User currently being authenticated.
@property(nonatomic, readonly)User *authenticatingUser;
@end
