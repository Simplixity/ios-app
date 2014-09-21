//
//  DataTransfer.h
//  Simplixity
//
//  Created by Donald Ritter on 9/20/14.
//  Copyright (c) 2014 Simplixity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
#import "InformationRequest.h"
#import "InformationResponse.h"

//  Defines the listeners for the transfer.
@protocol DataTransferListener <NSObject>
@optional
#pragma mark - Overall Transfer
//  The overall data transfer process has begun.
-(void)dataTransfer:(id)sender didBeginForUser:(User*)user withTargetId:(NSString*)targetId;

//  The overall data transfer was successful.
-(void)dataTransfer:(id)sender didEndSuccessfullyForUser:(User*)user withTargetId:(NSString*)targetId;

//  The overall data transfer failed with the error.
-(void)dataTransfer:(id)sender didEndForUser:(User*)user withTargetId:(NSString*)targetId andError:(NSString*)error;


#pragma mark - Handshake
//  The handshake has started.
-(void)dataTransfer:(id)sender handshakeDidBeginForUser:(User*)user withTargetId:(NSString*)targetId;

//  The handshake completed successfully.  The transfer is now waiting for the request with what is wanted.
-(void)dataTransfer:(id)sender handshakeDidEndSuccessfullyForUser:(User*)user withTargetId:(NSString*)targetId;

//  The handshake ended but was not successful.  The transfer is considered failed from this point.
-(void)dataTransfer:(id)sender handshakeDidEndForUser:(User*)user withTargetId:(NSString*)targetId andError:(NSString*)error;


#pragma mark - Receiving Data Request
//  We are waiting for the data request to come in.
-(void)dataTransfer:(id)sender forUser:(User*)user isWaitingForRequestFromTargetId:(NSString*)targetId;

//  The request with what type of information to provide has been received.
-(void)dataTransfer:(id)sender forUser:(User*)user receivedRequest:(InformationRequest*)request fromTargetId:(NSString*)targetId;

//  The request from the target failed.
-(void)dataTransfer:(id)sender forUser:(User*)user requestFailedFromTargetId:(NSString*)targetId withError:(NSString*)error;


#pragma mark - Sending Data Response
//  We are sending our response.
-(void)dataTransfer:(id)sender forUser:(User*)user isSendingResponse:(InformationResponse*)response toTargetId:(NSString*)targetId;

//  The server accepted the response with what to provide.
-(void)dataTransfer:(id)sender forUser:(User*)user acceptedResponse:(InformationResponse*)response withTargetId:(NSString*)targetId;

//  Sending the response to the server failed or was rejected.
-(void)dataTransfer:(id)sender forUser:(User*)user failedWithError:(NSString*)error forTargetId:(NSString*)targetId andResponse:(InformationResponse*)response;
@end


//  Defines the data transfer steps.
@protocol DataTransfer <NSObject>
//  Whether the transfer process is running.  The transfer process is the handshake, request, and then response.
@property(nonatomic, readonly)BOOL isTransfering;

//  Whether the transfer is currently handshaking.
@property(nonatomic, readonly)BOOL isHandshaking;

//  Whether it is waiting for the request.
@property(nonatomic, readonly)BOOL isWaitingForRequest;

//  Whether it is waiting to send the response.
@property(nonatomic, readonly)BOOL isWaitingToSendResponse;

//  Whether it is sending the response.
@property(nonatomic, readonly)BOOL isSendingResponse;

//  Initiates the transfer handshake between the user and the target.
-(void)initiateTransferForUser:(User*)user toTargetId:(NSString*)targetId;

//  Sends the response of what information to share with the target.
-(void)sendResponse:(InformationResponse*)response;

//  Adds a listener to the data transfer.
-(void)addDataTransferListener:(id<DataTransferListener>)listener;

//  Removes a listener to the data transfer.
-(void)removeDataTransferListener:(id<DataTransferListener>)listener;
@end
