//
//  InfoPopOverViewController.h
//  SellingIntelligence
//
//  Created by Cognizant MSP on 20/01/16.
//  Copyright (c) 2016 Cognizant. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfoPopOverViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *lblInfo;
@property (nonatomic, readwrite)NSInteger alertType;

@end
