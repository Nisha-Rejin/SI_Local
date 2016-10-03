//
//  SIMissingSKUsController.h
//  SellingIntelligence
//
//  Created by Sailesh on 28/10/15.
//  Copyright (c) 2015 Cognizant. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SIMissingSKUCell.h"
#import "SIMissingSkuActionCell.h"
#import "SIMissingSKUHeader.h"
#import "SIUtiliesController.h"
#import "SIMissingSKUActionHeaderCell.h"
#import "SIMissingSKUHeader.h"

@protocol protocol_MissingSkuVoid <NSObject>

@optional
-(void)hideSubmitButton;

@end


@interface SIMissingSKUsController :  UIViewController<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableViewMissingSkuVoids;
@property (nonatomic) int selectedAlertType;
@property (nonatomic) int isActionedAlert;
@property (nonatomic,strong) NSMutableArray *missingSKUAlertsArray;
@property (nonatomic, assign)id<protocol_MissingSkuVoid>delegate;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constMisSqTblViewheight;

-(void)loadMissingSKUData;

@end
