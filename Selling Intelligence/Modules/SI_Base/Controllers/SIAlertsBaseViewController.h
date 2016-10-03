//
//  SIAlertsDisplayViewController.h
//  Selling Intelligence
//
//  Created by Sailesh on 24/09/15.
//  Copyright (c) 2015 Cognizant. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SIBaseLogic.h"


@interface SIAlertsBaseViewController : UIViewController<UIPopoverControllerDelegate,alertsLoaderDelegate>

@property (weak, nonatomic) IBOutlet UILabel *lblAlertName;
@property (nonatomic,strong) NSMutableArray *arrayMenuAlerts;
@property (nonatomic) int searchTypeSelected,selectedAlertType;
@property (nonatomic) BOOL isCalculatorEnabled;
@property(nonatomic, strong) UIPopoverController *popoverControllerInstance;
@property (weak, nonatomic) IBOutlet UITableView *tableViewAlertsMenu;
@property (weak, nonatomic) IBOutlet UIButton *btnCalculator;
@property (weak, nonatomic) IBOutlet UIView *viewChildBG;
@property (weak, nonatomic) IBOutlet UIView *viewHeader;
@property (weak, nonatomic) IBOutlet UIButton *btnInfo;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnInfoTrailing;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintHorSpaceInfo;


-(void)loadMissingSKUSAlerts;
-(void)loadSkuAlerts;
-(void)loadInnovationAlerts;
-(void)loadPurePlayAlerts;
-(void)submitAlerts;
-(void)hideSubmitButton;
@end
