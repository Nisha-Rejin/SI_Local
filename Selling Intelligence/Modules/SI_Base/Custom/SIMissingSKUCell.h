//
//  SIMissingSKUCell.h
//  SellingIntelligence
//
//  Created by Sailesh on 20/10/15.
//  Copyright (c) 2015 Cognizant. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SIMissingSKUCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *btnYes;
@property (weak, nonatomic) IBOutlet UIButton *btnNO;
@property (weak, nonatomic) IBOutlet UILabel *lblSKUName;
@property (weak, nonatomic) IBOutlet UIImageView *imgVwSku;

@end
