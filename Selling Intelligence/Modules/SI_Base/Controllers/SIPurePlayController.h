//
//  SIPurePlayController.h
//  SellingIntelligence
//
//  Created by Sailesh on 28/10/15.
//  Copyright (c) 2015 Cognizant. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SIBaseLogic.h"
#import "SIPurePlayCell.h"
#import "SIPurePlayActionHeaderCell.h"
#import "SIPurePlayHeaderCell.h"
#import "SIPurePlayActionCell.h"

@protocol protocol_PurePlay <NSObject>
@optional

-(void)hideSubmitButton;

@end


@interface SIPurePlayController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableViewPurePlay;
@property (nonatomic) int selectedAlertType;
@property (nonatomic) int isActionedAlert;
@property (nonatomic,strong) NSMutableArray *purePlayAlertsArray;
@property(nonatomic,strong) NSMutableDictionary *purePlayDictionary;
@property (nonatomic, assign)id<protocol_PurePlay>delegate;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constPureTblViewHgt;

-(void)loadPurePlayData;

@end
