//
//  MockDataTransfer.m
//  Simplixity
//
//  Created by Donald Ritter on 9/20/14.
//  Copyright (c) 2014 Simplixity. All rights reserved.
//

#import "MockDataTransfer.h"

@interface MockDataTransfer()
@property(nonatomic)User *user;
@property(nonatomic)NSString *targetId;
@property(nonatomic)NSMutableArray *dataTransferListeners;
@property(nonatomic)BOOL isTransfering;
@property(nonatomic)BOOL isHandshaking;
@property(nonatomic)BOOL isWaitingForRequest;
@property(nonatomic)BOOL isWaitingToSendResponse;
@property(nonatomic)BOOL isSendingResponse;

//  Number of times we have polled.
@property(nonatomic)NSUInteger pollRequestCount;

//  Last time a poll request started.
@property(nonatomic)NSDate *pollRequestStart;

//  Whether a poll request is currently running.
@property(nonatomic)BOOL isPollRequestRunning;
@end

@implementation MockDataTransfer
@synthesize user= _user;
@synthesize targetId = _targetId;
@synthesize dataTransferListeners = _dataTransferListeners;
@synthesize isTransfering = _isTransfering;
@synthesize isHandshaking = _isHandshaking;
@synthesize isWaitingForRequest = _isWaitingForRequest;
@synthesize isWaitingToSendResponse = _isWaitingToSendResponse;
@synthesize isSendingResponse = _isSendingResponse;
@synthesize pollRequestCount = _pollRequestCount;
@synthesize pollRequestStart = _pollRequestStart;

#pragma mark - Handshake
-(void)initiateTransferForUser:(User*)user toTargetId:(NSString*)targetId
{
    if (!self.isTransfering) {
        self.isTransfering = YES;
        self.isHandshaking = YES;
        self.user = user;
        self.targetId = targetId;
        
        __block id<DataTransferListener> listener;
        __block int i = 0;
        
        for (i = [self.dataTransferListeners count] - 1; i >= 0; i--) {
            listener = [self.dataTransferListeners objectAtIndex:i];
            
            if ([listener respondsToSelector:@selector(dataTransfer:didBeginForUser:withTargetId:)]) {
                [listener dataTransfer:self didBeginForUser:self.user withTargetId:self.targetId];
            }
        }
        
        for (i = [self.dataTransferListeners count] - 1; i >= 0; i--) {
            listener = [self.dataTransferListeners objectAtIndex:i];
            
            if ([listener respondsToSelector:@selector(dataTransfer:handshakeDidBeginForUser:withTargetId:)]) {
                [listener dataTransfer:self handshakeDidBeginForUser:self.user withTargetId:self.targetId];
            }
        }
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        
        [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
            @try {
                BOOL success = NO;
                self.isHandshaking = NO;
                
                if (error) {
                    
                }
                else {
                    //TODO parse data
                }
                
                if (success) {
                    for (i = [self.dataTransferListeners count] - 1; i >= 0; i--) {
                        listener = [self.dataTransferListeners objectAtIndex:i];
                        
                        if ([listener respondsToSelector:@selector(dataTransfer:handshakeDidEndSuccessfullyForUser:withTargetId:)]) {
                            [listener dataTransfer:self handshakeDidEndSuccessfullyForUser:self.user withTargetId:self.targetId];
                        }
                    }
                }
                else {
                    for (i = [self.dataTransferListeners count] - 1; i >= 0; i--) {
                        listener = [self.dataTransferListeners objectAtIndex:i];
                        
                        if ([listener respondsToSelector:@selector(dataTransfer:handshakeDidEndForUser:withTargetId:andError:)]) {
                            [listener dataTransfer:self handshakeDidEndForUser:self.user withTargetId:self.targetId andError:@"error"];
                        }
                    }
                    
                    self.isTransfering = NO;
                    
                    for (i = [self.dataTransferListeners count] - 1; i >= 0; i--) {
                        listener = [self.dataTransferListeners objectAtIndex:i];
                        
                        if ([listener respondsToSelector:@selector(dataTransfer:didEndForUser:withTargetId:andError:)]) {
                            [listener dataTransfer:self didEndForUser:self.user withTargetId:self.targetId andError:@"error"];
                        }
                    }
                }
            }
            @catch (NSException *parseError) {
                self.isHandshaking = NO;
                
                for (i = [self.dataTransferListeners count] - 1; i >= 0; i--) {
                    listener = [self.dataTransferListeners objectAtIndex:i];
                    
                    if ([listener respondsToSelector:@selector(dataTransfer:handshakeDidEndForUser:withTargetId:andError:)]) {
                        [listener dataTransfer:self handshakeDidEndForUser:self.user withTargetId:self.targetId andError:[parseError reason]];
                    }
                }
                
                self.isTransfering = NO;
                
                for (i = [self.dataTransferListeners count] - 1; i >= 0; i--) {
                    listener = [self.dataTransferListeners objectAtIndex:i];
                    
                    if ([listener respondsToSelector:@selector(dataTransfer:didEndForUser:withTargetId:andError:)]) {
                        [listener dataTransfer:self didEndForUser:self.user withTargetId:self.targetId andError:[parseError reason]];
                    }
                }
            }
        }];
    }
}

#pragma mark - Receiving Data Request
//  Calls listeners and the initial polling call to see if the request has come in and is available on the server.
-(void)initiateWaitingForRequest {
    if (self.isTransfering && !self.isHandshaking && !self.isWaitingForRequest && !self.isWaitingToSendResponse && !self.isSendingResponse) {
        self.isWaitingForRequest = YES;
        self.pollRequestCount = 0;
        
        id<DataTransferListener> listener;
        int i = 0;
        
        for (i = [self.dataTransferListeners count] - 1; i >= 0; i--) {
            if ([listener respondsToSelector:@selector(dataTransfer:forUser:isWaitingForRequestfromTargetId:)]) {
                [listener dataTransfer:self forUser:self.user isWaitingForRequestfromTargetId:self.targetId];
            }
        }
    }
}

//  Actually performs the polling for the request.
-(void)pollForRequest {
    if (!self.isPollRequestRunning) {
        self.isPollRequestRunning = YES;
        self.pollRequestCount++;
        
        __block id<DataTransferListener> listener;
        __block int i = 0;
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        
        [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
            InformationRequest *informationRequest = nil;
            NSString *errorMessage = @"";
            
            if (!error) {
                @try {
                    //TODO parse response
                }
                @catch (NSException *pollError) {
                    errorMessage = [pollError reason];
                }
            }
            
            self.isPollRequestRunning = NO;
            self.pollRequestStart = [NSDate date];
            
            if (informationRequest) {
                [self requestRecieved:informationRequest];
            }
            else if (self.pollRequestCount > 5) {
                self.isWaitingForRequest = NO;
                
                for (i = [self.dataTransferListeners count] - 1; i >= 0; i--) {
                    if ([listener respondsToSelector:@selector(dataTransfer:forUser:requestFailedFromTargetId:withError:)]) {
                        [listener dataTransfer:self forUser:self.user requestFailedFromTargetId:self.targetId withError:@"polled too many times for request"];
                    }
                }
                
                self.isTransfering = NO;
                
                for (i = [self.dataTransferListeners count] - 1; i >= 0; i--) {
                    listener = [self.dataTransferListeners objectAtIndex:i];
                    
                    if ([listener respondsToSelector:@selector(dataTransfer:didEndForUser:withTargetId:andError:)]) {
                        [listener dataTransfer:self didEndForUser:self.user withTargetId:self.targetId andError:@"polled too many times for request"];
                    }
                }
            }
            else {
                [self performSelector:@selector(pollForRequest) withObject:nil afterDelay:5];
            }
        }];
    }
}

//  Called when the request has been recieved.
-(void)requestRecieved:(InformationRequest*)informationRequest {
    if (self.isTransfering && !self.isHandshaking && self.isWaitingForRequest && !self.isWaitingToSendResponse && !self.isSendingResponse) {
        self.isWaitingForRequest = NO;
        self.isWaitingToSendResponse = YES;
        
        id<DataTransferListener> listener;
        int i = 0;
        
        for (i = [self.dataTransferListeners count] - 1; i >= 0; i--) {
            if ([listener respondsToSelector:@selector(dataTransfer:forUser:receivedRequest:fromTargetId:)]) {
                [listener dataTransfer:self forUser:self.user receivedRequest:informationRequest fromTargetId:self.targetId];
            }
        }
    }
}

#pragma mark - Sending Data Response
-(void)sendResponse:(InformationResponse*)informationResponse {
    if (self.isTransfering && !self.isHandshaking && !self.isWaitingForRequest && self.isWaitingToSendResponse && !self.isSendingResponse) {
        self.isWaitingForRequest = NO;
        self.isSendingResponse = YES;
        
        __block id<DataTransferListener> listener;
        __block int i = 0;
        
        for (i = [self.dataTransferListeners count] - 1; i >= 0; i--) {
            if ([listener respondsToSelector:@selector(dataTransfer:forUser:isSendingResponse:toTargetId:)]) {
                [listener dataTransfer:self forUser:self.user isSendingResponse:informationResponse toTargetId:self.targetId];
            }
        }
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        
        [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
            @try {
                BOOL success = NO;
                //TODO parse
                if (success) {
                    
                }
                else {
                    self.isSendingResponse = NO;
                    
                    for (i = [self.dataTransferListeners count] - 1; i >= 0; i--) {
                        if ([listener respondsToSelector:@selector(dataTransfer:forUser:failedWithError:forTargetId:andResponse:)]) {
                            [listener dataTransfer:self forUser:self.user failedWithError:@"some rejection" forTargetId:self.targetId andResponse:informationResponse];
                        }
                    }
                    
                    self.isTransfering = NO;
                    
                    for (i = [self.dataTransferListeners count] - 1; i >= 0; i--) {
                        listener = [self.dataTransferListeners objectAtIndex:i];
                        
                        if ([listener respondsToSelector:@selector(dataTransfer:didEndForUser:withTargetId:andError:)]) {
                            [listener dataTransfer:self didEndForUser:self.user withTargetId:self.targetId andError:@"some rejection"];
                        }
                    }
                }
            }
            @catch (NSException *parseError) {
                self.isSendingResponse = NO;
                
                for (i = [self.dataTransferListeners count] - 1; i >= 0; i--) {
                    if ([listener respondsToSelector:@selector(dataTransfer:forUser:failedWithError:forTargetId:andResponse:)]) {
                        [listener dataTransfer:self forUser:self.user failedWithError:[parseError reason] forTargetId:self.targetId andResponse:informationResponse];
                    }
                }
                
                self.isTransfering = NO;
                
                for (i = [self.dataTransferListeners count] - 1; i >= 0; i--) {
                    listener = [self.dataTransferListeners objectAtIndex:i];
                    
                    if ([listener respondsToSelector:@selector(dataTransfer:didEndForUser:withTargetId:andError:)]) {
                        [listener dataTransfer:self didEndForUser:self.user withTargetId:self.targetId andError:[parseError reason]];
                    }
                }
            }
        }];
    }
}

#pragma mark - Listeners
-(void)addDataTransferListener:(id<DataTransferListener>)listener {
    if (![self.dataTransferListeners containsObject:listener]) {
        [self.dataTransferListeners addObject:listener];
    }
}

-(void)removeDataTransferListener:(id<DataTransferListener>)listener {
    if ([self.dataTransferListeners containsObject:listener]) {
        [self.dataTransferListeners removeObject:listener];
    }
}

#pragma mark - Getters and Setters
-(NSMutableArray*)dataTransferListeners {
    if (!_dataTransferListeners) {
        _dataTransferListeners = [[NSMutableArray alloc] init];
    }
    
    return _dataTransferListeners;
}
@end
