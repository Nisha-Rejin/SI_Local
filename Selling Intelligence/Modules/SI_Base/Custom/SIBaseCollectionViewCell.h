//
//  SIBaseCollectionViewCell.h
//  Selling Intelligence
//
//  Created by Sailesh on 28/09/15.
//  Copyright (c) 2015 Cognizant. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SIBaseTableViewCell.h"
#import "SIAlertsDisplayViewController.h"
#include "Selling_IntelligenceConstants.h"

@protocol AlertsLoader <NSObject>

@required

-(void)loadAlertsFor:(int)SELECTEDALERTTYPE;

@end

@interface SIBaseCollectionViewCell : UICollectionViewCell<UITableViewDelegate,UITableViewDataSource>

@property (weak,nonatomic) id<AlertsLoader> alertsLoaderDelegate;
@property (weak, nonatomic) IBOutlet UITableView *tableViewAlerts;
@property (nonatomic,strong) NSMutableArray *arrayMenuAlerts,*arrayImages;

@end
