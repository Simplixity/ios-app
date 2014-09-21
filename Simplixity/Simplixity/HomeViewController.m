//
//  HomeViewController.m
//  Simplixity
//
//  Created by Donald Ritter on 9/21/14.
//  Copyright (c) 2014 Simplixity. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController ()
@property(nonatomic)IBOutlet UIImageView *logoImage;
@property(nonatomic)IBOutlet UILabel *welcomeLabel;
@property(nonatomic)IBOutlet UIButton *registrationButton;
@property(nonatomic)IBOutlet UIButton *editInformationButton;
@property(nonatomic)IBOutlet UIButton *findParticipantsButton;
@end

@implementation HomeViewController
@synthesize delegate = _delegate;
@synthesize logoImage = _logoImage;
@synthesize welcomeLabel = _welcomeLabel;
@synthesize registrationButton = _registrationButton;
@synthesize editInformationButton = _editInformationButton;
@synthesize findParticipantsButton = _findParticipantsButton;

#pragma mark - View Lifecycle
-(void)viewWillAppear:(BOOL)animated {
    if (self.person) {
        self.welcomeLabel.text = [NSString stringWithFormat:@"Welcome %@ %@", self.person.name.first, self.person.name.last];
    }
}

#pragma mark - Button Handlers
//  Handles when the new registration is clicked.
-(IBAction)handleNewRegistrationClick:(id)sender {
    if (self.delegate) {
        [self.delegate homeViewControllerNewRegistration:self];
    }
}
@end
