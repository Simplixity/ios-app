//
//  InitiateHandshakeViewController.m
//  Simplixity
//
//  Created by Donald Ritter on 9/21/14.
//  Copyright (c) 2014 Simplixity. All rights reserved.
//

#import "DataTransferViewController.h"
#import "DataTransfer.h"
#import "MockDataTransfer.h"
#import "ApproveRequestViewController.h"

@interface DataTransferViewController () <UITextFieldDelegate, DataTransferListener>
@property(nonatomic)IBOutlet UIImageView *logoImage;
@property(nonatomic)IBOutlet UITextField *registrationCodeInput;
@property(nonatomic)IBOutlet UIButton *registerButton;
@property(nonatomic)IBOutlet UIActivityIndicatorView *loadingIndicator;
@property(nonatomic)IBOutlet UILabel *loadingLabel;
@property(nonatomic)IBOutlet UIImageView *successImage;

//  DataTransfer used to communicate with the server.
@property(nonatomic)id<DataTransfer> dataTransfer;
@property(nonatomic)BOOL shouldReset;
@end

@implementation DataTransferViewController
@synthesize user = _user;
@synthesize logoImage = _logoImage;
@synthesize registrationCodeInput = _registrationCodeInput;
@synthesize registerButton = _registerButton;
@synthesize loadingIndicator = _loadingIndicator;
@synthesize loadingLabel = _loadingLabel;
@synthesize delegate = _delegate;
@synthesize successImage = _successImage;

#pragma mark - View lifecycle
-(void)viewWillAppear:(BOOL)animated {
    if (self.shouldReset) {
        [self.loadingIndicator stopAnimating];
        self.loadingIndicator.alpha = 0.0f;
        self.loadingIndicator.hidden = YES;
        
        self.loadingLabel.hidden = YES;
        self.loadingLabel.alpha = 0.0f;
        
        self.successImage.hidden = YES;
        self.successImage.alpha = 0.0f;
    }
    
    [super viewWillAppear:animated];
}

-(void)viewDidAppear:(BOOL)animated {
    if (self.shouldReset) {
        self.shouldReset = NO;
        
        self.registrationCodeInput.hidden = NO;
        self.registrationCodeInput.alpha = 1.0f;
        
        self.registerButton.hidden = NO;
        self.registerButton.alpha = 1.0f;
    }
    
    [super viewDidAppear:animated];
}

#pragma mark - Show and hide UI controls
-(void)showLoadingUI {
    self.loadingLabel.hidden = NO;
    self.loadingIndicator.hidden = NO;
    [self.loadingIndicator startAnimating];
    [self.registrationCodeInput resignFirstResponder];
    
    [UIView animateWithDuration:0.25f animations:^{
        self.loadingLabel.alpha = 1.0f;
        self.loadingIndicator.alpha = 1.0f;
        
        self.registrationCodeInput.alpha = 0.0f;
        self.registerButton.alpha = 0.0f;
    } completion:^(BOOL finished) {
        self.registrationCodeInput.hidden = YES;
        self.registerButton.hidden = YES;
    }];
}

-(void)showRegistrationUI {
    self.registerButton.hidden = NO;
    self.registrationCodeInput.hidden = NO;
    [self.loadingIndicator stopAnimating];
    
    [UIView animateWithDuration:0.25f animations:^{
        self.loadingLabel.alpha = 0.0f;
        self.loadingIndicator.alpha = 0.0f;
        
        self.registrationCodeInput.alpha = 1.0f;
        self.registerButton.alpha = 1.0f;
    } completion:^(BOOL finished) {
        self.loadingLabel.hidden = YES;
        self.loadingIndicator.hidden = YES;
    }];
}

//  Starts the registration process
-(void)startRegistration {
    [self unfocusRegistrationCode];
    [self.dataTransfer initiateTransferForUser:self.user toTargetId:self.registrationCodeInput.text];
}

#pragma mark - Button handlers
-(IBAction)handleRegistrationClick:(id)sender {
    [self startRegistration];
}

#pragma mark - UITextFieldDelegate
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *) event
{
    UITouch *touch = [[event allTouches] anyObject];
    if ([self.registrationCodeInput isFirstResponder] && (self.registrationCodeInput != touch.view))
    {
        [self unfocusRegistrationCode];
    }
}

-(void)focusRegistrationCode {
    [UIView animateWithDuration:0.25 animations:^{
        self.registrationCodeInput.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1.0f];
    }];
}

-(void)unfocusRegistrationCode {
    [self.registrationCodeInput resignFirstResponder];
    
    [UIView animateWithDuration:0.25 animations:^{
        self.registrationCodeInput.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:.25f];
    }];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField == self.registrationCodeInput) {
        [self focusRegistrationCode];
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == self.registrationCodeInput) {
        [self unfocusRegistrationCode];
    }
}

#pragma mark - Overall Transfer
//  The overall data transfer process has begun.
-(void)dataTransfer:(id)sender didBeginForUser:(User*)user withTargetId:(NSString*)targetId {
    NSLog(@"dataTransfer:didBeginForUser:withTargetId:");
    [self showLoadingUI];
}

//  The overall data transfer was successful.
-(void)dataTransfer:(id)sender didEndSuccessfullyForUser:(User*)user withTargetId:(NSString*)targetId {
    NSLog(@"dataTransfer:didEndSuccessfullyForUser:withTargetId:");
    //[self showRegistrationUI];
}

//  The overall data transfer failed with the error.
-(void)dataTransfer:(id)sender didEndForUser:(User*)user withTargetId:(NSString*)targetId andError:(NSString*)error {
    NSLog(@"dataTransfer:didEndForUser:withTargetId:andError:");
    //[self showRegistrationUI];
}


#pragma mark - Handshake
-(void)dataTransfer:(id)sender handshakeDidBeginForUser:(User*)user withTargetId:(NSString*)targetId {
    NSLog(@"dataTransfer:handshakeDidBeginForUser:withTargetId:");
    self.loadingLabel.text = @"Contacting registration server";
}

-(void)dataTransfer:(id)sender handshakeDidEndSuccessfullyForUser:(User*)user withTargetId:(NSString*)targetId {
    self.loadingLabel.text = @"Registration server contacted";
}

-(void)dataTransfer:(id)sender handshakeDidEndForUser:(User*)user withTargetId:(NSString*)targetId andError:(NSString*)error {
    self.loadingLabel.text = @"Error contacting registration server";
}


#pragma mark - Receiving Data Request
-(void)dataTransfer:(id)sender forUser:(User*)user isWaitingForRequestFromTargetId:(NSString*)targetId {
    NSLog(@"dataTransfer:forUser:isWaitingForRequestFromTargetId:");
    
    self.loadingLabel.text = @"Waiting for information request";
}

-(void)dataTransfer:(id)sender forUser:(User*)user receivedRequest:(InformationRequest*)request fromTargetId:(NSString*)targetId {
    NSLog(@"dataTransfer:forUser:receivedRequest:fromTargetId:");
    self.loadingLabel.text = @"Received information request";
    
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(dataTransferViewController:forUser:receivedRequest:)]) {
            [self.delegate dataTransferViewController:self forUser:self.user receivedRequest:request];
        }
    }
}

-(void)dataTransfer:(id)sender forUser:(User*)user requestFailedFromTargetId:(NSString*)targetId withError:(NSString*)error {
    NSLog(@"dataTransfer:forUser:requestFailedFromTargetId:withError:");
    self.loadingLabel.text = @"Error waiting for information request";
}


#pragma mark - Sending Data Response
-(void)dataTransfer:(id)sender forUser:(User*)user isSendingResponse:(InformationResponse*)response toTargetId:(NSString*)targetId {
    NSLog(@"dataTransfer:forUser:isSendingResponse:toTargetId:");
    self.loadingLabel.text = @"Sending information response";
}

-(void)dataTransfer:(id)sender forUser:(User*)user acceptedResponse:(InformationResponse*)response withTargetId:(NSString*)targetId {
    NSLog(@"dataTransfer:forUser:acceptedResponse:withTargetId:");
    self.loadingLabel.text = @"Registration Complete";
    [self.loadingIndicator stopAnimating];
    self.successImage.hidden = NO;
    self.successImage.alpha = 0.0f;
    
    [UIView animateWithDuration:.25 animations:^{
        self.loadingIndicator.alpha = 0.0f;
        self.successImage.alpha = 1.0f;
    }];
    
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(dataTransferViewController:forUser:successfullySentResponse:)]) {
            [self.delegate dataTransferViewController:self forUser:self.user successfullySentResponse:response];
        }
    }
    
    [self performSelector:@selector(dismissAfterDelay) withObject:nil afterDelay:10];
}

-(void)dismissAfterDelay {
    if ([self.delegate respondsToSelector:@selector(dataTransferViewController:requestResignForUser:)]) {
        [self.delegate dataTransferViewController:self requestResignForUser:self.user];
    }
}

-(void)dataTransfer:(id)sender forUser:(User*)user failedWithError:(NSString*)error forTargetId:(NSString*)targetId andResponse:(InformationResponse*)response {
    NSLog(@"dataTransfer:forUser:receivedRequest:fromTargetId:");
    self.loadingLabel.text = @"Received information request";
}

-(void)sendResponse:(InformationResponse*)response {
    [self.dataTransfer sendResponse:response];
}

#pragma mark - Getters and setters
-(id<DataTransfer>)dataTransfer {
    if (!_dataTransfer) {
        _dataTransfer = [[MockDataTransfer alloc] init];
        [self.dataTransfer addDataTransferListener:self];
    }
    
    return _dataTransfer;
}

-(void)setUser:(User *)user {
    _user = user;
    self.shouldReset = YES;
}
@end
