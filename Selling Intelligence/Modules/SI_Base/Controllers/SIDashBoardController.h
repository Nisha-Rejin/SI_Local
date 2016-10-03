//
//  SIBaseViewController.h
//  Selling Intelligence
//
//  Created by Sailesh on 24/09/15.
//  Copyright (c) 2015 Cognizant. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SIDashBoardController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableViewAlerts;
@property (nonatomic,strong) NSMutableArray *arrayMenuAlerts,*arrayImages;
@property (weak, nonatomic) IBOutlet UIView *viewHeader;
@property (weak, nonatomic) IBOutlet UIButton *dismissBtn;
@property (weak, nonatomic) IBOutlet UIButton *backToParentViewBtn;

@end
