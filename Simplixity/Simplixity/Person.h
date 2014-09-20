//
//  Person.h
//  Simplixity
//
//  Created by Donald Ritter on 9/20/14.
//  Copyright (c) 2014 Simplixity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Address.h"
#import "Name.h"

//  Valid races for a user.
typedef enum : NSUInteger {
    UserRaceAsian = 0,
    UserRaceHispanic,
    UserRaceAfricanAmerican,
    UserRaceAmericanIndian,
    UserRaceIndianAmerican,
    UserRaceCaucasion
} UserRace;

//  Valid sexes for users.
typedef enum : NSUInteger {
    UserSexMale = 0,
    UserSexFemale
} UserSex;

//  Valid marital status.
typedef enum : NSUInteger {
    UserMaritalStatusSingle = 0,
    UserMaritalStatusMarried,
    UserMaritalStatusSeparated,
    UserMaritalStatusWidowed,
    UserMaritalStatusDivorced
} UserMaritalStatus;

//  User is a single person who would use the app.
@interface Person : NSObject
@property(nonatomic)NSString *uid;
@property(nonatomic)Name *name;
@property(nonatomic)NSMutableArray *addresses;
@property(nonatomic)Address *birthAddress;
@property(nonatomic)NSString *socialSecurity;
@property(nonatomic)UserRace race;
@property(nonatomic)UserSex sex;
@property(nonatomic)UserMaritalStatus maritalStatus;
@property(nonatomic)NSDate *birthDate;
@property(nonatomic)NSMutableArray *emails;
@property(nonatomic)NSMutableArray *phones;
@end
