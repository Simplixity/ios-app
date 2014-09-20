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
@property(nonatomic)BOOL isSendingResponse;
@end

@implementation MockDataTransfer
@synthesize user= _user;
@synthesize targetId = _targetId;
@synthesize dataTransferListeners = _dataTransferListeners;
@synthesize isTransfering = _isTransfering;
@synthesize isHandshaking = _isHandshaking;
@synthesize isWaitingForRequest = _isWaitingForRequest;
@synthesize isSendingResponse = _isSendingResponse;

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
                
                //TODO parse data
                
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

#pragma mark - Receive Data Request

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
