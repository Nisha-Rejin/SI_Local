//
//  SIInnovationAndPureplayController.h
//  Selling Intelligence
//
//  Created by Sailesh on 30/09/15.
//  Copyright (c) 2015 Cognizant. All rights reserved.
//


#import "SIInnovationController.h"
#import "SIBaseLogic.h"

#define URLSESSION_TIMEOUT_PERIOD 60.0
#define URLSESSION_MAX_CONNECTIONS 10

@interface SIInnovationController ()<NSURLSessionDelegate,NSURLSessionTaskDelegate,NSURLSessionDataDelegate>
@property (strong, nonatomic) NSURLSession *session;
@end

@implementation SIInnovationController
@synthesize selectedAlertType,innovationAlertsArray,delegate;


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpInitialVIew];
    
    // Do any additional setup after loading the view.
}


-(void)setUpInitialVIew{
    
    NSURLSessionConfiguration *sessionconfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    sessionconfig.timeoutIntervalForRequest = URLSESSION_TIMEOUT_PERIOD;
    sessionconfig. HTTPMaximumConnectionsPerHost = URLSESSION_MAX_CONNECTIONS;
    self.session = [NSURLSession sessionWithConfiguration:sessionconfig delegate:self delegateQueue:nil];
    
    self.selectedAlertType=INNOVATION;

}

-(void)loadInnovationData{
    [self.delegate hideSubmitButton];

    innovationAlertsArray =[NSMutableArray array];

    innovationAlertsArray =  [[SIBaseLogic sharedSIBaseLogic]fetchAlertsOfType:INNOVATION forActioned:self.isActionedAlert];
    [SellingIntelligence sharedSellingIntelligenceClass].selectedAlertType=INNOVATION;

    [self.tableViewInnovationAndPurePlay reloadData];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark - Table view Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
        return [innovationAlertsArray count];
}



- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    
    if(self.isActionedAlert==Open)
    {
        SIInnovationHeaderCell *cell=(SIInnovationHeaderCell *)[tableView dequeueReusableCellWithIdentifier:@"InnovationHeader"];
        return cell;
    }
    else
    {
        SIInnovationHeader *cell=(SIInnovationHeader *)[tableView dequeueReusableCellWithIdentifier:@"InnovationAndPurePlayActionHeader"];
        return cell;
        
    }
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 60.0f;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(self.isActionedAlert==Open)
    {
        
        SIInnovationDetailCell *cell=(SIInnovationDetailCell *)[tableView dequeueReusableCellWithIdentifier:@"InnovationCell"];
        NSString *altUpc = nil;
        
        NSMutableDictionary *innovationDict=[NSMutableDictionary dictionaryWithDictionary:[innovationAlertsArray objectAtIndex:indexPath.row]];
        
        altUpc = [[innovationAlertsArray objectAtIndex:indexPath.row] objectForKey:kAltUPC];
        
        cell.labelSkuName.text=[innovationDict objectForKey:kSkuName];
        cell.labelEndDate.text=[innovationDict objectForKey:kInnovationEndDate];
        cell.labelStartDate.text=[innovationDict objectForKey:kInnovationStartDate];
        
        NSString * actionTaken =[innovationDict objectForKey:kActionedFlag];
        
        //code by Nisha
        NSString * isYesbuttonEnabled =[innovationDict objectForKey:kYesActionEnabled];
        if ([isYesbuttonEnabled isEqualToString:kYes]) {
            cell.btnYes.hidden = NO;
        }
        else {
            cell.btnYes.hidden = YES;
        }
        NSString * isNobuttonEnabled =[innovationDict objectForKey:kNoActionEnabled];
        if ([isNobuttonEnabled isEqualToString:kYes]) {
            cell.btnNo.hidden = NO;
        }
        else {
            cell.btnNo.hidden = YES;
        }
        ///////
        
        [cell.btnYes setImage:[UIImage imageNamed:@"Yes-gray" inBundle:[SIBaseLogic libraryBundlePath] compatibleWithTraitCollection:nil] forState:UIControlStateSelected];
        [cell.btnNo setImage:[UIImage imageNamed:@"No-gray" inBundle:[SIBaseLogic libraryBundlePath] compatibleWithTraitCollection:nil] forState:UIControlStateSelected];

        if ([actionTaken isEqualToString:kYes]) {
            
            cell.btnYes.selected=YES;
            
            [cell.btnYes setImage:[UIImage imageNamed:@"yes-green" inBundle:[SIBaseLogic libraryBundlePath] compatibleWithTraitCollection:nil] forState:UIControlStateSelected];
            
        }
        else  if([actionTaken isEqualToString:kNo]){
            
            cell.btnNo.selected=YES;
            [cell.btnNo setImage:[UIImage imageNamed:@"no-red" inBundle:[SIBaseLogic libraryBundlePath] compatibleWithTraitCollection:nil] forState:UIControlStateSelected];
            
        }
        
        cell.btnNo.tag=indexPath.row+1000;
        cell.btnYes.tag=indexPath.row+1;
        cell.tag = indexPath.row;
        
        [cell.btnNo addTarget:self action:@selector(takeActionNo:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnYes addTarget:self action:@selector(takeActionYes:) forControlEvents:UIControlEventTouchUpInside];
        
        UIImage *img = [SIUtiliesController getAlertImageFromDirectory:altUpc];
        cell.imgViewProduct.image = [UIImage imageNamed:@"default-product1.png" inBundle:[SIBaseLogic libraryBundlePath] compatibleWithTraitCollection:nil];
        if(img == nil){
            
            
            //1
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@.png",[SIUtiliesController getProductCatalogueImageDownloadPath],altUpc]];
            
            // 2
            NSURLSessionDownloadTask *downloadPhotoTask = [self.session
                                                           downloadTaskWithURL:url completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
                                                               // 3
                                                               NSData *imgData = [NSData dataWithContentsOfURL:location];
                                                                UIImage *image = [UIImage imageWithData:
                                                                                           imgData];
                                                               if (image) {
                                                                   dispatch_async(dispatch_get_main_queue(), ^{
                                                                       if (cell.tag == indexPath.row) {
                                                                           [UIView transitionWithView:cell duration:0.5f options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                                                                               cell.imgViewProduct.image = image;
                                                                               [cell setNeedsLayout];
                                                                           } completion:^(BOOL finished) {
                                                                               [SIUtiliesController saveProductImageToDocumentDirectory:imgData fileName:altUpc];
                                                                           }];
                                                                       }
                                                                       
                                                                   });
                                                               }else{
                                                                   if (cell.tag == indexPath.row) {
                                                                       cell.imgViewProduct.image = [UIImage imageNamed:@"default-product1.png" inBundle:[SIBaseLogic libraryBundlePath] compatibleWithTraitCollection:nil];
                                                                       [cell setNeedsLayout];
                                                                   }
                                                                   
                                                               }
                                                           }];
            
            // 4	
            [downloadPhotoTask resume];

        }else{
            if (cell.tag == indexPath.row) {
                cell.imgViewProduct.image = img;
                [cell setNeedsLayout];
            }
        }
        return cell;
    }
    else
    {
        SIInnovationsActionCell *cell=(SIInnovationsActionCell *)[tableView dequeueReusableCellWithIdentifier:@"InnovationandPurePlayAction"];
        
        NSString *altUpc = nil;
        
        
        
        NSMutableDictionary *innovationDict=[NSMutableDictionary dictionaryWithDictionary:[innovationAlertsArray objectAtIndex:indexPath.row]];
        
        altUpc = [[innovationAlertsArray objectAtIndex:indexPath.row] objectForKey:kAltUPC];
        
        cell.lblSKUName.text=[innovationDict objectForKey:kSkuName];
        cell.lblActionDate.text=[innovationDict objectForKey:kActionedDate];
        cell.lblInnovationGPID.text = [innovationDict objectForKey:kGPID];
        cell.tag = indexPath.row;
        
        NSString * actionTaken =[innovationDict objectForKey:kActionedFlag];
        if ([actionTaken isEqualToString:kYes]) {
            cell.lblActionTaken.text=@"Yes";
            cell.lblActionTaken.textColor=[UIColor greenColor];
            
        }
        else  if([actionTaken isEqualToString:kNo])
        {
            cell.lblActionTaken.text=@"No";
            cell.lblActionTaken.textColor=[UIColor redColor];
        }
        
        UIImage *img = [SIUtiliesController getAlertImageFromDirectory:altUpc];
        cell.imgViewSKUName.image = [UIImage imageNamed:@"default-product1.png" inBundle:[SIBaseLogic libraryBundlePath] compatibleWithTraitCollection:nil];
        if(img == nil){

            //1
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@.png",[SIUtiliesController getProductCatalogueImageDownloadPath],altUpc]];
            
            // 2
            NSURLSessionDownloadTask *downloadPhotoTask = [self.session
                                                           downloadTaskWithURL:url completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
                                                               NSData *imgData = [NSData dataWithContentsOfURL:location];
                                                               UIImage *image = [UIImage imageWithData:
                                                                                 imgData];
                                                               if (image) {
                                                                   dispatch_async(dispatch_get_main_queue(), ^{
                                                                       if (cell.tag == indexPath.row) {
                                                                           [UIView transitionWithView:cell duration:0.5f options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                                                                               cell.imgViewSKUName.image = image;
                                                                               [cell setNeedsLayout];
                                                                           } completion:^(BOOL finished) {
                                                                               [SIUtiliesController saveProductImageToDocumentDirectory:imgData fileName:altUpc];
                                                                           }];
                                                                       }
                                                                   });
                                                               }else{
                                                                   if (cell.tag == indexPath.row) {
                                                                       cell.imgViewSKUName.image = [UIImage imageNamed:@"default-product1.png" inBundle:[SIBaseLogic libraryBundlePath] compatibleWithTraitCollection:nil];
                                                                       [cell setNeedsDisplay];
                                                                   }
                                                               }

                                                               
                                                           }];
            
            // 4	
            [downloadPhotoTask resume];
            
            
            
        }else{
             if (cell.tag == indexPath.row) {
                cell.imgViewSKUName.image = img;
                [cell setNeedsDisplay];
             }
        }
        
        return cell;
    }
    
    return nil;
}

#pragma mark - nsurl session delegate

//- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *credential))completionHandler
//{
//    completionHandler(NSURLSessionAuthChallengeUseCredential, [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust]);
//}

#pragma mark - TakeActions


-(void)takeActionYes:(UIButton *)sender{
    
    if (sender.selected)
    {
        [sender setImage:[UIImage imageNamed:@"Yes-gray" inBundle:[SIBaseLogic libraryBundlePath] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
        sender.selected=NO;
        
        for (NSIndexPath *path in [self.tableViewInnovationAndPurePlay indexPathsForVisibleRows]) {
            
            
            NSMutableDictionary *innovationDict=[NSMutableDictionary dictionaryWithDictionary:[innovationAlertsArray objectAtIndex:path.row]];
           
            if (sender.tag==path.row+1)
            [SIBaseLogic updateAlertsfor:INNOVATION withParameter:[innovationDict objectForKey:kUPC] toActionedFlag:@"NA" andVersion:[innovationDict objectForKey:kVersion]];
            
        }
        
    }
    else
    {
        [sender setImage:[UIImage imageNamed:@"yes-green" inBundle:[SIBaseLogic libraryBundlePath] compatibleWithTraitCollection:nil] forState:UIControlStateSelected];
        sender.selected=YES;
        
        for (NSIndexPath *path in [self.tableViewInnovationAndPurePlay indexPathsForVisibleRows]) {
            
            
            NSMutableDictionary *innovationDict=[NSMutableDictionary dictionaryWithDictionary:[innovationAlertsArray objectAtIndex:path.row]];
            
            
            SIInnovationDetailCell *cell = (SIInnovationDetailCell *)[self.tableViewInnovationAndPurePlay cellForRowAtIndexPath:path];
            
                if (sender.tag==path.row+1){
                [cell.btnNo setImage:[UIImage imageNamed:@"No-gray" inBundle:[SIBaseLogic libraryBundlePath] compatibleWithTraitCollection:nil] forState:UIControlStateSelected];
                cell.btnNo.selected = NO;
                [SIBaseLogic updateAlertsfor:INNOVATION withParameter:[innovationDict objectForKey:kUPC] toActionedFlag:kYes andVersion:[innovationDict objectForKey:kVersion]];
            }
            
            
        }
    }

    [self loadInnovationData];

}

-(void)takeActionNo:(UIButton *)sender{
    if (sender.selected)
    {
        [sender setImage:[UIImage imageNamed:@"No-gray" inBundle:[SIBaseLogic libraryBundlePath] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
        sender.selected=NO;
        
        for (NSIndexPath *path in [self.tableViewInnovationAndPurePlay indexPathsForVisibleRows]) {
            
            
            NSMutableDictionary *innovationDict=[NSMutableDictionary dictionaryWithDictionary:[innovationAlertsArray objectAtIndex:path.row]];
            
            if (sender.tag==path.row+1000)
            [SIBaseLogic updateAlertsfor:INNOVATION withParameter:[innovationDict objectForKey:kUPC] toActionedFlag:@"NA" andVersion:[innovationDict objectForKey:kVersion]];
        }
        
    }
    else
    {
        [sender setImage:[UIImage imageNamed:@"no-red" inBundle:[SIBaseLogic libraryBundlePath] compatibleWithTraitCollection:nil] forState:UIControlStateSelected];
        sender.selected=YES;
        
        for (NSIndexPath *path in [self.tableViewInnovationAndPurePlay indexPathsForVisibleRows]) {
            
            
            NSMutableDictionary *innovationDict=[NSMutableDictionary dictionaryWithDictionary:[innovationAlertsArray objectAtIndex:path.row]];
            
          
            SIInnovationDetailCell *cell = (SIInnovationDetailCell *)[self.tableViewInnovationAndPurePlay cellForRowAtIndexPath:path];
            
            if (sender.tag==path.row+1000){
                [cell.btnYes setImage:[UIImage imageNamed:@"No-gray" inBundle:[SIBaseLogic libraryBundlePath] compatibleWithTraitCollection:nil] forState:UIControlStateSelected];
                cell.btnYes.selected = NO;
                  [SIBaseLogic updateAlertsfor:INNOVATION withParameter:[innovationDict objectForKey:kUPC] toActionedFlag:kNo andVersion:[innovationDict objectForKey:kVersion]];
            }
            
            
        }
        
        
    }

    [self loadInnovationData];
    
}



@end
