//
//  MockDataTransfer.m
//  Simplixity
//
//  Created by Donald Ritter on 9/20/14.
//  Copyright (c) 2014 Simplixity. All rights reserved.
//

#import "MockDataTransfer.h"
#import "NSMutableURLRequest+EasyParams.h"

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

//  Root of the servers.
@property(nonatomic)NSString *serverRoot;
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
        __block long i = 0;
        
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
        
        NSDictionary *jsonParams = @{@"username" : self.user.uid, @"target_system_id" : self.targetId};
        NSMutableURLRequest *request = [NSMutableURLRequest urlWithString:[NSString stringWithFormat:@"%@/handshake", self.serverRoot] andMethod:@"POST" andJSON:jsonParams];
        [request setTimeoutInterval:5];
        
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
            @try {
                self.isHandshaking = NO;
                
                BOOL success = NO;
                NSString *errorMessage;
                
                if (!error) {
                    NSString *responseData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                    NSLog(@"Response:%@", responseData);
                }
                
                if (error) {
                    errorMessage = [error helpAnchor];
                    NSLog(@"Error:%@", errorMessage);
                }
                else {
                    NSError *jsonError;
                    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
                    
                    if (jsonError) {
                        errorMessage = [jsonError helpAnchor];
                    }
                    else {
                        NSNumber *acknowledgement = [json objectForKey:@"acknowledgement"];
                        if ([acknowledgement boolValue]) {
                            NSLog(@"Initiated Successfully");
                            success = YES;
                        }
                    }
                }
                
                if (success) {
                    for (i = [self.dataTransferListeners count] - 1; i >= 0; i--) {
                        listener = [self.dataTransferListeners objectAtIndex:i];
                        
                        if ([listener respondsToSelector:@selector(dataTransfer:handshakeDidEndSuccessfullyForUser:withTargetId:)]) {
                            [listener dataTransfer:self handshakeDidEndSuccessfullyForUser:self.user withTargetId:self.targetId];
                        }
                    }
                    
                    [self initiateWaitingForRequest];
                }
                else {
                    for (i = [self.dataTransferListeners count] - 1; i >= 0; i--) {
                        listener = [self.dataTransferListeners objectAtIndex:i];
                        
                        if ([listener respondsToSelector:@selector(dataTransfer:handshakeDidEndForUser:withTargetId:andError:)]) {
                            [listener dataTransfer:self handshakeDidEndForUser:self.user withTargetId:self.targetId andError:errorMessage];
                        }
                    }
                    
                    self.isTransfering = NO;
                    
                    for (i = [self.dataTransferListeners count] - 1; i >= 0; i--) {
                        listener = [self.dataTransferListeners objectAtIndex:i];
                        
                        if ([listener respondsToSelector:@selector(dataTransfer:didEndForUser:withTargetId:andError:)]) {
                            [listener dataTransfer:self didEndForUser:self.user withTargetId:self.targetId andError:errorMessage];
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
        long i = 0;
        
        NSLog(@"Initiating request");
        
        for (i = [self.dataTransferListeners count] - 1; i >= 0; i--) {
            listener = [self.dataTransferListeners objectAtIndex:i];

            if ([listener respondsToSelector:@selector(dataTransfer:forUser:isWaitingForRequestFromTargetId:)]) {
                [listener dataTransfer:self forUser:self.user isWaitingForRequestFromTargetId:self.targetId];
            }
        }
        
        NSLog(@"Called listener");
        
        [self pollForRequest];
    }
}

//  Actually performs the polling for the request.
-(void)pollForRequest {
    if (!self.isPollRequestRunning) {
        self.isPollRequestRunning = YES;
        self.pollRequestCount++;
        
        __block id<DataTransferListener> listener;
        __block long i = 0;
        
        NSDictionary *jsonParams = @{@"username" : self.user.uid, @"target_system_id" : self.targetId};
        NSMutableURLRequest *request = [NSMutableURLRequest urlWithString:[NSString stringWithFormat:@"%@/poll", self.serverRoot] andMethod:@"POST" andJSON:jsonParams];
        [request setTimeoutInterval:30];
        
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
            NSLog(@"Poll Request Complete:%@", error);
            self.isPollRequestRunning = NO;
            
            InformationRequest *informationRequest;
            NSString *errorMessage;
            
            if (!error) {
                NSString *responseData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                NSLog(@"Response:%@", responseData);
            }
            
            if (error) {
                errorMessage = [error helpAnchor];
            }
            else {
                NSError *jsonError;
                NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
                
                if (jsonError) {
                    errorMessage = [jsonError helpAnchor];
                }
                else {
                    informationRequest = [[InformationRequest alloc] init];
                    informationRequest.personal = [jsonArray containsObject:@"Personal"];
                    informationRequest.employer = [jsonArray containsObject:@"Employer"];
                    informationRequest.mother = [jsonArray containsObject:@"Mother"];
                    informationRequest.father = [jsonArray containsObject:@"Father"];
                    informationRequest.emergency = [jsonArray containsObject:@"Emergency"];
                    informationRequest.guardian = [jsonArray containsObject:@"Guardian"];
                    informationRequest.medicalInsurancePolicies = [jsonArray containsObject:@"Medical Insurance"];
                    informationRequest.dentalInsurancePolicies = [jsonArray containsObject:@"Dental Insurance"];
                    informationRequest.visionInsurancePolicies = [jsonArray containsObject:@"Vision Insurance"];
                    informationRequest.lifeInsurancePolicies = [jsonArray containsObject:@"Life Insurance"];
                    informationRequest.conditions = [jsonArray containsObject:@"Medical Conditions"];
                }
            }
            
            self.pollRequestStart = [NSDate date];
            
            if (informationRequest) {
                [self requestRecieved:informationRequest];
            }
            else if (self.pollRequestCount > 5) {
                self.isWaitingForRequest = NO;
                
                for (i = [self.dataTransferListeners count] - 1; i >= 0; i--) {
                    listener = [self.dataTransferListeners objectAtIndex:i];
                    
                    if ([listener respondsToSelector:@selector(dataTransfer:forUser:requestFailedFromTargetId:withError:)]) {
                        [listener dataTransfer:self forUser:self.user requestFailedFromTargetId:self.targetId withError:@"Polled too many times for request"];
                    }
                }
                
                self.isTransfering = NO;
                
                for (i = [self.dataTransferListeners count] - 1; i >= 0; i--) {
                    listener = [self.dataTransferListeners objectAtIndex:i];
                    
                    if ([listener respondsToSelector:@selector(dataTransfer:didEndForUser:withTargetId:andError:)]) {
                        [listener dataTransfer:self didEndForUser:self.user withTargetId:self.targetId andError:@"Polled too many times for request"];
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
        long i = 0;
        
        for (i = [self.dataTransferListeners count] - 1; i >= 0; i--) {
            listener = [self.dataTransferListeners objectAtIndex:i];
            
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
        __block long i = 0;
        
        for (i = [self.dataTransferListeners count] - 1; i >= 0; i--) {
            listener = [self.dataTransferListeners objectAtIndex:i];
            
            if ([listener respondsToSelector:@selector(dataTransfer:forUser:isSendingResponse:toTargetId:)]) {
                [listener dataTransfer:self forUser:self.user isSendingResponse:informationResponse toTargetId:self.targetId];
            }
        }
        
        NSMutableArray *informationToShow = [[NSMutableArray alloc] init];
        
        NSDictionary *jsonParams = @{@"username" : self.user.uid,
                                     @"target_system_id" : self.targetId,
                                     @"information_to_show" : informationToShow};
        
        if (informationResponse) {
            if (informationResponse.personal) {
                [informationToShow addObject:@"Personal"];
            }
            
            if (informationResponse.employer) {
                [informationToShow addObject:@"Employer"];
            }
            
            if (informationResponse.mother) {
                [informationToShow addObject:@"Mother"];
            }
            
            if (informationResponse.father) {
                [informationToShow addObject:@"Father"];
            }
            
            if (informationResponse.guardian) {
                [informationToShow addObject:@"Guardian"];
            }
            
            if (informationResponse.emergency) {
                [informationToShow addObject:@"Emergency"];
            }
            
            if (informationResponse.medicalInsurancePolicies) {
                [informationToShow addObject:@"Medical Insurance"];
            }
            
            if (informationResponse.dentalInsurancePolicies) {
                [informationToShow addObject:@"Dental Insurance"];
            }
            
            if (informationResponse.lifeInsurancePolicies) {
                [informationToShow addObject:@"Life Insurance"];
            }
            
            if (informationResponse.visionInsurancePolicies) {
                [informationToShow addObject:@"Vision Insurance"];
            }
            
            if (informationResponse.conditions) {
                [informationToShow addObject:@"Medical Conditions"];
            }
        }
        
        NSMutableURLRequest *request = [NSMutableURLRequest urlWithString:[NSString stringWithFormat:@"%@/response", self.serverRoot] andMethod:@"POST" andJSON:jsonParams];
        [request setTimeoutInterval:30];

        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
            @try {
                self.isSendingResponse = NO;
                
                BOOL success = NO;
                NSString *errorMessage;
                
                if (!error) {
                    NSString *responseData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                    NSLog(@"Response:%@", responseData);
                }
                
                if (error) {
                    errorMessage = [error helpAnchor];
                }
                else {
                    NSError *jsonError;
                    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
                    
                    if (jsonError) {
                        errorMessage = [jsonError helpAnchor];
                    }
                    else {
                        NSString *status = [json objectForKey:@"status"];
                        
                        if ([status isEqualToString:@"Success"]) {
                            success = YES;
                        }
                    }
                }

                if (success) {
                    for (i = [self.dataTransferListeners count] - 1; i >= 0; i--) {
                        listener = [self.dataTransferListeners objectAtIndex:i];
                        
                        if ([listener respondsToSelector:@selector(dataTransfer:forUser:acceptedResponse:withTargetId:)]) {
                            [listener dataTransfer:self forUser:self.user acceptedResponse:informationResponse withTargetId:self.targetId];
                        }
                    }
                    
                    self.isTransfering = NO;
                    
                    for (i = [self.dataTransferListeners count] - 1; i >= 0; i--) {
                        listener = [self.dataTransferListeners objectAtIndex:i];
                        
                        if ([listener respondsToSelector:@selector(dataTransfer:didEndSuccessfullyForUser:withTargetId:)]) {
                            [listener dataTransfer:self didEndSuccessfullyForUser:self.user withTargetId:self.targetId];
                        }
                    }
                }
                else {
                    for (i = [self.dataTransferListeners count] - 1; i >= 0; i--) {
                        listener = [self.dataTransferListeners objectAtIndex:i];
                        
                        if ([listener respondsToSelector:@selector(dataTransfer:forUser:failedWithError:forTargetId:andResponse:)]) {
                            [listener dataTransfer:self forUser:self.user failedWithError:errorMessage forTargetId:self.targetId andResponse:informationResponse];
                        }
                    }
                    
                    self.isTransfering = NO;
                    
                    for (i = [self.dataTransferListeners count] - 1; i >= 0; i--) {
                        listener = [self.dataTransferListeners objectAtIndex:i];
                        
                        if ([listener respondsToSelector:@selector(dataTransfer:didEndForUser:withTargetId:andError:)]) {
                            [listener dataTransfer:self didEndForUser:self.user withTargetId:self.targetId andError:errorMessage];
                        }
                    }
                }
            }
            @catch (NSException *parseError) {
                self.isSendingResponse = NO;
                
                for (i = [self.dataTransferListeners count] - 1; i >= 0; i--) {
                    listener = [self.dataTransferListeners objectAtIndex:i];
                    
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

-(NSString*)serverRoot {
    if (!_serverRoot) {
        _serverRoot = @"http://104.131.15.123:8080";
    }
    
    return _serverRoot;
}
@end
