//
//  Selling_Intelligence.h
//  Selling Intelligence
//
//  Created by Sailesh on 23/09/15.
//  Copyright (c) 2015 Cognizant. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SIUtiliesController.h"
#import "SIBaseLogic.h"

@interface SellingIntelligence : NSObject
{
    UIView * progressView;
    UIView * bgView;
    CGAffineTransform rotationTransform;
}

@property (nonatomic, copy) void(^backgroundTransferCompletionHandler)();
@property (nonatomic, retain) UILabel * lblMessage;
@property (nonatomic, assign)BOOL isAlertDownloaded,alertsSubmitted;
@property (nonatomic, strong) UIAlertView *alertServerSyncError;
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain) UIView *progressSubViewSync;
@property (nonatomic, retain) UIView *progressSubViewSellingStories;
@property (nonatomic, assign) int selectedAlertType;

+ (instancetype) sharedSellingIntelligenceClass;


-(void)loadSellingIntelligence:(UIViewController *)parentView forGPID:(NSString *)loginGPID withPassword:(NSString *)loginPassword;

-(void)downloadAlertsFromServer:(NSDictionary *)requestDict;
-(void)cancelRequest;
-(int)getUnActionedAlertCount;
-(int)getActionedAlertCount;
-(BOOL)unactionedAlertsToBeSubmitted;


@end
