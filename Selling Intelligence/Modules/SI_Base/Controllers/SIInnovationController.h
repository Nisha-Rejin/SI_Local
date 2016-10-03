//
//  SIInnovationAndPureplayController.h
//  Selling Intelligence
//
//  Created by Sailesh on 30/09/15.
//  Copyright (c) 2015 Cognizant. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SIInnovationDetailCell.h"
#import "SIInnovationHeaderCell.h"
#import "SIPurePlayCell.h"
#import "SIInnovationsActionCell.h"
#import "SIPurePlayHeaderCell.h"
#import "SIInnovationHeader.h"
#import "Selling_IntelligenceConstants.h"
#import "SIAlertsBaseViewController.h"

@protocol protocol_Innovation <NSObject>
@optional

-(void)hideSubmitButton;


@end

@interface SIInnovationController : UIViewController<UITableViewDataSource,UITableViewDelegate,alertsLoaderDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableViewInnovationAndPurePlay;
@property (nonatomic) int selectedAlertType;
@property (nonatomic) int isActionedAlert;
@property (nonatomic,strong) NSMutableArray *innovationAlertsArray;
@property(nonatomic,strong) NSMutableDictionary *innnovationDictionary;
@property (nonatomic, assign)id<protocol_Innovation>delegate;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constInnoTblViewHeight;

-(void)loadInnovationData;


@end
