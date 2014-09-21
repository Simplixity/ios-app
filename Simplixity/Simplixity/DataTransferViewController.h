//
//  InitiateHandshakeViewController.h
//  Simplixity
//
//  Created by Donald Ritter on 9/21/14.
//  Copyright (c) 2014 Simplixity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "InformationRequest.h"
#import "InformationResponse.h"

@class DataTransferViewController;
@protocol DataTransferViewControllerDelegate <NSObject>
-(void)dataTransferViewController:(DataTransferViewController*)controller forUser:(User*)user receivedRequest:(InformationRequest*)request;
-(void)dataTransferViewController:(DataTransferViewController*)controller forUser:(User*)user successfullySentResponse:(InformationResponse*)response;
-(void)dataTransferViewController:(DataTransferViewController*)controller requestResignForUser:(User*)user;
@end

//  Controller to initiate the handshake
@interface DataTransferViewController : UIViewController
@property(nonatomic)User *user;
@property(nonatomic)id<DataTransferViewControllerDelegate> delegate;

//  Sends the information response
-(void)sendResponse:(InformationResponse*)response;
@end
