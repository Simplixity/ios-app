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
//  Unique identifier for the person.
@property(nonatomic)NSString *uid;

//  Name information for the person.
@property(nonatomic)Name *name;

//  Array of addresses with the first as primary.
@property(nonatomic)NSMutableArray *addresses;

//  Address the person was born at.
@property(nonatomic)Address *birthAddress;

//  Social security or government identification number.
@property(nonatomic)NSString *socialSecurity;

//  Race of the person.
@property(nonatomic)UserRace race;

//  Sex of the person.
@property(nonatomic)UserSex sex;

//  Marital status of the person.
@property(nonatomic)UserMaritalStatus maritalStatus;

//  Date the person was born.  Defaults to Epoc.
@property(nonatomic)NSDate *birthDate;

//  Array of email addresses the user can be contacted by with the first as primary.
@property(nonatomic)NSMutableArray *emails;

//  Array of phone numbers the user can be contacted by with the first as primary.
@property(nonatomic)NSMutableArray *phones;
@end
