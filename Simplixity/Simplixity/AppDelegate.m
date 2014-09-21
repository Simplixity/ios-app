//
//  AppDelegate.m
//  Simplixity
//
//  Created by Donald Ritter on 9/20/14.
//  Copyright (c) 2014 Simplixity. All rights reserved.
//

#import "AppDelegate.h"
#import "User.h"
#import "Person.h"
#import "AuthenticationViewController.h"
#import "HomeViewController.h"
#import "DataTransferViewController.h"

@interface AppDelegate()<AuthenticationViewControllerDelegate, UINavigationControllerDelegate, HomeViewControllerDelegate>
@property(nonatomic)UIStoryboard *storyboard;

//  Controller for main navigation.
@property(nonatomic)UINavigationController *navigationController;

//  Currently logged in user.
@property(nonatomic)User *user;

//  Currently loaded person info
@property(nonatomic)Person *person;
@end

@implementation AppDelegate
@synthesize storyboard = _storyboard;
@synthesize navigationController = _navigationController;
@synthesize user = _user;
@synthesize person = _person;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    //self.window.backgroundColor = [UIColor whiteColor];
    //[self.window makeKeyAndVisible];
    
    if (!self.navigationController) {
        self.navigationController = (UINavigationController*)self.window.rootViewController;
        self.navigationController.delegate = self;
    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (navigationController == self.navigationController) {
        if ([viewController isKindOfClass:[AuthenticationViewController class]]) {
            AuthenticationViewController *authenticationController = (AuthenticationViewController*)viewController;
            authenticationController.delegate = self;
        }
    }
}

#pragma mark - AuthenticationViewControllerDelegate
-(void)authenticationViewControllerDidAuthenticateSuccessfully:(AuthenticationViewController*)controller withUser:(User*)user andPerson:(Person*)person {
    self.user = user;
    self.person = person;
    
    if (self.storyboard) {
        HomeViewController *homeController = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeViewController"];
        homeController.delegate = self;
        homeController.user = user;
        homeController.person = person;
        
        if (self.navigationController.topViewController) {
            [self.navigationController pushViewController:homeController animated:YES];
        }
    }
}

#pragma mark - HomeViewControllerDelegate
-(void)homeViewControllerNewRegistration:(HomeViewController*)controller {
    NSLog(@"New Registration Clicked");
    
    if (self.storyboard) {
        DataTransferViewController *dataTransferController = [self.storyboard instantiateViewControllerWithIdentifier:@"DataTransferViewController"];
        //dataTransferController.delegate = self;
        dataTransferController.user = self.user;
        
        if (self.navigationController.topViewController) {
            [self.navigationController pushViewController:dataTransferController animated:YES];
        }
    }
}

#pragma mark - Getters and Setters
-(UIStoryboard*)storyboard {
    if (!_storyboard && self.navigationController) {
        _storyboard = self.navigationController.storyboard;
    }
    
    return _storyboard;
}
@end
