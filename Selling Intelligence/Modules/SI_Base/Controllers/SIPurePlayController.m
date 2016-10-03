//
//  SIPurePlayController.m
//  SellingIntelligence
//
//  Created by Sailesh on 28/10/15.
//  Copyright (c) 2015 Cognizant. All rights reserved.
//

#import "SIPurePlayController.h"

#define URLSESSION_TIMEOUT_PERIOD 60.0
#define URLSESSION_MAX_CONNECTIONS 10



@interface SIPurePlayController ()<NSURLSessionDelegate,NSURLSessionTaskDelegate,NSURLSessionDataDelegate>

@property (strong, nonatomic) NSURLSession *session;

@end

@implementation SIPurePlayController

@synthesize selectedAlertType,purePlayAlertsArray,delegate;


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
    self.selectedAlertType=PUREPLAY;
}

-(void)loadPurePlayData{
    purePlayAlertsArray=[NSMutableArray array];
    [self.delegate hideSubmitButton];
    purePlayAlertsArray= [[SIBaseLogic sharedSIBaseLogic]fetchAlertsOfType:PUREPLAY forActioned:self.isActionedAlert];
    [SellingIntelligence sharedSellingIntelligenceClass].selectedAlertType=PUREPLAY;

    [self.tableViewPurePlay reloadData];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark - Table view Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [purePlayAlertsArray count];
}



- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    
    if(self.isActionedAlert==Open)
    {
        
        SIPurePlayHeaderCell *cell=(SIPurePlayHeaderCell *)[tableView dequeueReusableCellWithIdentifier:@"PurePlayHeader"];
        return cell;
    }
    else
    {
        SIPurePlayActionHeaderCell *cell=(SIPurePlayActionHeaderCell *)[tableView dequeueReusableCellWithIdentifier:@"PurePlayActionHeader"];
        return cell;
        
    }
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 60.0f;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(self.isActionedAlert==Open)
    {
        SIPurePlayCell *cell=(SIPurePlayCell *)[tableView dequeueReusableCellWithIdentifier:@"PurePlayCell"];
        
        NSString *imgId = nil;
        
        NSMutableDictionary *purePlayDict=[NSMutableDictionary dictionaryWithDictionary:[purePlayAlertsArray objectAtIndex:indexPath.row]];
        
        imgId = [[purePlayAlertsArray objectAtIndex:indexPath.row] objectForKey:kImageId];
        
        cell.labelPurePlay.text=[purePlayDict objectForKey:kQuestionDescription];
        NSString * actionTaken =[purePlayDict objectForKey:kActionedFlag];
        
        
        //code by Nisha
        NSString * isYesbuttonEnabled =[purePlayDict objectForKey:kYesActionEnabled];
        if ([isYesbuttonEnabled isEqualToString:kYes]) {
            cell.btnPPYes.hidden = NO;
        }
        else {
            cell.btnPPYes.hidden = YES;
        }
        NSString * isNobuttonEnabled =[purePlayDict objectForKey:kNoActionEnabled];
        if ([isNobuttonEnabled isEqualToString:kYes]) {
            cell.btnPPNo.hidden = NO;
        }
        else {
            cell.btnPPNo.hidden = YES;
        }
        ///////
        [cell.btnPPYes setImage:[UIImage imageNamed:@"Yes-gray" inBundle:[SIBaseLogic libraryBundlePath] compatibleWithTraitCollection:nil] forState:UIControlStateSelected];
        [cell.btnPPNo setImage:[UIImage imageNamed:@"No-gray" inBundle:[SIBaseLogic libraryBundlePath] compatibleWithTraitCollection:nil] forState:UIControlStateSelected];
        
        if ([actionTaken isEqualToString:kYes]) {
            
            cell.btnPPYes.selected=YES;
            
            [cell.btnPPYes setImage:[UIImage imageNamed:@"yes-green" inBundle:[SIBaseLogic libraryBundlePath] compatibleWithTraitCollection:nil] forState:UIControlStateSelected];
            
        }
        else  if([actionTaken isEqualToString:kNo]){
            
            cell.btnPPNo.selected=YES;
            [cell.btnPPNo setImage:[UIImage imageNamed:@"no-red" inBundle:[SIBaseLogic libraryBundlePath] compatibleWithTraitCollection:nil] forState:UIControlStateSelected];
            
        }
        
        cell.btnPPNo.tag=indexPath.row+1000;
        cell.btnPPYes.tag=indexPath.row+1;
        cell.tag = indexPath.row;
        
        [cell.btnPPNo addTarget:self action:@selector(takeActionNo:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnPPYes addTarget:self action:@selector(takeActionYes:) forControlEvents:UIControlEventTouchUpInside];
        
        UIImage *img = [SIUtiliesController getAlertImageFromDirectory:imgId];
        cell.imgViewPurePlay.image = [UIImage imageNamed:@"default-product1.png" inBundle:[SIBaseLogic libraryBundlePath] compatibleWithTraitCollection:nil];
        if(img == nil){
            
            //1
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?%@=%@",[SIUtiliesController getPurePlayImageDownloadPath],kPurePlayImageId,imgId]];
            
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
                                                                               cell.imgViewPurePlay.image = image;
                                                                               [cell setNeedsDisplay];
                                                                           } completion:^(BOOL finished) {
                                                                               [SIUtiliesController saveProductImageToDocumentDirectory:imgData fileName:imgId];
                                                                           }];
                                                                           
                                                                       }
                                                                   });
                                                               }else{
                                                                   if (cell.tag == indexPath.row) {
                                                                       cell.imgViewPurePlay.image = [UIImage imageNamed:@"default-product1.png" inBundle:[SIBaseLogic libraryBundlePath] compatibleWithTraitCollection:nil];
                                                                       [cell setNeedsDisplay];
                                                                   }
                                                               }
                                                           }];
            
            // 4
            [downloadPhotoTask resume];
            
            
            
        }else{
            if (cell.tag == indexPath.row) {
                cell.imgViewPurePlay.image = img;
                [cell setNeedsDisplay];
            }
        }
        
        return cell;
    }
    else
    {
        SIPurePlayActionCell *cell=(SIPurePlayActionCell *)[tableView dequeueReusableCellWithIdentifier:@"PurePlayAction"];
        
        NSString *imgId = nil;
        
        NSMutableDictionary *purePlayDict=[NSMutableDictionary dictionaryWithDictionary:[purePlayAlertsArray objectAtIndex:indexPath.row]];
        
        imgId = [[purePlayAlertsArray objectAtIndex:indexPath.row] objectForKey:kImageId];
        
        cell.lblSKUName.text=[purePlayDict objectForKey:kQuestionDescription];
        cell.lblPurePlayActionTaken.text = [purePlayDict objectForKey:kGPID];
        cell.lblActionedDate.text = [purePlayDict objectForKey:kActionedDate];
        
        NSString * actionTaken =[purePlayDict objectForKey:kActionedFlag];
        if ([actionTaken isEqualToString:kYes]) {
            cell.lblActionTaken.text=@"Yes";
            cell.lblActionTaken.textColor=[UIColor greenColor];
            
        }
        else  if([actionTaken isEqualToString:kNo])
        {
            cell.lblActionTaken.text=@"No";
            cell.lblActionTaken.textColor=[UIColor redColor];
        }
        
        cell.tag = indexPath.row;
        
        
        UIImage *img = [SIUtiliesController getAlertImageFromDirectory:imgId];
         cell.imgViewSKUName.image = [UIImage imageNamed:@"default-product1.png" inBundle:[SIBaseLogic libraryBundlePath] compatibleWithTraitCollection:nil];
        if(img == nil){
            //1
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?%@=%@",[SIUtiliesController getPurePlayImageDownloadPath],kPurePlayImageId,imgId]];
            
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
                                                                               cell.imgViewSKUName.image = image;
                                                                               [cell setNeedsDisplay];
                                                                           } completion:^(BOOL finished) {
                                                                               [SIUtiliesController saveProductImageToDocumentDirectory:imgData fileName:imgId];
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
        
        for (NSIndexPath *path in [self.tableViewPurePlay indexPathsForVisibleRows]) {
            
            NSMutableDictionary *purePlayDict=[NSMutableDictionary dictionaryWithDictionary:[purePlayAlertsArray objectAtIndex:path.row]];
            
            if (sender.tag==path.row+1)
            [SIBaseLogic updateAlertsfor:PUREPLAY withParameter:[purePlayDict objectForKey:kQuestionId] toActionedFlag:@"NA" andVersion:[purePlayDict objectForKey:kVersion]];
        }
        
    }
    else
    {
        [sender setImage:[UIImage imageNamed:@"yes-green" inBundle:[SIBaseLogic libraryBundlePath] compatibleWithTraitCollection:nil] forState:UIControlStateSelected];
        sender.selected=YES;
        
        for (NSIndexPath *path in [self.tableViewPurePlay indexPathsForVisibleRows]) {
            
            
            NSMutableDictionary *purePlayDict=[NSMutableDictionary dictionaryWithDictionary:[purePlayAlertsArray objectAtIndex:path.row]];
           
            SIPurePlayCell *cell = (SIPurePlayCell *)[self.tableViewPurePlay cellForRowAtIndexPath:path];
            
            if (sender.tag==path.row+1){
                
                [cell.btnPPNo setImage:[UIImage imageNamed:@"No-gray" inBundle:[SIBaseLogic libraryBundlePath] compatibleWithTraitCollection:nil] forState:UIControlStateSelected];
                cell.btnPPNo.selected = NO;
                 [SIBaseLogic updateAlertsfor:PUREPLAY withParameter:[purePlayDict objectForKey:kQuestionId] toActionedFlag:kYes andVersion:[purePlayDict objectForKey:kVersion]];
            }
        }
    }
    [self loadPurePlayData];

}

-(void)takeActionNo:(UIButton *)sender{
    
    if (sender.selected)
    {
        [sender setImage:[UIImage imageNamed:@"No-gray" inBundle:[SIBaseLogic libraryBundlePath] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
        sender.selected=NO;
        
        for (NSIndexPath *path in [self.tableViewPurePlay indexPathsForVisibleRows]) {
            
            NSMutableDictionary *purePlayDict=[NSMutableDictionary dictionaryWithDictionary:[purePlayAlertsArray objectAtIndex:path.row]];
            
            if (sender.tag==path.row+1000)
            [SIBaseLogic updateAlertsfor:PUREPLAY withParameter:[purePlayDict objectForKey:kQuestionId] toActionedFlag:@"NA" andVersion:[purePlayDict objectForKey:kVersion]];
        }
    }
    else
    {
        [sender setImage:[UIImage imageNamed:@"no-red" inBundle:[SIBaseLogic libraryBundlePath] compatibleWithTraitCollection:nil] forState:UIControlStateSelected];
        sender.selected=YES;
        
        for (NSIndexPath *path in [self.tableViewPurePlay indexPathsForVisibleRows]) {
            
            NSMutableDictionary *purePlayDict=[NSMutableDictionary dictionaryWithDictionary:[purePlayAlertsArray objectAtIndex:path.row]];
            
            SIPurePlayCell *cell = (SIPurePlayCell *)[self.tableViewPurePlay cellForRowAtIndexPath:path];
            
           if (sender.tag==path.row+1000){
                
                [cell.btnPPYes setImage:[UIImage imageNamed:@"No-gray" inBundle:[SIBaseLogic libraryBundlePath] compatibleWithTraitCollection:nil] forState:UIControlStateSelected];
                cell.btnPPYes.selected = NO;
                 [SIBaseLogic updateAlertsfor:PUREPLAY withParameter:[purePlayDict objectForKey:kQuestionId] toActionedFlag:kNo andVersion:[purePlayDict objectForKey:kVersion]];
            }
        }
    }
    [self loadPurePlayData];

    
}

@end
