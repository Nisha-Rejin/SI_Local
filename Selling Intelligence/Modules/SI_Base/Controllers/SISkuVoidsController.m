//
//  SIInnovationAndPureplayController.h
//  Selling Intelligence
//
//  Created by Sailesh on 29/09/15.
//  Copyright (c) 2015 Cognizant. All rights reserved.
//

#import "SISkuVoidsController.h"
#import "Selling_IntelligenceConstants.h"
#import "SIUtiliesController.h"
#import "SIUtility.h"

#define URLSESSION_TIMEOUT_PERIOD 60.0
#define URLSESSION_MAX_CONNECTIONS 10

@interface SISkuVoidsController ()<NSURLSessionDelegate,NSURLSessionTaskDelegate,NSURLSessionDataDelegate>{
    NSMutableDictionary *skuAlertsDictionary;
    
    NSString *stringValue;
    NSIndexPath *selectedTxtFieldPath;
    UITextField *selectedTextField;
}
@property (strong, nonatomic) NSURLSession *session;
@property (nonatomic, strong) NSRegularExpression * regExp;

@end

@implementation SISkuVoidsController
@synthesize isCalculatorEnabled,arrayRates,editingIndexPath,skuVoidsAlertsArray,missingSKUAlertsArray,delegate;


-(void)viewWillAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardDidHideNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
}

- (void)viewDidLoad {
    
     [super viewDidLoad];
    
    NSError *error;
   self.regExp = [[NSRegularExpression alloc]initWithPattern:@"^\\d{0,10}(([.]\\d{1,2})|([.]))?$" options:NSRegularExpressionCaseInsensitive error:&error];
    
      [self setUpInitialView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)setUpInitialView{

    self.selectedAlertType=SKUVOIDS;
    self.automaticallyAdjustsScrollViewInsets = NO;
    NSURLSessionConfiguration *sessionconfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    sessionconfig.timeoutIntervalForRequest = URLSESSION_TIMEOUT_PERIOD;
    sessionconfig. HTTPMaximumConnectionsPerHost = URLSESSION_MAX_CONNECTIONS;
    self.session = [NSURLSession sessionWithConfiguration:sessionconfig delegate:self delegateQueue:nil];
    
}

-(void)loadSkuvoidsData{
    [self.delegate hideSubmitButton];

    skuVoidsAlertsArray=[NSMutableArray array];
    missingSKUAlertsArray=[NSMutableArray array];
    
    skuVoidsAlertsArray = [[SIBaseLogic sharedSIBaseLogic]fetchAlertsOfType:SKUVOIDS forActioned:self.isActionedAlert];
    
    arrayRates=[NSMutableArray arrayWithArray:[self getArrayRates:skuVoidsAlertsArray]];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [SellingIntelligence sharedSellingIntelligenceClass].selectedAlertType=SKUVOIDS;

    [self.tableViewSkuVoids reloadData];

}

-(NSArray *)getArrayRates:(NSArray *)skuVoidsArray
{
    NSMutableArray *tempArray=[NSMutableArray array];
    
    for (NSDictionary *skuVoidDict in skuVoidsAlertsArray) {
        
                NSString *rate=[skuVoidDict objectForKey:kskuRate];
        NSString *rateValue;
        
                if ([SIUtiliesController checkForNull:rate forParameter:[NSString class]])
                    rateValue=rate;
                else
        rateValue=@"0.0";
        
        [tempArray addObject:rateValue];
    }
    NSArray *ratesArray=[NSArray arrayWithArray:tempArray];
    
    return ratesArray;
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self.tableViewSkuVoids reloadData];
}

- (BOOL)disablesAutomaticKeyboardDismissal {
    return NO;
}

#pragma mark - Table view data source


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [skuVoidsAlertsArray count];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (isCalculatorEnabled) {
        
        SISkuVoidsEditableHeaderCell *cell=(SISkuVoidsEditableHeaderCell *)[tableView dequeueReusableCellWithIdentifier:@"SkuEditableHeader"];
        return cell;
    }
    else
    {
        if (self.isActionedAlert==Open) {
            
            SISkuVoidsHeaderCell *cell=(SISkuVoidsHeaderCell *)[tableView dequeueReusableCellWithIdentifier:@"SkuHeaderCell"];
            return cell;
            
        }
        else
        {
            SISkuActionHeader *cell=(SISkuActionHeader *)[tableView dequeueReusableCellWithIdentifier:@"SkuActionHeader"];
            return cell;
        }
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 60.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (isCalculatorEnabled) {
        
        SISkuEditableCell *cell=(SISkuEditableCell *)[tableView dequeueReusableCellWithIdentifier:@"SkuEditable"];
        
        NSString *altUpc = nil;
        
        NSMutableDictionary *skuVoidsDict=[NSMutableDictionary dictionaryWithDictionary:[skuVoidsAlertsArray objectAtIndex:indexPath.row]];
        
        altUpc = [[skuVoidsAlertsArray objectAtIndex:indexPath.row] objectForKey:kAltUPC];
        
        cell.lblSkuName.text=[skuVoidsDict objectForKey:kSkuName];
        cell.lblVelocity.text=[NSString stringWithFormat:@"%.04f",[[skuVoidsDict objectForKey:kSKUVelocity] floatValue]];

        cell.txtFieldRates.tag=indexPath.row;
        NSString *rateVale=[arrayRates objectAtIndex:indexPath.row];
        NSString *potentialSalesValue=[NSString stringWithFormat:@"%f",[cell.lblVelocity.text floatValue]];
        
        
        if ([rateVale isEqualToString:@"0.0"])
            cell.txtFieldRates.text=@"";
        else
            cell.txtFieldRates.text=[NSString stringWithFormat:@"$ %@",rateVale];
        
        NSString *potentialSales=[NSString stringWithFormat:@"%f",[potentialSalesValue floatValue]*[rateVale floatValue]*365];
        
        if (potentialSales.intValue<=0)
            cell.lblPotentialSales.text=@"";
        else
            cell.lblPotentialSales.text=[NSString stringWithFormat:@"$ %.02f",potentialSales.floatValue];

        NSString * actionTaken =[skuVoidsDict objectForKey:kActionedFlag];
        
        [cell.btnSKUYes setImage:[UIImage imageNamed:@"Yes-gray" inBundle:[SIBaseLogic libraryBundlePath] compatibleWithTraitCollection:nil] forState:UIControlStateSelected];
        [cell.btnSKUNo setImage:[UIImage imageNamed:@"No-gray" inBundle:[SIBaseLogic libraryBundlePath] compatibleWithTraitCollection:nil] forState:UIControlStateSelected];
        
        if ([actionTaken isEqualToString:kYes]) {
            
            cell.btnSKUYes.selected=YES;
            [cell.btnSKUYes setImage:[UIImage imageNamed:@"yes-green" inBundle:[SIBaseLogic libraryBundlePath] compatibleWithTraitCollection:nil] forState:UIControlStateSelected];
            
            
        }
        else  if([actionTaken isEqualToString:kNo]){
            
            cell.btnSKUNo.selected=YES;
            [cell.btnSKUNo setImage:[UIImage imageNamed:@"no-red" inBundle:[SIBaseLogic libraryBundlePath] compatibleWithTraitCollection:nil] forState:UIControlStateSelected];
            
        }
        cell.btnSKUYes.tag=indexPath.row+1;
        cell.btnSKUNo.tag=indexPath.row+1000;
        cell.tag = indexPath.row;
        
        [cell.btnSKUYes addTarget:self action:@selector(takeActionYes:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnSKUNo addTarget:self action:@selector(takeActionNo:) forControlEvents:UIControlEventTouchUpInside];
        
        UIImage *img = [SIUtiliesController getAlertImageFromDirectory:altUpc];
        cell.imgVwSkuName.image = [UIImage imageNamed:@"default-product1.png" inBundle:[SIBaseLogic libraryBundlePath] compatibleWithTraitCollection:nil];
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
                                                                               cell.imgVwSkuName.image = image;
                                                                               [cell setNeedsDisplay];
                                                                           } completion:^(BOOL finished) {
                                                                               [SIUtiliesController saveProductImageToDocumentDirectory:imgData fileName:altUpc];
                                                                           }];
                                                                       }
                                                                   });
                                                               }
                                                               else{
                                                                   if (cell.tag == indexPath.row) {
                                                                       cell.imgVwSkuName.image = [UIImage imageNamed:@"default-product1.png" inBundle:[SIBaseLogic libraryBundlePath] compatibleWithTraitCollection:nil];
                                                                       [cell setNeedsDisplay];
                                                                   }
                                                               }
                                                           }];
            
            // 4
            [downloadPhotoTask resume];
            
            
        }else{
            if (cell.tag == indexPath.row) {
                cell.imgVwSkuName.image = img;
                [cell setNeedsDisplay];
            }
        }
        
        
        return cell;
    }
    else{
        if (self.isActionedAlert==Open) {
            
            SISkuDetailViewCell *cell=(SISkuDetailViewCell *)[tableView dequeueReusableCellWithIdentifier:@"SkuDetailCell"];
            
            NSString *altUpc = nil;
            
            NSMutableDictionary *skuVoidsDict=[NSMutableDictionary dictionaryWithDictionary:[skuVoidsAlertsArray objectAtIndex:indexPath.row]];
            
            altUpc = [[skuVoidsAlertsArray objectAtIndex:indexPath.row] objectForKey:kAltUPC];
            
            cell.lblSkuName.text=[skuVoidsDict objectForKey:kSkuName];
            cell.lblVelocity.text=[NSString stringWithFormat:@"%.04f",[[skuVoidsDict objectForKey:kSKUVelocity] floatValue]];

             cell.lblRank.text=[NSString stringWithFormat:@"%@",[skuVoidsDict objectForKey:kSKURank]];
            
            NSString * actionTaken =[skuVoidsDict objectForKey:kActionedFlag];
            
            [cell.btnSKUYes setImage:[UIImage imageNamed:@"Yes-gray" inBundle:[SIBaseLogic libraryBundlePath] compatibleWithTraitCollection:nil] forState:UIControlStateSelected];
            [cell.btnSKUNO setImage:[UIImage imageNamed:@"No-gray" inBundle:[SIBaseLogic libraryBundlePath] compatibleWithTraitCollection:nil] forState:UIControlStateSelected];
            
            //code by Nisha
            NSString * isYesbuttonEnabled =[skuVoidsDict objectForKey:kYesActionEnabled];
            if ([isYesbuttonEnabled isEqualToString:kYes]) {
                cell.btnSKUYes.hidden = NO;
            }
            else {
                cell.btnSKUYes.hidden = YES;
            }
            NSString * isNobuttonEnabled =[skuVoidsDict objectForKey:kNoActionEnabled];
            if ([isNobuttonEnabled isEqualToString:kYes]) {
                cell.btnSKUNO.hidden = NO;
            }
            else {
                cell.btnSKUNO.hidden = YES;
            }
            ///////

            if ([actionTaken isEqualToString:kYes]) {
                
                cell.btnSKUYes.selected=YES;
                [cell.btnSKUYes setImage:[UIImage imageNamed:@"yes-green" inBundle:[SIBaseLogic libraryBundlePath] compatibleWithTraitCollection:nil] forState:UIControlStateSelected];
                
                
            }
            else  if([actionTaken isEqualToString:kNo]){
                
                cell.btnSKUNO.selected=YES;
                [cell.btnSKUNO setImage:[UIImage imageNamed:@"no-red" inBundle:[SIBaseLogic libraryBundlePath] compatibleWithTraitCollection:nil] forState:UIControlStateSelected];
                
                
            }
            
            
            cell.btnSKUYes.tag=indexPath.row+1;
            cell.btnSKUNO.tag=indexPath.row+1000;
            cell.tag = indexPath.row;
            
            [cell.btnSKUYes addTarget:self action:@selector(takeActionYes:) forControlEvents:UIControlEventTouchUpInside];
            [cell.btnSKUNO addTarget:self action:@selector(takeActionNo:) forControlEvents:UIControlEventTouchUpInside];
            
            UIImage *img = [SIUtiliesController getAlertImageFromDirectory:altUpc];
            cell.imgVwSku.image = [UIImage imageNamed:@"default-product1.png" inBundle:[SIBaseLogic libraryBundlePath] compatibleWithTraitCollection:nil];
            if(img == nil){
                
//                dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
//                dispatch_async(queue, ^{
//                    NSData *imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@.png",[SIUtiliesController getProductCatalogueImageDownloadPath],altUpc]]];
//                    UIImage *image = [UIImage imageWithData:imgData];
//                    if (image) {
//                        dispatch_async(dispatch_get_main_queue(), ^{
//                            if (cell.tag == indexPath.row) {
//                                [UIView transitionWithView:cell duration:0.5f options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
//                                    cell.imgVwSku.image = image;
//                                    [cell setNeedsDisplay];
//                                } completion:^(BOOL finished) {
//                                    [SIUtiliesController saveProductImageToDocumentDirectory:imgData fileName:altUpc];
//                                }];
//                            }
//                        });
//                    }else{
//                        if (cell.tag == indexPath.row) {
//                            cell.imgVwSku.image = [UIImage imageNamed:@"default-product1.png" inBundle:[SIBaseLogic libraryBundlePath] compatibleWithTraitCollection:nil];
//                            [cell setNeedsDisplay];
//                        }
//                    }
//                });
                
                
                
                
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
            SISkuActionCell *cell=(SISkuActionCell *)[tableView dequeueReusableCellWithIdentifier:@"SkuAction"];
            NSString *altUpc = nil;
            if (self.selectedAlertType==SKUVOIDS) {
                
                NSMutableDictionary *skuVoidsDict=[NSMutableDictionary dictionaryWithDictionary:[skuVoidsAlertsArray objectAtIndex:indexPath.row]];
                
                altUpc = [[skuVoidsAlertsArray objectAtIndex:indexPath.row] objectForKey:kAltUPC];
                
                cell.lblSkuName.text=[skuVoidsDict objectForKey:kSkuName];
                cell.lblStatus.text=[skuVoidsDict objectForKey:kActionedDate];
                cell.lblTakenBy.text = [skuVoidsDict objectForKey:kGPID];
                
                NSString * actionTaken =[skuVoidsDict objectForKey:kActionedFlag];
                if ([actionTaken isEqualToString:kYes]) {
                    cell.lblActionTaken.text=@"Yes";
                    cell.lblActionTaken.textColor=[UIColor greenColor];
                    
                }
                else  if([actionTaken isEqualToString:kNo])
                {
                    cell.lblActionTaken.text=@"No";
                    cell.lblActionTaken.textColor=[UIColor redColor];
                }
                
            }
            
            cell.tag = indexPath.row;
            
            UIImage *img = [SIUtiliesController getAlertImageFromDirectory:altUpc];
            cell.imgViewSkuName.image = [UIImage imageNamed:@"default-product1.png" inBundle:[SIBaseLogic libraryBundlePath] compatibleWithTraitCollection:nil];
            if(img == nil){
//                dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
//                dispatch_async(queue, ^{
//                    NSData *imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@.png",[SIUtiliesController getProductCatalogueImageDownloadPath],altUpc]]];
//                    UIImage *image = [UIImage imageWithData:imgData];
//                    if (image) {
//                        dispatch_async(dispatch_get_main_queue(), ^{
//                            if (cell.tag == indexPath.row) {
//                                [UIView transitionWithView:cell duration:0.5f options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
//                                    cell.imgViewSkuName.image = image;
//                                    [cell setNeedsDisplay];
//                                } completion:^(BOOL finished) {
//                                    [SIUtiliesController saveProductImageToDocumentDirectory:imgData fileName:altUpc];
//                                }];
//                            }
//                        });
//                    }else{
//                        if (cell.tag == indexPath.row) {
//                            cell.imgViewSkuName.image = [UIImage imageNamed:@"default-product1.png" inBundle:[SIBaseLogic libraryBundlePath] compatibleWithTraitCollection:nil];
//                            [cell setNeedsDisplay];
//                        }
//                    }
//                });
                
                
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
    
}

#pragma mark - nsurl session delegate

//- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *credential))completionHandler
//{
//    completionHandler(NSURLSessionAuthChallengeUseCredential, [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust]);
//}


#pragma mark-Keyboard Delegates


- (void)keyboardWillShow:(NSNotification *)notification
{
    
    SISkuEditableCell *cell=(SISkuEditableCell *)[self.tableViewSkuVoids dequeueReusableCellWithIdentifier:@"SkuEditable"];
    
    CGPoint location = [self.tableViewSkuVoids convertPoint:cell.txtFieldRates.frame.origin fromView:cell.txtFieldRates.superview];
//    location.y-=60;
    NSIndexPath *indexPath = [self.tableViewSkuVoids indexPathForRowAtPoint:location];
    
    self.editingIndexPath=[NSIndexPath indexPathForRow:indexPath.row inSection:0];
    NSDictionary *keyInfo = [notification userInfo];
    CGRect keyboardFrame = [[keyInfo objectForKey:@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    keyboardFrame = [self.tableViewSkuVoids convertRect:keyboardFrame fromView:nil];
    CGRect intersect = CGRectIntersection(keyboardFrame, self.tableViewSkuVoids.bounds);

    if(!CGRectIsNull(intersect)) {
//        [UIView animateWithDuration:duration animations:^{
//            CGRect keyboardFrame = [[keyInfo objectForKey:@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
//       
//        self.tableViewSkuVoids.frame = CGRectMake(self.tableViewSkuVoids.frame.origin.x, self.tableViewSkuVoids.frame.origin.y, self.tableViewSkuVoids.frame.size.width, self.tableViewSkuVoids.frame.size.height+120-keyboardFrame.size.height);
//        }];

        NSTimeInterval duration = [[keyInfo objectForKey:@"UIKeyboardAnimationDurationUserInfoKey"] doubleValue];
        [UIView animateWithDuration:duration animations:^{
//            self.tableViewSkuVoids.contentInset = UIEdgeInsetsMake(0, 0, intersect.size.width-255, 0);
//            self.tableViewSkuVoids.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, intersect.size.width-255, 0);
            
            self.tableViewSkuVoids.contentInset = UIEdgeInsetsMake(0, 0, intersect.size.width-210, 0);
            self.tableViewSkuVoids.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, intersect.size.width-210, 0);
            
        }];
    }
    
    [self.tableViewSkuVoids scrollToRowAtIndexPath:self.editingIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    
}


- (void)keyboardWillHide:(NSNotification *)notification
{
    NSDictionary *keyInfo = [notification userInfo];
    NSTimeInterval duration = [[keyInfo objectForKey:@"UIKeyboardAnimationDurationUserInfoKey"] doubleValue];
    
    [UIView animateWithDuration:duration animations:^{
//        CGRect keyboardFrame = [[keyInfo objectForKey:@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
//        keyboardFrame = [self.tableViewSkuVoids convertRect:keyboardFrame fromView:nil];
//        self.tableViewSkuVoids.frame = CGRectMake(self.tableViewSkuVoids.frame.origin.x, self.tableViewSkuVoids.frame.origin.y, self.tableViewSkuVoids.frame.size.width, self.tableViewSkuVoids.frame.size.height+keyboardFrame.size.height+120);
        self.tableViewSkuVoids.contentInset = UIEdgeInsetsZero;
        self.tableViewSkuVoids.scrollIndicatorInsets = UIEdgeInsetsZero;
    }];
    
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark-textfield Delgates
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{


    
    
    NSString *rateValue=[textField.text stringByReplacingCharactersInRange:range withString:string];
    
        NSCharacterSet *notAllowedChars = [[NSCharacterSet characterSetWithCharactersInString:@"1234567890."] invertedSet];
    
        NSString *resultString = [[rateValue componentsSeparatedByCharactersInSet:notAllowedChars] componentsJoinedByString:@""];
    
    if ([self.regExp numberOfMatchesInString:resultString options:0 range:NSMakeRange(0, [resultString length])]){
               if (resultString.floatValue<=100) {
                    [arrayRates replaceObjectAtIndex:textField.tag withObject:resultString];
                }else{
                    [SIUtiliesController showAlertWithMessage:@"Maximum Limit Exceeds" title:KAPPNAME];
                    resultString=@"100";
                    [arrayRates replaceObjectAtIndex:textField.tag withObject:resultString];
                    
                }
            }
    else{
                return NO;
    }
    
    
    if ([resultString isEqualToString:@""]) {
        [arrayRates replaceObjectAtIndex:textField.tag withObject:@"0.0"];

    }
    
    selectedTextField=textField;
    
    selectedTxtFieldPath = [NSIndexPath indexPathForRow:textField.tag inSection:0];
    
    SISkuEditableCell *skucell=(SISkuEditableCell *)[self.tableViewSkuVoids cellForRowAtIndexPath:selectedTxtFieldPath];

    
    NSString *potentialSalesValue=[NSString stringWithFormat:@"%f",[skucell.lblVelocity.text floatValue]];
    if ([resultString isEqualToString:@"0.0"])
        skucell.txtFieldRates.text=@"";
    else
        skucell.txtFieldRates.text=[NSString stringWithFormat:@"$ %@",resultString];
    
    NSString *potentialSales=[NSString stringWithFormat:@"%f",[potentialSalesValue floatValue]*[resultString floatValue]*365];
    
    if (potentialSales.intValue<=0)
        skucell.lblPotentialSales.text=@"";
    else
        skucell.lblPotentialSales.text=[NSString stringWithFormat:@"$ %.02f",potentialSales.floatValue];
    
    
    NSMutableDictionary *skuVoidsDict=[NSMutableDictionary dictionaryWithDictionary:[skuVoidsAlertsArray objectAtIndex:selectedTxtFieldPath.row]];

    [[SICoreDataManager sharedDataManager] insertSKUVoidsRateValue:resultString withUPCCode:[skuVoidsDict objectForKey:kUPC] andVersion:[skuVoidsDict objectForKey:kVersion]];

       return NO;
    
}





#pragma mark-take Actions

-(void)takeActionYes:(UIButton *)sender{
 
    
    if (sender.selected)
    {
        for (NSIndexPath *path in [self.tableViewSkuVoids indexPathsForVisibleRows]) {
            
            
            NSMutableDictionary *skuVoidsDict=[NSMutableDictionary dictionaryWithDictionary:[skuVoidsAlertsArray objectAtIndex:path.row]];
            
            if (sender.tag==path.row+1){
            [SIBaseLogic updateAlertsfor:SKUVOIDS withParameter:[skuVoidsDict objectForKey:kUPC] toActionedFlag:@"NA" andVersion:[skuVoidsDict objectForKey:kVersion]];
                
            }
        }
        
        
        [sender setImage:[UIImage imageNamed:@"Yes-gray" inBundle:[SIBaseLogic libraryBundlePath] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
        sender.selected=NO;
    }
    else
    {
        [sender setImage:[UIImage imageNamed:@"yes-green" inBundle:[SIBaseLogic libraryBundlePath] compatibleWithTraitCollection:nil] forState:UIControlStateSelected];
        sender.selected=YES;
        
        for (NSIndexPath *path in [self.tableViewSkuVoids indexPathsForVisibleRows]) {
            
            NSMutableDictionary *skuVoidsDict=[NSMutableDictionary dictionaryWithDictionary:[skuVoidsAlertsArray objectAtIndex:path.row]];
            
            SISkuDetailViewCell *cell = (SISkuDetailViewCell *)[self.tableViewSkuVoids cellForRowAtIndexPath:path];
            
            if (sender.tag==path.row+1 && !isCalculatorEnabled) {
                [cell.btnSKUNO setImage:[UIImage imageNamed:@"No-gray" inBundle:[SIBaseLogic libraryBundlePath] compatibleWithTraitCollection:nil] forState:UIControlStateSelected];
                cell.btnSKUNO.selected = NO;
                [SIBaseLogic updateAlertsfor:SKUVOIDS withParameter:[skuVoidsDict objectForKey:kUPC] toActionedFlag:kYes andVersion:[skuVoidsDict objectForKey:kVersion]];
            }
            if (isCalculatorEnabled){
                SISkuEditableCell *cell = (SISkuEditableCell *)[self.tableViewSkuVoids cellForRowAtIndexPath:path];
                
                if (sender.tag==path.row+1) {
                    [cell.btnSKUNo setImage:[UIImage imageNamed:@"No-gray" inBundle:[SIBaseLogic libraryBundlePath] compatibleWithTraitCollection:nil] forState:UIControlStateSelected];
                    cell.btnSKUNo.selected = NO;
                    [SIBaseLogic updateAlertsfor:SKUVOIDS withParameter:[skuVoidsDict objectForKey:kUPC] toActionedFlag:kYes andVersion:[skuVoidsDict objectForKey:kVersion]];
                }
            }
        }
    }
    [self loadSkuvoidsData];
}

-(void)takeActionNo:(UIButton *)sender{
    
    
    if (sender.selected)
    {
        [sender setImage:[UIImage imageNamed:@"No-gray" inBundle:[SIBaseLogic libraryBundlePath] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
        sender.selected=NO;
        
        for (NSIndexPath *path in [self.tableViewSkuVoids indexPathsForVisibleRows]) {
            
            
            NSMutableDictionary *skuVoidsDict=[NSMutableDictionary dictionaryWithDictionary:[skuVoidsAlertsArray objectAtIndex:path.row]];
            
            
            if (sender.tag==path.row+1000)
            [SIBaseLogic updateAlertsfor:SKUVOIDS withParameter:[skuVoidsDict objectForKey:kUPC] toActionedFlag:@"NA" andVersion:[skuVoidsDict objectForKey:kVersion]];
            
        }
        
    }
    else
    {
        [sender setImage:[UIImage imageNamed:@"no-red" inBundle:[SIBaseLogic libraryBundlePath] compatibleWithTraitCollection:nil] forState:UIControlStateSelected];
        sender.selected=YES;
        
        for (NSIndexPath *path in [self.tableViewSkuVoids indexPathsForVisibleRows]) {
            
            
            NSMutableDictionary *skuVoidsDict=[NSMutableDictionary dictionaryWithDictionary:[skuVoidsAlertsArray objectAtIndex:path.row]];
            
            
            
            SISkuDetailViewCell *cell = (SISkuDetailViewCell *)[self.tableViewSkuVoids cellForRowAtIndexPath:path];
            if (sender.tag==path.row+1000 && !isCalculatorEnabled) {
                [cell.btnSKUYes setImage:[UIImage imageNamed:@"No-gray" inBundle:[SIBaseLogic libraryBundlePath] compatibleWithTraitCollection:nil] forState:UIControlStateSelected];
                cell.btnSKUYes.selected = NO;
                [SIBaseLogic updateAlertsfor:SKUVOIDS withParameter:[skuVoidsDict objectForKey:kUPC] toActionedFlag:kNo andVersion:[skuVoidsDict objectForKey:kVersion]];
                
            }
            
            
            if (isCalculatorEnabled){
                SISkuEditableCell *cell = (SISkuEditableCell *)[self.tableViewSkuVoids cellForRowAtIndexPath:path];
                if ((sender.tag==path.row+1000)) {
                    [cell.btnSKUYes setImage:[UIImage imageNamed:@"No-gray" inBundle:[SIBaseLogic libraryBundlePath] compatibleWithTraitCollection:nil] forState:UIControlStateSelected];
                    cell.btnSKUYes.selected = NO;
                    [SIBaseLogic updateAlertsfor:SKUVOIDS withParameter:[skuVoidsDict objectForKey:kUPC] toActionedFlag:kNo andVersion:[skuVoidsDict objectForKey:kVersion]];
                    
                    
                }
            }
            
            
        }
        
    }
    [self loadSkuvoidsData];

}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
