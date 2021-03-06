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
#import "UserInformation.h"
#import "MockPersonInformation.h"

@interface AuthenticationViewController () <UITextFieldDelegate, UserAuthenticationListener, PersonInformationListener>
@property(nonatomic)IBOutlet UIImageView *logoImage;
@property(nonatomic)IBOutlet NSLayoutConstraint *logoImageTopConstraint;
@property(nonatomic)IBOutlet UITextField *usernameInput;
@property(nonatomic)IBOutlet UITextField *passwordInput;
@property(nonatomic)IBOutlet UIButton *signInButton;
@property(nonatomic)IBOutlet UIButton *signUpButton;
@property(nonatomic)IBOutlet UIActivityIndicatorView *loadingIndicator;
@property(nonatomic)IBOutlet UILabel *loadingLabel;
@property(nonatomic)BOOL shownFirst;
@property(nonatomic)User *user;
@property(nonatomic)MockUserAuthentication *userAuthentication;
@property(nonatomic)MockPersonInformation *personInformation;
@end

@implementation AuthenticationViewController
@synthesize logoImage = _logoImage;
@synthesize logoImageTopConstraint = _logoImageTopConstraint;
@synthesize usernameInput = _usernameInput;
@synthesize passwordInput = _passwordInput;
@synthesize signInButton = _signInButton;
@synthesize signUpButton = _signUpButton;
@synthesize loadingIndicator = _loadingIndicator;
@synthesize loadingLabel = _loadingLabel;
@synthesize shownFirst = _shownFirst;
@synthesize user = _user;
@synthesize userAuthentication = _userAuthentication;

#pragma mark - View Lifecycle
-(void)viewDidAppear:(BOOL)animated
{
    if (!self.shownFirst) {
        self.shownFirst = YES;
        
        self.usernameInput.alpha = 0.0f;
        self.passwordInput.alpha = 0.0f;
        self.signInButton.alpha = 0.0f;
        self.signUpButton.alpha = 0.0f;
        self.loadingIndicator.alpha = 0.0f;
        self.loadingLabel.alpha = 0.0f;
        self.logoImageTopConstraint.constant = 150;
        [self.view setNeedsUpdateConstraints];
        
        [UIView animateWithDuration:1 animations:^{
            [self.view layoutIfNeeded];
            
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:.5 animations:^{
                self.usernameInput.alpha = 1.0f;
                self.passwordInput.alpha = 1.0f;
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
    if ([self.passwordInput isFirstResponder] && (self.passwordInput != touch.view))
    {
        [self unfocusPassword];
    }
    else if ([self.usernameInput isFirstResponder] && (self.usernameInput != touch.view))
    {
        [self unfocusUsername];
    }
}

-(void)focusPassword {
    [UIView animateWithDuration:0.25 animations:^{
        self.passwordInput.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1.0f];
    }];
}

-(void)focusUsername {
    [UIView animateWithDuration:0.25 animations:^{
        self.usernameInput.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1.0f];
    }];
}

-(void)unfocusPassword {
    [self.passwordInput resignFirstResponder];
    
    [UIView animateWithDuration:0.25 animations:^{
        self.passwordInput.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:.25f];
    }];
}

-(void)unfocusUsername {
    [self.usernameInput resignFirstResponder];
    
    [UIView animateWithDuration:0.25 animations:^{
        self.usernameInput.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:.25f];
    }];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField == self.passwordInput) {
        [self focusPassword];
    }
    else if (textField == self.usernameInput) {
        [self focusUsername];
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == self.passwordInput) {
        [self unfocusPassword];
    }
    else if (textField == self.usernameInput) {
        [self unfocusUsername];
    }
}

#pragma mark - UserAuthenticationListener
-(void)userAuthentication:(id)sender didBeginForUser:(User*)user {
    NSLog(@"userAuthentication:didBeginForUser:");
    self.loadingLabel.text = @"Authenticating.  Please wait.";
    [self showLoadingUI];
}

-(void)userAuthentication:(id)sender endedSuccessfullyForUser:(User*)user {
    NSLog(@"userAuthentication:endedSuccessfullyForUser:");
    self.loadingLabel.text = @"Authenticated.";
    [self.personInformation loadInformationForPerson:self.user.uid];
}

-(void)userAuthentication:(id)sender forUser:(User*)user endedWithError:(NSString*)error {
    NSLog(@"userAuthentication:forUser:endedWithError:");
    self.loadingLabel.text = @"Error authenticating.";
    [self showLoginUI];
    NSLog(@"Error:%@", error);
}

-(void)showLoadingUI {
    NSLog(@"showLoadingUI");

    self.usernameInput.enabled = NO;
    self.passwordInput.enabled = NO;
    self.signInButton.enabled = NO;
    self.signUpButton.enabled = NO;
    [self.loadingIndicator startAnimating];
    
    [UIView animateWithDuration:.25 animations:^{
        self.usernameInput.alpha = 0.0f;
        self.passwordInput.alpha = 0.0f;
        self.signInButton.alpha = 0.0f;
        self.signUpButton.alpha = 0.0f;
        self.loadingIndicator.alpha = 1.0f;
        self.loadingLabel.alpha = 1.0f;
    }];
}

-(void)showLoginUI {
    NSLog(@"Showing login ui");
    [self.loadingIndicator stopAnimating];
    
    [UIView animateWithDuration:.25 animations:^{
        self.usernameInput.alpha = 1.0f;
        self.passwordInput.alpha = 1.0f;
        self.signInButton.alpha = 1.0f;
        self.signUpButton.alpha = 1.0f;
        self.loadingIndicator.alpha = 0.0f;
        self.loadingLabel.alpha = 0.0f;
    } completion:^(BOOL finished) {
        self.usernameInput.enabled = YES;
        self.passwordInput.enabled = YES;
        self.signInButton.enabled = YES;
        self.signUpButton.enabled = YES;
    }];
}

-(IBAction)handleSignInClick:(id)sender
{
    [self submitInfoForAuthentication];
}

-(void)submitInfoForAuthentication {
    [self unfocusUsername];
    [self unfocusPassword];
    
    self.user.uid = self.usernameInput.text;
    [self.userAuthentication authenticateUser:self.user withPassword:self.passwordInput.text];
}

#pragma mark - UserInformationListener
-(void)personInformation:(id)sender didBeginLoadingForPersonUid:(NSString*)personUid {
    self.loadingLabel.text = @"Loading user information";
}

-(void)personInformation:(id)sender didEndLoadingSuccessfullyForPersonUid:(NSString*)personUid intoPerson:(Person*)person {
    [self showLoginUI];
    
    if (self.delegate) {
        [self.delegate authenticationViewControllerDidAuthenticateSuccessfully:self withUser:self.user andPerson:person];
    }
}

-(void)personInformation:(id)sender didEndLoadingForPersonUid:(NSString*)personUid withError:(NSString*)error {
    [self showLoginUI];
    
    if (self.delegate) {
        [self.delegate authenticationViewControllerDidAuthenticateSuccessfully:self withUser:self.user andPerson:nil];
    }
}

#pragma mark - Getters and setters
-(User*)user {
    if (!_user) {
        _user = [[User alloc] init];
        self.user.uid = @"541e065556602720c48baa6f";
    }
    
    return _user;
}

-(MockUserAuthentication*)userAuthentication {
    if (!_userAuthentication) {
        _userAuthentication = [[MockUserAuthentication alloc] init];
        [self.userAuthentication addUserAuthenticationListener:self];
    }
    
    return _userAuthentication;
}

-(MockPersonInformation*)personInformation {
    if (!_personInformation) {
        _personInformation = [[MockPersonInformation alloc] init];
        [self.personInformation addPersonInformationListener:self];
    }
    
    return _personInformation;
}

@end
