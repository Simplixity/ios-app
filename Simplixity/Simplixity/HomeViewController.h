//
//  HomeViewController.h
//  Simplixity
//
//  Created by Donald Ritter on 9/21/14.
//  Copyright (c) 2014 Simplixity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "Person.h"

@class HomeViewController;

@protocol HomeViewControllerDelegate <NSObject>
//  Called when a new registration is supposed to occur.
-(void)homeViewControllerNewRegistration:(HomeViewController*)controller;
@end

@interface HomeViewController : UIViewController
//  User who logged in.
@property(nonatomic)User *user;

//  Person info for the user.
@property(nonatomic)Person *person;

//  Delegate used to communicate what is supposed to happen.
@property(nonatomic)id<HomeViewControllerDelegate> delegate;
@end
