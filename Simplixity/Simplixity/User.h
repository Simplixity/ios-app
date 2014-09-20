//
//  User.h
//  Simplixity
//
//  Created by Donald Ritter on 9/20/14.
//  Copyright (c) 2014 Simplixity. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject
//  Uid of the users account.
@property(nonatomic)NSString *uid;

//  Uid of the actual person representing the user.
@property(nonatomic)NSString *personUid;

//  Uid of the employers organization.
@property(nonatomic)NSString *employerUid;

//  Uid of the users guardian.
@property(nonatomic)NSString *guardianUid;

//  Uid of the mothers person.
@property(nonatomic)NSString *motherUid;

//  Uid of the fathers person.
@property(nonatomic)NSString *fatherUid;

//  Uid of the emergency contact.
@property(nonatomic)NSString *emergencyUid;

//  Users religious preference
@property(nonatomic)NSString *religiousPreference;

//  Whether the user is an organ donor not not.
@property(nonatomic)BOOL *organDonor;
@end
