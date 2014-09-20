//
//  MockUserAuthentication.m
//  Simplixity
//
//  Created by Donald Ritter on 9/20/14.
//  Copyright (c) 2014 Simplixity. All rights reserved.
//

#import "MockUserAuthentication.h"

@interface MockUserAuthentication ()
@property(nonatomic)User *authenticatingUser;

//  Listeners registered to the authentication instance.
@property(nonatomic)NSMutableArray *userAuthenticationListeners;
@property(nonatomic)BOOL isAuthenticating;
@end

@implementation MockUserAuthentication
@synthesize authenticatingUser = _authenticatingUser;
@synthesize userAuthenticationListeners = _userAuthenticationListeners;
@synthesize isAuthenticating = _isAuthenticating;

#pragma mark - Authentication
-(void)authenticateUser:(User *)user withPassword:(NSString *)password
{
    if (!self.isAuthenticating) {
        self.isAuthenticating = YES;
        self.authenticatingUser = user;
        
        __block id<UserAuthenticationListener> listener;
        __block int i = 0;
        
        for (i = [self.userAuthenticationListeners count] - 1; i >= 0; i++) {
            listener = [self.userAuthenticationListeners objectAtIndex:i];
            
            if ([listener respondsToSelector:@selector(userAuthenticationDidBegin:forUser:)]) {
                [listener userAuthenticationDidBegin:self forUser:self.authenticatingUser];
            }
        }
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        
        [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
            @try {
                //TODO parse data
                BOOL success = NO;
                
                if (success) {
                    for (i = [self.userAuthenticationListeners count] - 1; i >= 0; i++) {
                        listener = [self.userAuthenticationListeners objectAtIndex:i];
                        
                        if ([listener respondsToSelector:@selector(userAuthenticationEndedSuccessfully:forUser:)]) {
                            [listener userAuthenticationEndedSuccessfully:self forUser:self.authenticatingUser];
                        }
                    }
                }
                else {
                    for (i = [self.userAuthenticationListeners count] - 1; i >= 0; i++) {
                        listener = [self.userAuthenticationListeners objectAtIndex:i];
                        
                        if ([listener respondsToSelector:@selector(userAuthentication:forUser:endedWithError:)]) {
                            [listener userAuthentication:self forUser:self.authenticatingUser endedWithError:@"rejected"];
                        }
                    }
                }
            }
            @catch(NSException *parseError) {
                for (i = [self.userAuthenticationListeners count] - 1; i >= 0; i++) {
                    listener = [self.userAuthenticationListeners objectAtIndex:i];
                    
                    if ([listener respondsToSelector:@selector(userAuthentication:forUser:endedWithError:)]) {
                        [listener userAuthentication:self forUser:self.authenticatingUser endedWithError:[parseError reason]];
                    }
                }
            }
            
            self.isAuthenticating = NO;
            
            for (i = [self.userAuthenticationListeners count] - 1; i >= 0; i++) {
                listener = [self.userAuthenticationListeners objectAtIndex:i];
                
                if ([listener respondsToSelector:@selector(userAuthenticationDidEnd:forUser:)]){
                    [listener userAuthenticationDidEnd:self forUser:self.authenticatingUser];
                }
            }
        }];
    }
}

#pragma mark - Listener Methods
-(void)addUserAuthenticationListener:(id<UserAuthenticationListener>)listener {
    if (![self.userAuthenticationListeners containsObject:listener]) {
        [self.userAuthenticationListeners addObject:listener];
    }
}

-(void)removeUserAuthenticationListener:(id<UserAuthenticationListener>)listener {
    if ([self.userAuthenticationListeners containsObject:listener]) {
        [self.userAuthenticationListeners removeObject:listener];
    }
}

#pragma mark - Getters and Setters
-(NSMutableArray*)userAuthenticationListeners {
    if (!_userAuthenticationListeners) {
        _userAuthenticationListeners = [[NSMutableArray alloc] init];
    }
    
    return _userAuthenticationListeners;
}
@end
