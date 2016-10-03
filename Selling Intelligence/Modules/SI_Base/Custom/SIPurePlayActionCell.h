//
//  SIPurePlayActionCell.h
//  SellingIntelligence
//
//  Created by Sailesh on 28/10/15.
//  Copyright (c) 2015 Cognizant. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SIPurePlayActionCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgViewSKUName;
@property (weak, nonatomic) IBOutlet UILabel *lblSKUName;
@property (weak, nonatomic) IBOutlet UILabel *lblActionTaken;
@property (weak, nonatomic) IBOutlet UILabel *lblPurePlayActionTaken;
@property (weak, nonatomic) IBOutlet UILabel *lblActionedDate;
@end
