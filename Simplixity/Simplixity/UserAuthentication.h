//
//  UserAuthentication.h
//  Simplixity
//
//  Created by Donald Ritter on 9/20/14.
//  Copyright (c) 2014 Simplixity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@protocol UserAuthenticationListener <NSObject>
@optional
//  Authenitcation began.
-(void)userAuthentication:(id)sender didBeginForUser:(User*)user;

//  Authentication was successful.
-(void)userAuthentication:(id)sender endedSuccessfullyForUser:(User*)user;

//  Authentication failed with an error.
-(void)userAuthentication:(id)sender forUser:(User*)user endedWithError:(NSString*)error;
@end

@protocol UserAuthentication <NSObject>
//  Performs the user authentication.
-(void)authenticateUser:(User*)user withPassword:(NSString*)password;

//  Adds an authentication listener.
-(void)addUserAuthenticationListener:(id<UserAuthenticationListener>)listener;

//  Removes an authentication listener.
-(void)removeUserAuthenticationListener:(id<UserAuthenticationListener>)listener;

//  Whether this instance is currently authenticating.
@property(nonatomic, readonly)BOOL isAuthenticating;
@end
