//
//  MockUserAuthentication.m
//  Simplixity
//
//  Created by Donald Ritter on 9/20/14.
//  Copyright (c) 2014 Simplixity. All rights reserved.
//

#import "MockUserAuthentication.h"
#import "NSMutableURLRequest+EasyParams.h"

@interface MockUserAuthentication ()
@property(nonatomic)User *authenticatingUser;

//  Listeners registered to the authentication instance.
@property(nonatomic)NSMutableArray *userAuthenticationListeners;
@property(nonatomic)BOOL isAuthenticating;
@property(nonatomic)NSString *serverRoot;
@end

@implementation MockUserAuthentication
@synthesize authenticatingUser = _authenticatingUser;
@synthesize userAuthenticationListeners = _userAuthenticationListeners;
@synthesize isAuthenticating = _isAuthenticating;
@synthesize serverRoot = _serverRoot;

#pragma mark - Authentication
-(void)authenticateUser:(User *)user withPassword:(NSString *)password
{
    if (!self.isAuthenticating) {
        self.isAuthenticating = YES;
        self.authenticatingUser = user;
        
        NSLog(@"Before calling listeners");
        
        __block id<UserAuthenticationListener> listener;
        __block long i = 0;
        
        for (i = [self.userAuthenticationListeners count] - 1; i >= 0; i--) {
            listener = [self.userAuthenticationListeners objectAtIndex:i];
            
            if ([listener respondsToSelector:@selector(userAuthentication:didBeginForUser:)]) {
                [listener userAuthentication:self didBeginForUser:self.authenticatingUser];
            }
        }
        
        NSLog(@"Building Request");
        NSDictionary *params = @{@"username" : user.uid, @"password" : password};
        NSMutableURLRequest *request = [NSMutableURLRequest urlWithString:[NSString stringWithFormat:@"%@/authentication", self.serverRoot] andMethod:@"POST" andParams:params];
        
        NSLog(@"Request built:%@,%@,%@", request.URL, request.HTTPMethod, request.HTTPBody);
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        
        [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
            NSLog(@"Received request result%@,%@,%@", response, data, error);
            @try {
                BOOL success = NO;
                NSString *errorMessage;
                
                if (error) {
                    errorMessage = [error helpAnchor];
                }
                
                NSString *responseData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                NSLog(@"%@", responseData);
                
                //TODO parse data
                self.isAuthenticating = NO;
                
                if (success) {
                    for (i = [self.userAuthenticationListeners count] - 1; i >= 0; i--) {
                        listener = [self.userAuthenticationListeners objectAtIndex:i];
                        
                        if ([listener respondsToSelector:@selector(userAuthentication:endedSuccessfullyForUser:)]) {
                            [listener userAuthentication:self endedSuccessfullyForUser:self.authenticatingUser];
                        }
                    }
                }
                else {
                    for (i = [self.userAuthenticationListeners count] - 1; i >= 0; i--) {
                        listener = [self.userAuthenticationListeners objectAtIndex:i];
                        
                        if ([listener respondsToSelector:@selector(userAuthentication:forUser:endedWithError:)]) {
                            [listener userAuthentication:self forUser:self.authenticatingUser endedWithError:errorMessage];
                        }
                    }
                }
            }
            @catch(NSException *parseError) {
                self.isAuthenticating = NO;
                
                for (i = [self.userAuthenticationListeners count] - 1; i >= 0; i--) {
                    listener = [self.userAuthenticationListeners objectAtIndex:i];
                    
                    if ([listener respondsToSelector:@selector(userAuthentication:forUser:endedWithError:)]) {
                        [listener userAuthentication:self forUser:self.authenticatingUser endedWithError:[parseError reason]];
                    }
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

-(NSString*)serverRoot {
    if (!_serverRoot) {
        _serverRoot = @"http://104.131.15.123:8080";
    }
    
    return _serverRoot;
}
@end
