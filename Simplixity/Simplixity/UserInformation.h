//
//  UserInformation.h
//  Simplixity
//
//  Created by Donald Ritter on 9/21/14.
//  Copyright (c) 2014 Simplixity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Person.h"
#import "User.h"

@protocol PersonInformationListener <NSObject>
-(void)personInformation:(id)sender didBeginLoadingForPersonUid:(NSString*)personUid;
-(void)personInformation:(id)sender didEndLoadingSuccessfullyForPersonUid:(NSString*)personUid intoPerson:(Person*)person;
-(void)personInformation:(id)sender didEndLoadingForPersonUid:(NSString*)personUid withError:(NSString*)error;
@end

@protocol PersonInformation <NSObject>
//  Whether there is a person currently loading.
@property(nonatomic, readonly)BOOL isLoading;

//  Loads the information into the user.
-(void)loadInformationForPerson:(NSString*)personUid;

//  Adds an information listner.
-(void)addPersonInformationListener:(id<PersonInformationListener>)listener;

//  Removes a information listener.
-(void)removePersonInformationListener:(id<PersonInformationListener>)listener;
@end
