//
//  AuthenticationViewController.m
//  Simplixity
//
//  Created by Donald Ritter on 9/20/14.
//  Copyright (c) 2014 Simplixity. All rights reserved.
//

#import "AuthenticationViewController.h"
#import "UserAuthentication.h"
#import "MockUserAuthentication.h"
#import "User.h"

@interface AuthenticationViewController () <UITextFieldDelegate, UserAuthenticationListener>
@property(nonatomic)IBOutlet UIImageView *logoImage;
@property(nonatomic)IBOutlet NSLayoutConstraint *logoImageTopConstraint;
@property(nonatomic)IBOutlet UITextField *pinInput;
@property(nonatomic)IBOutlet UIButton *signInButton;
@property(nonatomic)IBOutlet UIButton *signUpButton;
@property(nonatomic)BOOL shownFirst;
@property(nonatomic)User *user;
@property(nonatomic)MockUserAuthentication *userAuthentication;
@end

@implementation AuthenticationViewController
@synthesize logoImage = _logoImage;
@synthesize logoImageTopConstraint = _logoImageTopConstraint;
@synthesize pinInput = _pinInput;
@synthesize signInButton = _signInButton;
@synthesize signUpButton = _signUpButton;
@synthesize shownFirst = _shownFirst;
@synthesize user = _user;
@synthesize userAuthentication = _userAuthentication;

#pragma mark - View Lifecycle
-(void)viewDidAppear:(BOOL)animated
{
    if (!self.shownFirst) {
        self.shownFirst = YES;
        
        self.pinInput.alpha = 0;
        self.signInButton.alpha = 0;
        self.signUpButton.alpha = 0;
        self.logoImageTopConstraint.constant = 150;
        [self.view setNeedsUpdateConstraints];
        
        [UIView animateWithDuration:1 animations:^{
            [self.view layoutIfNeeded];
            
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:.5 animations:^{
                self.pinInput.alpha = 1.0f;
                self.signInButton.alpha = 1.0f;
                self.signUpButton.alpha = 1.0f;
            }];
        }];
    }
    
    [super viewDidAppear:animated];
}

#pragma mark - UITextFieldDelegate
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *) event
{
    UITouch *touch = [[event allTouches] anyObject];
    if ([self.pinInput isFirstResponder] && (self.pinInput != touch.view))
    {
        [self unfocusPin];
    }
}

-(void)focusPin {
    [UIView animateWithDuration:0.25 animations:^{
        self.pinInput.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1.0f];
    }];
}

-(void)unfocusPin {
    [self.pinInput resignFirstResponder];
    
    [UIView animateWithDuration:0.25 animations:^{
        self.pinInput.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:.25f];
    }];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField == self.pinInput) {
        [self focusPin];
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == self.pinInput) {
        [self unfocusPin];
    }
}

#pragma mark - UserAuthentication
-(MockUserAuthentication*)userAuthentication {
    if (!_userAuthentication) {
        _userAuthentication = [[MockUserAuthentication alloc] init];
        [self.userAuthentication addUserAuthenticationListener:self];
    }
    
    return _userAuthentication;
}

-(void)userAuthentication:(id)sender didBeginForUser:(User*)user {
    [self disableUI];
}

-(void)userAuthentication:(id)sender endedSuccessfullyForUser:(User*)user {
    [self enableUI];
}

-(void)userAuthentication:(id)sender forUser:(User*)user endedWithError:(NSString*)error {
    [self enableUI];
    NSLog(@"Error:%@", error);
}

-(void)disableUI {
    self.pinInput.enabled = NO;
    self.signInButton.enabled = NO;
    self.signUpButton.enabled = NO;
    
    [UIView animateWithDuration:.25 animations:^{
        self.pinInput.alpha = 0.0f;
        self.signInButton.alpha = 0.0f;
        self.signUpButton.alpha = 0.0f;
    }];
}

-(void)enableUI {
    [UIView animateWithDuration:.25 animations:^{
        self.pinInput.alpha = 1.0f;
        self.signInButton.alpha = 1.0f;
        self.signUpButton.alpha = 1.0f;
    } completion:^(BOOL finished) {
        self.pinInput.enabled = YES;
        self.signInButton.enabled = YES;
        self.signUpButton.enabled = YES;
    }];
}

-(IBAction)handleSignInClick:(id)sender
{
    [self.userAuthentication authenticateUser:self.user withPassword:self.pinInput.text];
}

#pragma mark - User
-(User*)user {
    if (!_user) {
        _user = [[User alloc] init];
        self.user.uid = @"541e065556602720c48baa6f";
    }
    
    return _user;
}

@end
