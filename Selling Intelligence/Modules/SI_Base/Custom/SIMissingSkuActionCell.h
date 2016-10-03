//
//  SIMissingSkuActionCell.h
//  SellingIntelligence
//
//  Created by Sailesh on 28/10/15.
//  Copyright (c) 2015 Cognizant. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SIMissingSkuActionCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgViewSkuName;
@property (weak, nonatomic) IBOutlet UILabel *lblSkuName;
@property (weak, nonatomic) IBOutlet UILabel *lblActionTaken;
@property (weak, nonatomic) IBOutlet UILabel *lblStatus;
@property (weak, nonatomic) IBOutlet UILabel *lblTakenBy;


@end
