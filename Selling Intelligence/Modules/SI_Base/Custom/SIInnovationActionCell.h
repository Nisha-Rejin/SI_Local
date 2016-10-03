//
//  SIInnovationActionCell.h
//  SellingIntelligence
//
//  Created by Cognizant MSP on 13/10/15.
//  Copyright (c) 2015 Cognizant. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SIInnovationActionCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgViewSKUName;
@property (weak, nonatomic) IBOutlet UILabel *lblSKUName;
@property (weak, nonatomic) IBOutlet UILabel *lblActionTaken;
@property (weak, nonatomic) IBOutlet UILabel *lblActionStatus;
@property (weak, nonatomic) IBOutlet UILabel *lblTakenBy;

@end
