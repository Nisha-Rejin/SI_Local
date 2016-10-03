//
//  SIMissingSKUsController.m
//  SellingIntelligence
//
//  Created by Sailesh on 28/10/15.
//  Copyright (c) 2015 Cognizant. All rights reserved.
//

#import "SIBaseLogic.h"
#import "SIMissingSKUsController.h"

#define URLSESSION_TIMEOUT_PERIOD 60.0
#define URLSESSION_MAX_CONNECTIONS 10

@interface SIMissingSKUsController ()<NSURLSessionDelegate,NSURLSessionTaskDelegate,NSURLSessionDataDelegate>

@property (strong, nonatomic) NSURLSession *session;

@end

@implementation SIMissingSKUsController
@synthesize missingSKUAlertsArray,delegate;

- (void)viewDidLoad {
    
    
    
    [super viewDidLoad];
    [self setUpInitialView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setUpInitialView{
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    NSURLSessionConfiguration *sessionconfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    sessionconfig.timeoutIntervalForRequest = URLSESSION_TIMEOUT_PERIOD;
    sessionconfig. HTTPMaximumConnectionsPerHost = URLSESSION_MAX_CONNECTIONS;
    self.session = [NSURLSession sessionWithConfiguration:sessionconfig delegate:self delegateQueue:nil];
    
    self.selectedAlertType=MISSINGSKUSINPOG;
    
}

-(void)loadMissingSKUData{
    [self.delegate hideSubmitButton];

    missingSKUAlertsArray=[NSMutableArray array];
    
    missingSKUAlertsArray= [[SIBaseLogic sharedSIBaseLogic]fetchAlertsOfType:MISSINGSKUSINPOG forActioned:self.isActionedAlert];
    [SellingIntelligence sharedSellingIntelligenceClass].selectedAlertType=MISSINGSKUSINPOG;

    [self.tableViewMissingSkuVoids reloadData];

}


- (BOOL)disablesAutomaticKeyboardDismissal {
    return NO;
}

#pragma mark - Table view data source


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [missingSKUAlertsArray count];
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (self.isActionedAlert==Open) {
        SIMissingSKUHeader *cell=(SIMissingSKUHeader *)[tableView dequeueReusableCellWithIdentifier:@"MissingHeader"];
        return cell;
    }
    else
    {
        SIMissingSKUActionHeaderCell *cell=(SIMissingSKUActionHeaderCell *)[tableView dequeueReusableCellWithIdentifier:@"MissingSkuActionHeader"];
        return cell;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 60.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.isActionedAlert==Open) {
        
        SIMissingSKUCell *cell=(SIMissingSKUCell *)[tableView dequeueReusableCellWithIdentifier:@"MissingSKUCell"];
        
        
        NSMutableDictionary *missingSkuDict=[NSMutableDictionary dictionaryWithDictionary:[missingSKUAlertsArray objectAtIndex:indexPath.row]];
        NSString *altUpc = nil;
        altUpc = [[missingSKUAlertsArray objectAtIndex:indexPath.row] objectForKey:kAltUPC];

        cell.lblSKUName.text=[missingSkuDict objectForKey:kSkuName];
        
        cell.btnNO.tag=indexPath.row+1000;
        cell.btnYes.tag=indexPath.row+1;
        cell.tag = indexPath.row;
        
        NSString * actionTaken =[missingSkuDict objectForKey:kActionedFlag];
        
        
        //code by Nisha
        NSString * isYesbuttonEnabled =[missingSkuDict objectForKey:kYesActionEnabled];
        if ([isYesbuttonEnabled isEqualToString:kYes]) {
            cell.btnYes.hidden = NO;
        }
        else {
            cell.btnYes.hidden = YES;
        }
        NSString * isNobuttonEnabled =[missingSkuDict objectForKey:kNoActionEnabled];
        if ([isNobuttonEnabled isEqualToString:kYes]) {
            cell.btnNO.hidden = NO;
        }
        else {
            cell.btnNO.hidden = YES;
        }
        ///////
        
        [cell.btnYes setImage:[UIImage imageNamed:@"Yes-gray" inBundle:[SIBaseLogic libraryBundlePath] compatibleWithTraitCollection:nil] forState:UIControlStateSelected];
        [cell.btnNO setImage:[UIImage imageNamed:@"No-gray" inBundle:[SIBaseLogic libraryBundlePath] compatibleWithTraitCollection:nil] forState:UIControlStateSelected];
        
        if ([actionTaken isEqualToString:kYes]) {
            
            cell.btnYes.selected=YES;
            [cell.btnYes setImage:[UIImage imageNamed:@"yes-green" inBundle:[SIBaseLogic libraryBundlePath] compatibleWithTraitCollection:nil] forState:UIControlStateSelected];
            
            
        }
        else  if([actionTaken isEqualToString:kNo]){
            
            cell.btnNO.selected=YES;
            [cell.btnNO setImage:[UIImage imageNamed:@"no-red" inBundle:[SIBaseLogic libraryBundlePath] compatibleWithTraitCollection:nil] forState:UIControlStateSelected];
            
            
        }
        
        [cell.btnNO addTarget:self action:@selector(takeActionNo:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnYes addTarget:self action:@selector(takeActionYes:) forControlEvents:UIControlEventTouchUpInside];
        
        UIImage *img = [SIUtiliesController getAlertImageFromDirectory:altUpc];
        cell.imgVwSku.image = [UIImage imageNamed:@"default-product1.png" inBundle:[SIBaseLogic libraryBundlePath] compatibleWithTraitCollection:nil];
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
                                                                               cell.imgVwSku.image = image;
                                                                               [cell setNeedsDisplay];
                                                                           } completion:^(BOOL finished) {
                                                                               [SIUtiliesController saveProductImageToDocumentDirectory:imgData fileName:altUpc];
                                                                           }];
                                                                       }
                                                                       
                                                                   });
                                                               }else{
                                                                   if (cell.tag == indexPath.row) {
                                                                       cell.imgVwSku.image = [UIImage imageNamed:@"default-product1.png" inBundle:[SIBaseLogic libraryBundlePath] compatibleWithTraitCollection:nil];
                                                                       [cell setNeedsDisplay];
                                                                   }
                                                               }
                                                           }];
            
            // 4
            [downloadPhotoTask resume];
            
            
        }else{
            if (cell.tag == indexPath.row) {
                cell.imgVwSku.image = img;
                [cell setNeedsDisplay];
            }
        }
        
        return cell;
    }
    else
    {
        SIMissingSkuActionCell *cell=(SIMissingSkuActionCell *)[tableView dequeueReusableCellWithIdentifier:@"SkuMissingAction"];
        
        NSString *altUpc = nil;
        NSMutableDictionary *missingSkuDict=[NSMutableDictionary dictionaryWithDictionary:[missingSKUAlertsArray objectAtIndex:indexPath.row]];

        cell.lblSkuName.text=[missingSkuDict objectForKey:kSkuName];
        cell.lblStatus.text=[missingSkuDict objectForKey:kActionedDate];
        cell.lblTakenBy.text = [missingSkuDict objectForKey:kGPID];
        cell.tag = indexPath.row;
        
        NSString * actionTaken =[missingSkuDict objectForKey:kActionedFlag];
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
        cell.imgViewSkuName.image = [UIImage imageNamed:@"default-product1.png" inBundle:[SIBaseLogic libraryBundlePath] compatibleWithTraitCollection:nil];
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
                                                                               cell.imgViewSkuName.image = image;
                                                                               [cell setNeedsDisplay];
                                                                           } completion:^(BOOL finished) {
                                                                               [SIUtiliesController saveProductImageToDocumentDirectory:imgData fileName:altUpc];
                                                                           }];
                                                                       }
                                                                       
                                                                   });
                                                               }else{
                                                                   if (cell.tag == indexPath.row) {
                                                                       cell.imgViewSkuName.image = [UIImage imageNamed:@"default-product1.png" inBundle:[SIBaseLogic libraryBundlePath] compatibleWithTraitCollection:nil];
                                                                       [cell setNeedsDisplay];
                                                                   }
                                                               }
                                                           }];
            
            // 4
            [downloadPhotoTask resume];
            
            
        }else{
            if (cell.tag == indexPath.row) {
                cell.imgViewSkuName.image = img;
                [cell setNeedsDisplay];
            }
        }

        return cell;
        
        
    }
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.view endEditing:YES];
    
}

#pragma mark - nsurl session delegate

//- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *credential))completionHandler
//{
//    completionHandler(NSURLSessionAuthChallengeUseCredential, [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust]);
//}

#pragma mark-take Actions

-(void)takeActionYes:(UIButton *)sender{
    
    if (sender.selected)
    {
        for (NSIndexPath *path in [self.tableViewMissingSkuVoids indexPathsForVisibleRows]) {
            
            
            NSMutableDictionary *missingSkuDict=[NSMutableDictionary dictionaryWithDictionary:[missingSKUAlertsArray objectAtIndex:path.row]];
            if (sender.tag==path.row+1)
            [SIBaseLogic updateAlertsfor:MISSINGSKUSINPOG withParameter:[missingSkuDict objectForKey:kUPC] toActionedFlag:@"NA" andVersion:[missingSkuDict objectForKey:kVersion]];
        }
        [sender setImage:[UIImage imageNamed:@"Yes-gray" inBundle:[SIBaseLogic libraryBundlePath] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
        sender.selected=NO;
    }
    else
    {
        [sender setImage:[UIImage imageNamed:@"yes-green" inBundle:[SIBaseLogic libraryBundlePath] compatibleWithTraitCollection:nil] forState:UIControlStateSelected];
        sender.selected=YES;
        
        for (NSIndexPath *path in [self.tableViewMissingSkuVoids indexPathsForVisibleRows]) {
            
            NSMutableDictionary *missingSkuDict=[NSMutableDictionary dictionaryWithDictionary:[missingSKUAlertsArray objectAtIndex:path.row]];
            
            
            
            SIMissingSKUCell *cell=(SIMissingSKUCell *)[self.tableViewMissingSkuVoids cellForRowAtIndexPath:path];
            

            if (sender.tag==path.row+1) {
                [cell.btnNO setImage:[UIImage imageNamed:@"No-gray" inBundle:[SIBaseLogic libraryBundlePath] compatibleWithTraitCollection:nil] forState:UIControlStateSelected];
                cell.btnNO.selected = NO;
                [SIBaseLogic updateAlertsfor:MISSINGSKUSINPOG withParameter:[missingSkuDict objectForKey:kUPC] toActionedFlag:kYes andVersion:[missingSkuDict objectForKey:kVersion]];

            }
            
        }
        
    }
    [self loadMissingSKUData];

}

-(void)takeActionNo:(UIButton *)sender{
    
    if (sender.selected)
    {
        [sender setImage:[UIImage imageNamed:@"No-gray" inBundle:[SIBaseLogic libraryBundlePath] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
        sender.selected=NO;
        for (NSIndexPath *path in [self.tableViewMissingSkuVoids indexPathsForVisibleRows]) {
            
            NSMutableDictionary *missingSkuDict=[NSMutableDictionary dictionaryWithDictionary:[missingSKUAlertsArray objectAtIndex:path.row]];
            
            if (sender.tag==path.row+1000)
            [SIBaseLogic updateAlertsfor:MISSINGSKUSINPOG withParameter:[missingSkuDict objectForKey:kUPC] toActionedFlag:@"NA" andVersion:[missingSkuDict objectForKey:kVersion]];
        }
        
    }
    else
    {
        [sender setImage:[UIImage imageNamed:@"no-red" inBundle:[SIBaseLogic libraryBundlePath] compatibleWithTraitCollection:nil] forState:UIControlStateSelected];
        sender.selected=YES;
        
        for (NSIndexPath *path in [self.tableViewMissingSkuVoids indexPathsForVisibleRows]) {
            NSMutableDictionary *missingSkuDict=[NSMutableDictionary dictionaryWithDictionary:[missingSKUAlertsArray objectAtIndex:path.row]];
            
            SIMissingSKUCell *cell=(SIMissingSKUCell *)[self.tableViewMissingSkuVoids cellForRowAtIndexPath:path];
            
            
            if (sender.tag==path.row+1000) {
                [cell.btnYes setImage:[UIImage imageNamed:@"No-gray" inBundle:[SIBaseLogic libraryBundlePath] compatibleWithTraitCollection:nil] forState:UIControlStateSelected];
                cell.btnYes.selected = NO;
                [SIBaseLogic updateAlertsfor:MISSINGSKUSINPOG withParameter:[missingSkuDict objectForKey:kUPC] toActionedFlag:kNo andVersion:[missingSkuDict objectForKey:kVersion]];
            }
            
        }
    }
    [self loadMissingSKUData];

}



@end