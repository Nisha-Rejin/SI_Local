//
//  SIInnovationAndPureplayController.h
//  Selling Intelligence
//
//  Created by Sailesh on 30/09/15.
//  Copyright (c) 2015 Cognizant. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface SIInnovationDetailCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgViewProduct;
@property (weak, nonatomic) IBOutlet UILabel *labelSkuName;
@property (weak, nonatomic) IBOutlet UILabel *labelStartDate;
@property (weak, nonatomic) IBOutlet UILabel *labelEndDate;
@property (weak, nonatomic) IBOutlet UIButton *btnYes;
@property (weak, nonatomic) IBOutlet UIButton *btnNo;

@end
