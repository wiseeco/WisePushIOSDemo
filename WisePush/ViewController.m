//
//  ViewController.m
//  WisePush
//
//  Created by Hwang kyoosung on 13. 6. 11..
//  Copyright (c) 2013년 Hwang kyoosung. All rights reserved.
//

#import "ViewController.h"
#import "getMacAddress.h"
#import "AppDelegate.h"

#define WISE_SERVER_URL         @"www.wiseeco.com"
#define WISE_SERVER_PORT        1883


@interface ViewController ()

@end

@implementation ViewController

@synthesize topicName, btnPushStart, btnPushStop;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    topicName.text = [NSString stringWithFormat:@"/wise/%@", getMacAddress()];
}

- (void)viewDidUnload
{
    self.topicName      = nil;
    self.btnPushStart   = nil;
    self.btnPushStop    = nil;
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)pushStartBtnClick:(id)sender
{
    [btnPushStart setEnabled:NO];
    [btnPushStart setAlpha:0.5];
    [btnPushStop  setEnabled:YES];
    [btnPushStop  setAlpha:1.0];
    
    AppDelegate *app = [[UIApplication sharedApplication] delegate];
	MosquittoClient *mosq = [app mosquittoClient];
    
    [mosq setHost:WISE_SERVER_URL];
    [mosq setPort:WISE_SERVER_PORT];
    bConnected = YES;
	[mosq connect];
    
    [mosq subscribe:topicName.text];
}

-(IBAction)pushStopBtnClick:(id)sender
{
    [btnPushStart setEnabled:YES];
    [btnPushStart setAlpha:1.0];
    [btnPushStop  setEnabled:NO];
    [btnPushStop  setAlpha:0.5];
    
    AppDelegate *app = [[UIApplication sharedApplication] delegate];
	MosquittoClient *mosq = [app mosquittoClient];
    bConnected = NO;
    [mosq disconnect];
}

#pragma mark MQTT 

- (void) didConnect:(NSUInteger)code {
    //  Nothing
}

- (void) didDisconnect {
    if (bConnected)
    {
        AppDelegate *app = [[UIApplication sharedApplication] delegate];
        MosquittoClient *mosq = [app mosquittoClient];
        [mosq reconnect];
    }
}

- (void) didReceiveMessage:(MosquittoMessage*)mosq_msg
{
	NSLog(@"%@ => %@", mosq_msg.topic, mosq_msg.payload);
    
    //  Local Notification 표시
    UILocalNotification *localNotif = [[UILocalNotification alloc]init];
	if (localNotif == nil)
        return;
    
    NSDate *now = [NSDate date];
    localNotif.fireDate = now;
    localNotif.timeZone = [NSTimeZone defaultTimeZone];
    localNotif.alertBody = mosq_msg.payload;
    localNotif.soundName = UILocalNotificationDefaultSoundName;
    localNotif.applicationIconBadgeNumber = 0;
    localNotif.userInfo = nil;
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
    
    //  메세지 표시
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                    message:mosq_msg.payload
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
}

- (void) didPublish: (NSUInteger)messageId {}
- (void) didSubscribe: (NSUInteger)messageId grantedQos:(NSArray*)qos {}
- (void) didUnsubscribe: (NSUInteger)messageId {}


@end
