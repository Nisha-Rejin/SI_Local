//
//  SIBaseHeaderCell.h
//  Selling Intelligence
//
//  Created by Sailesh on 06/10/15.
//  Copyright (c) 2015 Cognizant. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SIBaseHeaderCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblAlerts;
@property (weak, nonatomic) IBOutlet UILabel *lblAlertsCount;

@end
