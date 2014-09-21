//
//  AuthenticationViewController.h
//  Simplixity
//
//  Created by Donald Ritter on 9/20/14.
//  Copyright (c) 2014 Simplixity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "Person.h"

@class AuthenticationViewController;

//  Delegate used to communicate
@protocol AuthenticationViewControllerDelegate <NSObject>
//  Called when the controller has authenticated successfully.
-(void)authenticationViewControllerDidAuthenticateSuccessfully:(AuthenticationViewController*)controller withUser:(User*)user andPerson:(Person*)person;
@end

@interface AuthenticationViewController : UIViewController
//  Delegate used to communicate.
@property(nonatomic)id<AuthenticationViewControllerDelegate>delegate;
@end
