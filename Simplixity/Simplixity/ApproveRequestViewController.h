//
//  ApproveRequestViewController.h
//  Simplixity
//
//  Created by Donald Ritter on 9/21/14.
//  Copyright (c) 2014 Simplixity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InformationRequest.h"
#import "InformationResponse.h"

@class ApproveRequestViewController;

@protocol ApproveRequestViewControllerDelegate <NSObject>
-(void)approveRequestViewController:(ApproveRequestViewController*)controller didProvideResponse:(InformationResponse*)response;
@end

@interface ApproveRequestViewController : UIViewController
@property(nonatomic)InformationRequest *request;
@property(nonatomic)id<ApproveRequestViewControllerDelegate> delegate;
@end
