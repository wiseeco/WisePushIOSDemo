//
//  ViewController.h
//  WisePush
//
//  Created by Hwang kyoosung on 13. 6. 11..
//  Copyright (c) 2013년 Hwang kyoosung. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MosquittoClient.h"

@interface ViewController : UIViewController <MosquittoClientDelegate>
{
    UILabel*    topicName;
    UIButton*   btnPushStart;
    UIButton*   btnPushStop;
    
    BOOL        bConnected;
}

@property (nonatomic, retain)   IBOutlet UILabel*   topicName;
@property (nonatomic, retain)   IBOutlet UIButton*  btnPushStart;
@property (nonatomic, retain)   IBOutlet UIButton*  btnPushStop;

-(IBAction)pushStartBtnClick:(id)sender;
-(IBAction)pushStopBtnClick:(id)sender;

@end
