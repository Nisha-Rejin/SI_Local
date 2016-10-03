//
//  SISkuEditableCell.h
//  Selling Intelligence
//
//  Created by Cognizant MSP on 29/09/15.
//  Copyright (c) 2015 Cognizant. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SISkuEditableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgVwSkuName;
@property (weak, nonatomic) IBOutlet UILabel *lblSkuName;
@property (weak, nonatomic) IBOutlet UILabel *lblVelocity;
@property (weak, nonatomic) IBOutlet UILabel *lblPotentialSales;
@property (weak, nonatomic) IBOutlet UITextField *txtFieldRates;
@property (weak, nonatomic) IBOutlet UIButton *btnSKUYes;
@property (weak, nonatomic) IBOutlet UIButton *btnSKUNo;

@end
