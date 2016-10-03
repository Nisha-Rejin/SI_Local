//
//  SISkuActionCell.h
//  SellingIntelligence
//
//  Created by Cognizant MSP on 13/10/15.
//  Copyright (c) 2015 Cognizant. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SISkuActionCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgViewSkuName;
@property (weak, nonatomic) IBOutlet UILabel *lblSkuName;
@property (weak, nonatomic) IBOutlet UILabel *lblActionTaken;
@property (weak, nonatomic) IBOutlet UILabel *lblStatus;
@property (weak, nonatomic) IBOutlet UILabel *lblTakenBy;

@end
