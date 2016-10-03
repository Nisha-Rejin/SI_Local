//
//  SIInnovationAndPureplayController.h
//  Selling Intelligence
//
//  Created by Sailesh on 29/09/15.
//  Copyright (c) 2015 Cognizant. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "SISkuVoidsHeaderCell.h"
#import "SISkuDetailViewCell.h"
#import "SIBaseLogic.h"
#import "SISkuEditableCell.h"
#import "SISkuVoidsEditableHeaderCell.h"
#import "SISkuActionCell.h"
#import "SIMissingSKUCell.h"
#import "SIMissingSKUHeader.h"
#import "SISkuActionHeader.h"
#import "SIPurePlayCell.h"
#import "Selling_IntelligenceConstants.h"

@protocol protocol_SkuVoid <NSObject>
@optional

-(void)hideSubmitButton;

@end


@interface SISkuVoidsController : UIViewController<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableViewSkuVoids;
@property (nonatomic) int selectedAlertType;
@property (nonatomic) int isActionedAlert;
@property (nonatomic) BOOL isCalculatorEnabled;
@property (nonatomic,strong) NSMutableArray *arrayRates,*skuVoidsAlertsArray,*missingSKUAlertsArray;
@property (nonatomic,strong) NSIndexPath *editingIndexPath;
@property (nonatomic, assign)id<protocol_SkuVoid>delegate;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constSkuTblViewHgt;

-(void)loadSkuvoidsData;;

@end
