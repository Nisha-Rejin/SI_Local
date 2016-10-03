//
//  SIAlertsDisplayViewController.m
//  Selling Intelligence
//
//  Created by Sailesh on 24/09/15.
//  Copyright (c) 2015 Cognizant. All rights reserved.
//

#import "SIAlertsBaseViewController.h"
#import "SISubmitAlerts.h"
#import "SellingIntelligence.h"
#import "SIUtility.h"
#import "SISkuVoidsController.h"
#import "SIInnovationController.h"
#import "Selling_IntelligenceConstants.h"
#import "SIPurePlayController.h"
#import "SIMissingSKUsController.h"
#import "SIAlertListCell.h"
#import "InfoPopOverViewController.h"

@interface SIAlertsBaseViewController ()<protocol_SkuVoid,protocol_PurePlay,protocol_MissingSkuVoid,protocol_Innovation>
{
    CGRect viewFrame;
    NSMutableDictionary *alertsCountDictionary;
    UIButton *rightButton;
    UIBarButtonItem *rightButtonItem;
    NSMutableArray *arrayMenuAlertTypes;
    SISubmitAlerts *submitAlerts;
    UIActivityIndicatorView *activityIndicator;
    UILabel *lblMessage;
}
@property (weak, nonatomic) IBOutlet UIButton *btnUpdate;

@property (nonatomic, strong) SIPurePlayController *pureplayVC;
@property (nonatomic, strong) SISkuVoidsController *skuVoidsTVC;
@property (nonatomic, strong) SIMissingSKUsController *missingSKUs;
@property (nonatomic, strong) SIInnovationController *innovationVC;

@end

@implementation SIAlertsBaseViewController
@synthesize arrayMenuAlerts,searchTypeSelected,selectedAlertType,tableViewAlertsMenu,popoverControllerInstance,isCalculatorEnabled,viewChildBG,btnInfo,btnInfoTrailing,btnCalculator,viewHeader;


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeChildViewControllers];
    [self setUpInitialView];
    
    // Do any additional setup after loading the view.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated
{
//    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void) viewWillDisappear:(BOOL)animated{
    
//    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
}

-(void)setUpInitialView{
    
    [[SIBaseLogic sharedSIBaseLogic]setDelegate:self];
    
    [self update:self.btnUpdate];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"header-background-image" inBundle:[SIBaseLogic libraryBundlePath] compatibleWithTraitCollection:nil]];

    UIImage *titleImage = [UIImage imageNamed:@"sellingintelligence" inBundle:[SIBaseLogic libraryBundlePath] compatibleWithTraitCollection:nil];

    self.navigationItem.titleView=[[UIImageView alloc]initWithImage:titleImage];
    


    
    self.navigationController.navigationItem.leftBarButtonItem.title=@"Back";
    self.navigationController.navigationBar.translucent = NO;
    submitAlerts=[[SISubmitAlerts alloc]init];

    UIImage *submitImage = [UIImage imageNamed:@"submit" inBundle:[SIBaseLogic libraryBundlePath] compatibleWithTraitCollection:nil];
    
    
    rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    rightButton.bounds = CGRectMake( 10, 0, submitImage.size.width, submitImage.size.height);
    
    [rightButton setImage:submitImage forState:UIControlStateNormal];
    [rightButton addTarget:self
                    action:@selector(submitAlerts)
          forControlEvents:UIControlEventTouchUpInside];
    rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    
    if(![[SIBaseLogic sharedSIBaseLogic]isActionedAlertSavedLocalForStoreId:[SIUtiliesController getStoreID]])
        self.navigationItem.rightBarButtonItem = nil;

        alertsCountDictionary=[NSMutableDictionary dictionaryWithDictionary:[[SIBaseLogic sharedSIBaseLogic]getCountForAlerts:Open]];
    

    arrayMenuAlertTypes=[NSMutableArray arrayWithArray:[SIBaseLogic unactionedAlertsTypes]];
    arrayMenuAlerts=[NSMutableArray arrayWithArray:[SIBaseLogic getAlertsBaseArray:arrayMenuAlertTypes]];
    
    self.lblAlertName.text=[NSString stringWithFormat:@"%@",[SIBaseLogic alertEnumToString:selectedAlertType]];
    
    searchTypeSelected=Open;
    [self hideSubmitButton];
    [self alertsLoader:NO];
    
}

-(void)initializeChildViewControllers{
    UIStoryboard *sellingStoryBoard = [UIStoryboard storyboardWithName:kSIStoryBoardName bundle:[SIBaseLogic libraryBundlePath]];
    viewFrame=kViewFrame;

    self.pureplayVC =[sellingStoryBoard instantiateViewControllerWithIdentifier:@"PurePlay"];

    self.pureplayVC.view.frame=viewFrame;
    
    
    self.missingSKUs =[sellingStoryBoard instantiateViewControllerWithIdentifier:@"MissingSKUs"];
  
    self.missingSKUs.view.frame=viewFrame;
    
    self.skuVoidsTVC =[sellingStoryBoard instantiateViewControllerWithIdentifier:@"SkuVoidsVC"];

    
    self.skuVoidsTVC.view.frame=viewFrame;
    
    self.innovationVC =[sellingStoryBoard instantiateViewControllerWithIdentifier:kInnovationAndPureplayVC];
  
    self.innovationVC.view.frame=viewFrame;
    
    self.missingSKUs.constMisSqTblViewheight.constant = viewFrame.size.height-70;
    self.skuVoidsTVC.constSkuTblViewHgt.constant = viewFrame.size.height-70;
    self.pureplayVC.constPureTblViewHgt.constant = viewFrame.size.height-70;
    self.innovationVC.constInnoTblViewHeight.constant = viewFrame.size.height-70;
    
//    self.missingSKUs.constMisSqTblViewheight.constant = viewFrame.size.height-60;
//    self.skuVoidsTVC.constSkuTblViewHgt.constant = viewFrame.size.height-60;
//    self.pureplayVC.constPureTblViewHgt.constant = viewFrame.size.height-60;
//    self.innovationVC.constInnoTblViewHeight.constant = viewFrame.size.height-60;
}

-(void)submitAlerts{
    if([[SIBaseLogic sharedSIBaseLogic]isActionedAlertSavedLocalForStoreId:[SIUtiliesController getStoreID]]){
        [[SIBaseLogic sharedSIBaseLogic]setDelegate:self];
        [SellingIntelligence sharedSellingIntelligenceClass].alertsSubmitted=YES;
        [[SIUtility sharedUtility]showProgressViewWithMessage:@"Submitting and Updating Alerts.." withView:self.view isPortraid:NO];
        [submitAlerts formRequestForSubmittingAlerts:YES];
     }else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"SellingIntelligence" message:@"No Actions to be submitted" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
     }
}

-(void)submitAlertsSuccessful{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[SIUtility sharedUtility]removeProgressView];
        int alertType=[SellingIntelligence sharedSellingIntelligenceClass].selectedAlertType;
        
        if (alertType==SKUVOIDS)
        {
            [self.skuVoidsTVC loadSkuvoidsData];
            
        }
        if (alertType==MISSINGSKUSINPOG) {
            
            [self.missingSKUs loadMissingSKUData];
            
        }
        if (alertType==INNOVATION) {
            [self.innovationVC loadInnovationData];
        }
        if (alertType==PUREPLAY) {
            
            [self.pureplayVC loadPurePlayData];
        }

        alertsCountDictionary=[NSMutableDictionary dictionaryWithDictionary:[[SIBaseLogic sharedSIBaseLogic]getCountForAlerts:Open]];
        [self.tableViewAlertsMenu reloadData];
    });
   

}


-(void)hideSubmitButton{
    
    if(![[SIBaseLogic sharedSIBaseLogic]isActionedAlertSavedLocalForStoreId:[SIUtiliesController getStoreID]])
        self.navigationItem.rightBarButtonItem = nil;
    else
        self.navigationItem.rightBarButtonItem = rightButtonItem;
}



#pragma mark- Button Actions

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

- (IBAction)btnInfoPressed:(UIButton *)sender {
    
    
    UIStoryboard *sellingStoryBoard = [UIStoryboard storyboardWithName:kSIStoryBoardName bundle:[SIBaseLogic libraryBundlePath]];
    InfoPopOverViewController *infoPopOver=[sellingStoryBoard instantiateViewControllerWithIdentifier:@"InfoPopOverViewController"];
    UIPopoverController *popoverControllerObject = [[UIPopoverController alloc] initWithContentViewController:infoPopOver];
    
    self.popoverControllerInstance=popoverControllerObject;
    self.popoverControllerInstance.delegate=self;
    
    infoPopOver.preferredContentSize=CGSizeMake([[UIScreen mainScreen]bounds].size.width*.50,90.0);
    CGRect popover_rect = [self.view convertRect:[sender frame]
                                        fromView:[sender superview]];
    
    int alertType=[SellingIntelligence sharedSellingIntelligenceClass].selectedAlertType;
    infoPopOver.alertType = alertType;
    
    [self.popoverControllerInstance presentPopoverFromRect:popover_rect  inView:self.view permittedArrowDirections: UIPopoverArrowDirectionUp animated:YES];
    
    
}

- (IBAction)btnCalculatorPressed:(UIButton *)sender {
    
    if (sender.selected)
    {
        isCalculatorEnabled=NO;
        sender.selected=NO;
    }
    else
    {
        isCalculatorEnabled=YES;
        sender.selected=YES;
    }
    
    [self loadSkuAlerts];
    
}

- (IBAction)openCompleteSegmentedControler:(UISegmentedControl *)sender {
    
    
    switch (sender.selectedSegmentIndex) {
        case 0:
        {
            searchTypeSelected=Open;
            [self alertsLoader:YES];
          
            
        }
            break;
        case 1:
        {
            searchTypeSelected=Completed;
            self.btnCalculator.selected=NO;
            isCalculatorEnabled=NO;
            [self alertsLoader:YES];
        }
            break;
        default:
            break;
    }
    alertsCountDictionary=[NSMutableDictionary dictionaryWithDictionary:[[SIBaseLogic sharedSIBaseLogic]getCountForAlerts:searchTypeSelected]];
    
    
    [self.tableViewAlertsMenu reloadData];
}

#pragma mark - alert Loaders

-(void)alertsLoader:(BOOL)isSegmentSelected
{
    if (selectedAlertType==SKUVOIDS)
    {
        [self loadSkuAlerts];
    }
    if (selectedAlertType==MISSINGSKUSINPOG) {
        [self loadMissingSKUSAlerts];
    }
    if (selectedAlertType==INNOVATION) {
        [self loadInnovationAlerts];
    }
    if (selectedAlertType==PUREPLAY) {
        [self loadPurePlayAlerts];
    }

}


-(void)loadSkuAlerts{
    
    
    [self dismissChildViewControllers];
    
    selectedAlertType=SKUVOIDS;
    self.skuVoidsTVC.delegate = self;

    
    if (searchTypeSelected==Open) {
        [self setConstraintsforButtonInfo:YES];
        btnCalculator.userInteractionEnabled=YES;
        btnCalculator.hidden=NO;
    }
   else if (searchTypeSelected==Completed) {
        [self setConstraintsforButtonInfo:NO];
        btnCalculator.userInteractionEnabled=NO;
        btnCalculator.hidden=YES;
    }
 
    
    self.skuVoidsTVC.isActionedAlert=searchTypeSelected;
    self.skuVoidsTVC.isCalculatorEnabled=isCalculatorEnabled;
    [self.skuVoidsTVC loadSkuvoidsData];
    [self addChildViewController:self.skuVoidsTVC];
    [self.view addSubview:self.skuVoidsTVC.view];
    [self.skuVoidsTVC didMoveToParentViewController:self];
    self.lblAlertName.text=[NSString stringWithFormat:@"%@",[SIBaseLogic alertEnumToString:SKUVOIDS]];

}



-(void)loadMissingSKUSAlerts{
    

    [self dismissChildViewControllers];
    [self setConstraintsforButtonInfo:NO];
    selectedAlertType=MISSINGSKUSINPOG;
    self.missingSKUs.isActionedAlert=searchTypeSelected;
    self.missingSKUs.delegate = self;
    [self.missingSKUs loadMissingSKUData];
   
    [self addChildViewController:self.missingSKUs];
    [self.view addSubview:self.missingSKUs.view];

    [self.missingSKUs didMoveToParentViewController:self];
    self.lblAlertName.text=[NSString stringWithFormat:@"%@",[SIBaseLogic alertEnumToString:MISSINGSKUSINPOG]];

    
}


-(void)loadInnovationAlerts{

    [self dismissChildViewControllers];
    self.innovationVC.isActionedAlert=searchTypeSelected;
    self.innovationVC.delegate = self;
    [self setConstraintsforButtonInfo:NO];
    selectedAlertType=INNOVATION;
    [self.innovationVC loadInnovationData];

    [self addChildViewController:self.innovationVC];
    [self.view addSubview:self.innovationVC.view];
    [self.innovationVC didMoveToParentViewController:self];

    self.lblAlertName.text=[NSString stringWithFormat:@"%@",[SIBaseLogic alertEnumToString:INNOVATION]];
    
}

-(void)loadPurePlayAlerts{
    

    [self dismissChildViewControllers];
    [self setConstraintsforButtonInfo:NO];
    selectedAlertType=PUREPLAY;
    self.pureplayVC.isActionedAlert=searchTypeSelected;
    self.pureplayVC.delegate = self;
    [self.pureplayVC loadPurePlayData];
    
    [self addChildViewController:self.pureplayVC];
    [self.view addSubview:self.pureplayVC.view];
    [self.pureplayVC didMoveToParentViewController:self];
    self.lblAlertName.text=[NSString stringWithFormat:@"%@",[SIBaseLogic alertEnumToString:PUREPLAY]];

}


-(void)setConstraintsforButtonInfo:(BOOL)isSKUVoids{
    
    if (isSKUVoids)
    {
        self.constraintHorSpaceInfo.constant = 24;
        [self.btnCalculator setUserInteractionEnabled:YES];
        [self.btnCalculator setHidden:NO];
    }else{
        self.constraintHorSpaceInfo.constant = -25;
        [self.btnCalculator setUserInteractionEnabled:NO];
        [self.btnCalculator setHidden:YES];
    }
    
}

-(void)dismissChildViewControllers{
    
    for (UIViewController *viewControllerObject in self.childViewControllers) {
        
        if([viewControllerObject isKindOfClass:[SISkuVoidsController class]] || [viewControllerObject isKindOfClass:[SIInnovationController class]] || [viewControllerObject isKindOfClass:[SIPurePlayController class]] || [viewControllerObject isKindOfClass:[SIInnovationController class]])
        {
            [viewControllerObject willMoveToParentViewController:nil];
            [viewControllerObject.view removeFromSuperview];
            [viewControllerObject removeFromParentViewController];
            
        }
    }
}


#pragma mark-tableview delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [arrayMenuAlerts count];
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SIAlertListCell *cell = (SIAlertListCell *)[tableView dequeueReusableCellWithIdentifier:@"SIAlertListCell" forIndexPath:indexPath];
    
    
    cell.lblAlertList.text = arrayMenuAlerts[indexPath.row];
    cell.lblAlertCount.text = [alertsCountDictionary objectForKey:arrayMenuAlertTypes[indexPath.row]];
    cell.lblAlertList.textColor = [UIColor blackColor];
    cell.lblAlertCount.textColor = [UIColor blackColor];
    cell.backgroundColor=[UIColor clearColor];
    cell.layer.borderWidth=0.0f;
    
    
    cell.layer.masksToBounds=NO;
    
    if (selectedAlertType==MISSINGSKUSINPOG && [cell.lblAlertList.text isEqualToString:kMissingSKUPOG]) {
        
        cell.layer.masksToBounds=YES;
        cell.lblAlertList.textColor = [UIColor whiteColor];
        cell.lblAlertCount.textColor = [UIColor whiteColor];
        cell.backgroundColor=kSelectedColor;
    }
    else if(selectedAlertType==SKUVOIDS && [cell.lblAlertList.text isEqualToString:kSKUVoids]) {
        
        cell.layer.masksToBounds=YES;
        cell.lblAlertList.textColor = [UIColor whiteColor];
        cell.lblAlertCount.textColor = [UIColor whiteColor];
        cell.backgroundColor=kSelectedColor;
    }
    else if(selectedAlertType==INNOVATION && [cell.lblAlertList.text isEqualToString:kInnovationName]) {
        
        cell.layer.masksToBounds=YES;
        cell.lblAlertList.textColor = [UIColor whiteColor];
        cell.lblAlertCount.textColor = [UIColor whiteColor];
        cell.backgroundColor=kSelectedColor;
        
    }
    else if(selectedAlertType==PUREPLAY && [cell.lblAlertList.text isEqualToString:kPurePlayName]) {
        
        cell.layer.masksToBounds=YES;
        cell.lblAlertList.textColor = [UIColor whiteColor];
        cell.lblAlertCount.textColor = [UIColor whiteColor];
        cell.backgroundColor=kSelectedColor;
    }
    
    return cell;
}

#pragma mark-tableview delegate




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([arrayMenuAlerts[indexPath.row] isEqualToString:kMissingSKUPOG]) {
        
        selectedAlertType=MISSINGSKUSINPOG;
        [self loadMissingSKUSAlerts];

    }
    else if ([arrayMenuAlerts[indexPath.row] isEqualToString:kSKUVoids])
    {
        selectedAlertType=SKUVOIDS;

        [self loadSkuAlerts];
    }
    
    else if ([arrayMenuAlerts[indexPath.row] isEqualToString:kInnovationName])
    {
        selectedAlertType=INNOVATION;
        [self loadInnovationAlerts];
    }
    else if ([arrayMenuAlerts[indexPath.row] isEqualToString:kPurePlayName])
    {
        selectedAlertType=PUREPLAY;
        [self loadPurePlayAlerts];
    }
    
    [SellingIntelligence sharedSellingIntelligenceClass].selectedAlertType=selectedAlertType;
    [tableViewAlertsMenu reloadData];
    
    
}


@end
