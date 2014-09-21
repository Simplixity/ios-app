//
//  MockUserInformation.m
//  Simplixity
//
//  Created by Donald Ritter on 9/21/14.
//  Copyright (c) 2014 Simplixity. All rights reserved.
//

#import "MockPersonInformation.h"
#import "UserInformation.h"
#import "User.h"
#import "NSMutableURLRequest+EasyParams.h"

@interface MockPersonInformation()
//  User currently being loaded.
@property(nonatomic)NSString *personUid;

//  Whether a person is currently loading.
@property(nonatomic)BOOL isLoading;

//  Listeners registered.
@property(nonatomic)NSMutableArray *personInformationListeners;
@property(nonatomic)NSString *serverRoot;
@end

@implementation MockPersonInformation
@synthesize personUid = _personUid;
@synthesize personInformationListeners = _personInformationListeners;

-(void)loadInformationForPerson:(NSString*)personUid {
    if (!self.isLoading) {
        self.isLoading = YES;
        self.personUid = personUid;
        
        __block id<PersonInformationListener> listener;
        __block long i = 0;
        
        for (i = [self.personInformationListeners count] - 1; i >= 0; i--) {
            listener = [self.personInformationListeners objectAtIndex:i];
            
            if ([listener respondsToSelector:@selector(personInformation:didBeginLoadingForPersonUid:)]) {
                [listener personInformation:self didBeginLoadingForPersonUid:self.personUid];
            }
        }
        
        //loading the person info
        NSMutableURLRequest *request = [NSMutableURLRequest urlWithString:[NSString stringWithFormat:@"%@/person/%@", self.serverRoot, self.personUid] andMethod:@"GET" andParams:nil];
        [request setTimeoutInterval:5];
        
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
            @try {
                NSLog(@"Person Info Complete:%@", error);
                self.isLoading = NO;
                
                BOOL success = NO;
                NSString *errorMessage;
                Person *person = [[Person alloc] init];
                
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
                    
                    NSLog(@"JSON:%@", json);
                    
                    if (jsonError) {
                        errorMessage = [jsonError helpAnchor];
                    }
                    else if (json) {
                        if (json) {
                            person.uid = self.personUid;
                            person.name.first = [json objectForKey:@"first_name"];
                            person.name.last = [json objectForKey:@"last_name"];
                            success = YES;
                        }
                    }
                }
                
                if (success) {
                    for (i = [self.personInformationListeners count] - 1; i >= 0; i--) {
                        listener = [self.personInformationListeners objectAtIndex:i];
                        
                        if ([listener respondsToSelector:@selector(personInformation:didEndLoadingSuccessfullyForPersonUid:intoPerson:)]) {
                            [listener personInformation:self didEndLoadingSuccessfullyForPersonUid:self.personUid intoPerson:person];
                        }
                    }
                }
                else {
                    for (i = [self.personInformationListeners count] - 1; i >= 0; i--) {
                        listener = [self.personInformationListeners objectAtIndex:i];
                        
                        if ([listener respondsToSelector:@selector(personInformation:didEndLoadingForPersonUid:withError:)]) {
                            [listener personInformation:self didEndLoadingForPersonUid:self.personUid withError:errorMessage];
                        }
                    }
                }
            }
            @catch(NSException *parseError) {
                self.isLoading = NO;
                
                for (i = [self.personInformationListeners count] - 1; i >= 0; i--) {
                    listener = [self.personInformationListeners objectAtIndex:i];
                    
                    if ([listener respondsToSelector:@selector(personInformation:didEndLoadingForPersonUid:withError:)]) {
                        [listener personInformation:self didEndLoadingForPersonUid:self.personUid withError:[parseError reason]];
                    }
                }
            }
        }];
    }
}

-(void)addPersonInformationListener:(id<PersonInformationListener>)listener {
    if (![self.personInformationListeners containsObject:listener]) {
        [self.personInformationListeners addObject:listener];
    }
}

-(void)removePersonInformationListener:(id<PersonInformationListener>)listener {
    if ([self.personInformationListeners containsObject:listener]) {
        [self.personInformationListeners removeObject:listener];
    }
}

#pragma mark - Getters and setters
-(NSMutableArray*)personInformationListeners {
    if (!_personInformationListeners) {
        _personInformationListeners = [[NSMutableArray alloc] init];
    }
    
    return _personInformationListeners;
}
                                                 
-(NSString*)serverRoot {
    if (!_serverRoot) {
        _serverRoot = @"http://104.131.15.123:8080";
    }

    return _serverRoot;
}
@end
