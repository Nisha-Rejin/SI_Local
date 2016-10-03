//
//  InfoPopOverViewController.m
//  SellingIntelligence
//
//  Created by Cognizant MSP on 20/01/16.
//  Copyright (c) 2016 Cognizant. All rights reserved.
//

#import "InfoPopOverViewController.h"
#import "Selling_IntelligenceConstants.h"

@interface InfoPopOverViewController ()

@end

@implementation InfoPopOverViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.preferredContentSize =  CGSizeMake(512, 90);
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    if (self.alertType==SKUVOIDS)
    {
        self.lblInfo.text = @"Notify user if high velocity SKU’s haven’t been ordered for a specific time period";
        
    }
    if (self.alertType==MISSINGSKUSINPOG) {
        self.lblInfo.text =  @"Based on the reset POG, notify user of SKU’s in the set that haven’t been ordered";
    }
    if (self.alertType==INNOVATION) {
        self.lblInfo.text =  @"Notify user if Innovation SKU’s haven’t been ordered for a specific time period";
    }
    if (self.alertType==PUREPLAY) {
        
        self.lblInfo.text =  @"Based on the Store Facts survey data, notify user if a store has an opportunity to place a Pure Play";

    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
