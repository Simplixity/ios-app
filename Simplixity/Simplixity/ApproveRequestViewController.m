//
//  ApproveRequestViewController.m
//  Simplixity
//
//  Created by Donald Ritter on 9/21/14.
//  Copyright (c) 2014 Simplixity. All rights reserved.
//

#import "ApproveRequestViewController.h"
#import "InformationResponse.h"

@interface ApproveRequestViewController ()
@property(nonatomic)IBOutlet UISwitch *personalSwitch;
@property(nonatomic)IBOutlet UISwitch *employerSwitch;
@property(nonatomic)IBOutlet UISwitch *guardianSwitch;
@property(nonatomic)IBOutlet UISwitch *motherSwitch;
@property(nonatomic)IBOutlet UISwitch *fatherSwitch;
@property(nonatomic)IBOutlet UISwitch *emergencySwitch;
@property(nonatomic)IBOutlet UISwitch *medicalInsuranceSwitch;
@property(nonatomic)IBOutlet UISwitch *dentalInsuranceSwitch;
@property(nonatomic)IBOutlet UISwitch *visionInsuranceSwitch;
@property(nonatomic)IBOutlet UISwitch *medicalConditionsSwitch;

@property(nonatomic)IBOutlet UIButton *completeRegistrationButton;
@end

@implementation ApproveRequestViewController
@synthesize request = _request;
@synthesize delegate = _delegate;
@synthesize personalSwitch = _personalSwitch;
@synthesize employerSwitch = _employerSwitch;
@synthesize guardianSwitch = _guardianSwitch;
@synthesize motherSwitch = _motherSwitch;
@synthesize fatherSwitch = _fatherSwitch;
@synthesize emergencySwitch = _emergencySwitch;
@synthesize medicalInsuranceSwitch = _medicalInsuranceSwitch;
@synthesize dentalInsuranceSwitch = _dentalInsuranceSwitch;
@synthesize visionInsuranceSwitch = _visionInsuranceSwitch;
@synthesize medicalConditionsSwitch = _medicalConditionsSwitch;

#pragma mark - View Lifecycle
-(void)viewWillAppear:(BOOL)animated {
    if (self.request) {
        self.personalSwitch.selected = self.request.personal;
        self.employerSwitch.selected = self.request.employer;
        self.guardianSwitch.selected = self.request.guardian;
        self.motherSwitch.selected = self.request.mother;
        self.fatherSwitch.selected = self.request.father;
        self.emergencySwitch.selected = self.request.emergency;
        self.medicalInsuranceSwitch.selected = self.request.medicalInsurancePolicies;
        self.dentalInsuranceSwitch.selected = self.request.dentalInsurancePolicies;
        self.visionInsuranceSwitch.selected = self.request.visionInsurancePolicies;
        self.medicalConditionsSwitch.selected = self.request.conditions;
    }
    
    
    [super viewWillAppear:animated];
}

#pragma mark - Button Handlers
-(IBAction)handleCompleteRegistrationClick:(id)sender {
    if (self.delegate) {
        InformationResponse *response = [[InformationResponse alloc] init];
        
        response.personal = self.personalSwitch.selected;
        response.employer = self.employerSwitch.selected;
        response.guardian = self.guardianSwitch.selected;
        response.mother = self.motherSwitch.selected;
        response.father = self.fatherSwitch.selected;
        response.emergency = self.emergencySwitch.selected;
        response.medicalInsurancePolicies = self.medicalInsuranceSwitch.selected;
        response.dentalInsurancePolicies = self.dentalInsuranceSwitch.selected;
        response.visionInsurancePolicies = self.visionInsuranceSwitch.selected;
        response.conditions = self.medicalConditionsSwitch.selected;
        
        [self.delegate approveRequestViewController:self didProvideResponse:response];
    }
}
@end
