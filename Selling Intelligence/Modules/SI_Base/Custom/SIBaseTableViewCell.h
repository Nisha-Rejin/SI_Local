//
//  SIBaseTableViewCell.h
//  Selling Intelligence
//
//  Created by Sailesh on 05/10/15.
//  Copyright (c) 2015 Cognizant. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SIBaseTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgViewIcon;
@property (weak, nonatomic) IBOutlet UILabel *lblAlertsTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblAlertsCount;
@property (weak, nonatomic) IBOutlet UIButton *btnArrow;

@end
