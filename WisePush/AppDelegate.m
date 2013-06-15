//
//  AppDelegate.m
//  WisePush
//
//  Created by Hwang kyoosung on 13. 6. 11..
//  Copyright (c) 2013년 Hwang kyoosung. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "getMacAddress.h"

@implementation AppDelegate

@synthesize mosquittoClient;

- (void)dealloc
{
    [_window release];
    [_viewController release];
    
    if (mosquittoClient) [mosquittoClient dealloc];
    
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    self.viewController = [[[ViewController alloc] initWithNibName:@"ViewController" bundle:nil] autorelease];
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    
    NSString *clientId = [NSString stringWithFormat:@"wisemqtt_%@", getMacAddress()];
	NSLog(@"Client ID: %@", clientId);
    mosquittoClient = [[MosquittoClient alloc] initWithClientId:clientId];

    // FIXME: only if compiled in debug mode?
	//[mosquittoClient setLogPriorities:MOSQ_LOG_ALL destinations:MOSQ_LOG_STDERR];
	[mosquittoClient setDelegate: self.viewController];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    [mosquittoClient disconnect];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [mosquittoClient disconnect];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [mosquittoClient reconnect];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [mosquittoClient disconnect];
}

@end
