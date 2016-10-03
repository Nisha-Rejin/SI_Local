//
//  AASkuDetailViewCell.h
//  ActiveAlerts
//
//  Created by Sailesh on 15/09/15.
//  Copyright (c) 2015 Cognizant. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SISkuDetailViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgVwSku;
@property (weak, nonatomic) IBOutlet UILabel *lblSkuName;
@property (weak, nonatomic) IBOutlet UILabel *lblVelocity;
@property (weak, nonatomic) IBOutlet UILabel *lblRank;
@property (weak, nonatomic) IBOutlet UIButton *btnSKUYes;
@property (weak, nonatomic) IBOutlet UIButton *btnSKUNO;

@end
