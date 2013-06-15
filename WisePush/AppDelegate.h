//
//  AppDelegate.h
//  WisePush
//
//  Created by Hwang kyoosung on 13. 6. 11..
//  Copyright (c) 2013년 Hwang kyoosung. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MosquittoClient.h"

@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    MosquittoClient *mosquittoClient;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) ViewController *viewController;
@property (readonly) MosquittoClient *mosquittoClient;

@end
