//
//  SIBaseViewController.m
//  Selling Intelligence
//
//  Created by Sailesh on 24/09/15.
//  Copyright (c) 2015 Cognizant. All rights reserved.
//

#import "SIDashBoardController.h"
#import "SIBaseHeaderCell.h"
#import "SISubmitAlerts.h"
#import "SIUtility.h"
#import "SellingIntelligence.h"
#import "SIBaseLogic.h"
#import "SIInnovationController.h"
#import "SIBaseTableViewCell.h"
#import "SIAlertsBaseViewController.h"


@interface SIDashBoardController ()<UIAlertViewDelegate,alertsLoaderDelegate>
{
    NSMutableDictionary *alertsCountDictionary;
}
@property (weak, nonatomic) IBOutlet UIButton *btnUpdate;
@property (nonatomic, strong)SISubmitAlerts *submitAlerts;
@property (weak, nonatomic) IBOutlet UILabel *lblVersion;

@end

@implementation SIDashBoardController
@synthesize tableViewAlerts,arrayMenuAlerts,arrayImages;



- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpInitialView];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    
    if ([SellingIntelligence sharedSellingIntelligenceClass].alertsSubmitted) {
        [self setUpInitialView];
        [SellingIntelligence sharedSellingIntelligenceClass].alertsSubmitted=NO;
    }
    
    [self.tableViewAlerts reloadData];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setUpInitialView{
    [[SIBaseLogic sharedSIBaseLogic]setDelegate:self];
    [self update:self.btnUpdate];
    self.submitAlerts=[[SISubmitAlerts alloc]init];
    alertsCountDictionary=[NSMutableDictionary dictionaryWithDictionary:[[SIBaseLogic sharedSIBaseLogic]getCountForAlerts:Open]];
    
    NSString *version = [SIUtiliesController getVersionNumber];
    self.lblVersion.text = version;
    
    UIVisualEffect *blurEffect;
    blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    
    UIVisualEffectView *visualEffectView;
    visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    [self.view addSubview:visualEffectView];
    
    
    arrayMenuAlerts=[NSMutableArray arrayWithArray:[SIBaseLogic unactionedAlertsTypes]];
    
    tableViewAlerts.dataSource = self;
    tableViewAlerts.delegate = self;
    
    tableViewAlerts.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    tableViewAlerts.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self navigationBarSetUp];
    
    
}

-(void)navigationBarSetUp{
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"header-background-image" inBundle:[SIBaseLogic libraryBundlePath] compatibleWithTraitCollection:nil]];
    self.navigationController.navigationBar.translucent = NO;

    UIImage *titleImage = [UIImage imageNamed:@"sellingintelligence" inBundle:[SIBaseLogic libraryBundlePath] compatibleWithTraitCollection:nil];
    
    self.navigationItem.titleView=[[UIImageView alloc]initWithImage:titleImage];
 
    UIImage *backImage;
    
    if ([[SIUtiliesController getAppID] isEqual:@"1"]){
        backImage = [UIImage imageNamed:@"Storefacts" inBundle:[SIBaseLogic libraryBundlePath] compatibleWithTraitCollection:nil];
    }
      else{
          backImage = [UIImage imageNamed:@"BevOptimizer" inBundle:[SIBaseLogic libraryBundlePath] compatibleWithTraitCollection:nil];
    }
    
    UIButton * leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    leftButton.bounds = CGRectMake( 10, 0, backImage.size.width, backImage.size.height);
    
    [leftButton setImage:backImage forState:UIControlStateNormal];
    
    [leftButton addTarget:self
                    action:@selector(backTapped:)
          forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftButtonItem;
    
    UIImage *dismissImage = [UIImage imageNamed:@"close-icon" inBundle:[SIBaseLogic libraryBundlePath] compatibleWithTraitCollection:nil];
    
    
    UIButton * rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    rightButton.bounds = CGRectMake( 10, 0, dismissImage.size.width, dismissImage.size.height);
    
    [rightButton setImage:dismissImage forState:UIControlStateNormal];
    
    [rightButton addTarget:self
                    action:@selector(dismissSellingIntelligence:)
          forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    

}



-(void)loadAlertsFor:(int)SELECTEDALERTTYPE{
    UIStoryboard *sellingStoryBoard = [UIStoryboard storyboardWithName:kSIStoryBoardName bundle:[SIBaseLogic libraryBundlePath]];
    SIAlertsBaseViewController *alertsDisplayViewObj =[sellingStoryBoard instantiateViewControllerWithIdentifier:kAlertsDisplayVC];
    alertsDisplayViewObj.selectedAlertType=SELECTEDALERTTYPE;
    [self.navigationController pushViewController:alertsDisplayViewObj animated:YES];
}


- (IBAction)dismissSellingIntelligence:(id)sender {
    [self backTapped:sender];
}

-(void)dismissSelligenceIntelligence{
     [[NSNotificationCenter defaultCenter] postNotificationName:@"SellingIntelligenceDismissed" object:nil userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"downloadAlertsFromServer" object:self];

}


- (IBAction)backTapped:(UIButton *)sender {
    
    if([[SIBaseLogic sharedSIBaseLogic]isActionedAlertSavedLocalForStoreId:[SIUtiliesController getStoreID]]){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"SellingIntelligence" message:@"Do you want to proceed without submitting the Responses for the alerts" delegate:self cancelButtonTitle:@"Ignore" otherButtonTitles:@"Submit", nil];
        alert.tag = 100;
        [alert show];
          }else{
        [self dismissSelligenceIntelligence];
    }
  
    

}
- (IBAction)update:(id)sender {
    NSDate* date = [[SIBaseLogic sharedSIBaseLogic]lastAlertUpdatedTime];
    if(date == nil || date == (id)[NSNull null]){
        date = [NSDate date];
    }
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd hh:mm a"];
    
    NSString* strDate = [formatter stringFromDate:date];
    NSString *updated = [NSString stringWithFormat:@"         Updated %@",strDate];
    [self.btnUpdate setTitle:updated forState:UIControlStateNormal];
}


#pragma mark- Table view Delgate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 94.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    SIBaseHeaderCell *cell=(SIBaseHeaderCell *)[tableView dequeueReusableCellWithIdentifier:@"Header"];
    cell.backgroundColor=[UIColor clearColor];
    cell.lblAlertsCount.text=[alertsCountDictionary objectForKey:kUnactionedAlertsCount];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [arrayMenuAlerts count];
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SIBaseTableViewCell *cell = ( SIBaseTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    cell.lblAlertsTitle.text = arrayMenuAlerts[indexPath.row];
    cell.lblAlertsCount.text= [alertsCountDictionary objectForKey:cell.lblAlertsTitle.text];
    
    [cell.imgViewIcon setImage:[UIImage imageNamed:arrayMenuAlerts[indexPath.row] inBundle:[SIBaseLogic libraryBundlePath] compatibleWithTraitCollection:nil]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [cell.accessoryView addSubview:cell.lblAlertsCount];
    [cell.accessoryView addSubview:cell.btnArrow];
    
    [cell.btnArrow addTarget:self action:@selector(setButtonActionforAccessoryView:event:) forControlEvents:UIControlEventTouchUpInside];

    
    if (indexPath.row%2 == 0)
    {
        cell.backgroundColor = [UIColor colorWithRed:229.0/255.0 green:230.0/255.0  blue:231.0/255.0  alpha:1.0f];
    }else{
        cell.backgroundColor=[UIColor clearColor];
    }
    
    return cell;
}

-(void)setButtonActionforAccessoryView:(id)sender event:(id)event{
    
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:self.tableViewAlerts];
    NSIndexPath *indexPath = [self.tableViewAlerts indexPathForRowAtPoint:currentTouchPosition];
    [self tableView:tableViewAlerts didSelectRowAtIndexPath:indexPath];
}


#pragma mark-tableview delegate



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
     if ([arrayMenuAlerts[indexPath.row] isEqualToString:kSKUMissinginPOG])
        [self loadAlertsFor:MISSINGSKUSINPOG];
    else if ([arrayMenuAlerts[indexPath.row] isEqualToString:kSKUVoids])
        [self loadAlertsFor:SKUVOIDS];
    else if ([arrayMenuAlerts[indexPath.row] isEqualToString:kInnovationOpportunity])
        [self  loadAlertsFor:INNOVATION];
    else if([arrayMenuAlerts[indexPath.row] isEqualToString:kPurePlayOpportunity])
        [self  loadAlertsFor:PUREPLAY];


    
}

#pragma mark - alert view delegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag == 100){
        if(buttonIndex == 0){
            [self dismissSelligenceIntelligence];
        }else{
            [[SIBaseLogic sharedSIBaseLogic]setDelegate:self];
            [SellingIntelligence sharedSellingIntelligenceClass].alertsSubmitted=YES;
            [[SIUtility sharedUtility]showProgressViewWithMessage:@"Submitting and Updating Alerts.." withView:self.view isPortraid:NO];
            [self.submitAlerts formRequestForSubmittingAlerts:YES];
        }
    }
   
}

-(void)submitAlertsSuccessful{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[SIUtility sharedUtility]removeProgressView];
        alertsCountDictionary=[NSMutableDictionary dictionaryWithDictionary:[[SIBaseLogic sharedSIBaseLogic]getCountForAlerts:Open]];
        [self.tableViewAlerts reloadData];
    });
    
}


@end
