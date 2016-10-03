//
//  Selling_Intelligence.h
//  Selling Intelligence
//
//  Created by Sailesh on 23/09/15.
//  Copyright (c) 2015 Cognizant. All rights reserved.
//

#import "SIUtility.h"

@interface SIUtility()
{
    
}

@end

@implementation SIUtility
{
    UIActivityIndicatorView * activityIndicator;
}
@synthesize GPID,password;
@synthesize progressSubViewSync,window,lblMessage;

static SIUtility *sharedUtilInstance;

+ (SIUtility *)sharedUtility
{
	if (!sharedUtilInstance)
    {
		sharedUtilInstance = [[SIUtility alloc] init];
	}
	return sharedUtilInstance;
}

- (void)showProgressViewWithMessageInLandscape:(NSString *)message withView:(UIView *)senderView {
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    [bgView removeFromSuperview];
    
    CGFloat viewWidth=1024.0,viewHeight=768.0,progressViewWidth=350.0,progressViewHeight=75.0;
    
    if (bgView == nil) {
        bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight)];
        [bgView setBackgroundColor:[UIColor clearColor]];
        [bgView setAlpha:1.0];
        
        bgView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin
        | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        
        progressSubViewSync.hidden = FALSE;
        
        CGFloat progressViewX,progressViewY;
        
        progressViewX=(viewWidth/2) - (progressViewWidth/2);
        progressViewY=(viewHeight/2) - (progressViewHeight/2);
        
        progressSubViewSync = [[UIView alloc] initWithFrame:CGRectMake(progressViewX, progressViewY, progressViewWidth, progressViewHeight)];
        [progressSubViewSync setBackgroundColor:[UIColor blackColor]];
        [progressSubViewSync setBackgroundColor:[UIColor blackColor]];
        [progressSubViewSync setAlpha:0.7f];
        progressSubViewSync.layer.cornerRadius = 10.0f;
        
        activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(20,25,20,20)];
        [activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [progressSubViewSync addSubview:activityIndicator];
        [activityIndicator startAnimating];
        
        lblMessage = [[UILabel alloc] initWithFrame:CGRectMake(60,8,225,60)];
        lblMessage.text = message;
        lblMessage.textColor = [UIColor whiteColor];
        lblMessage.font = [UIFont boldSystemFontOfSize:16];
        lblMessage.textAlignment = NSTextAlignmentCenter;
        lblMessage.backgroundColor = [UIColor clearColor];
        lblMessage.numberOfLines = 2;
        
        [progressSubViewSync addSubview:lblMessage];
        [bgView addSubview:progressSubViewSync];
        
    } else {
        lblMessage.text = message;
    }
    
    
    [senderView addSubview:bgView];
    [senderView bringSubviewToFront:bgView];
}


- (void)showProgressViewWithMessage:(NSString *)message withView:(UIView *)senderView isPortraid:(BOOL)isPortraid{
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    [bgView removeFromSuperview];
    
    
    CGFloat viewWidth=1024.0,viewHeight=768.0,progressViewWidth=350.0,progressViewHeight=75.0;
    if(isPortraid){
        viewWidth=768.0;
        viewHeight = 1024.0;
    }
    
    if (bgView == nil) {
        bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight)];
        [bgView setBackgroundColor:[UIColor clearColor]];
        [bgView setAlpha:1.0];
        
        bgView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin
        | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        
        progressSubViewSync.hidden = FALSE;
        
        CGFloat progressViewX,progressViewY;
        
        progressViewX=(viewWidth/2) - (progressViewWidth/2);
        progressViewY=(viewHeight/2) - (progressViewHeight/2);
        
        progressSubViewSync = [[UIView alloc] initWithFrame:CGRectMake(progressViewX, progressViewY, progressViewWidth, progressViewHeight)];
        [progressSubViewSync setBackgroundColor:[UIColor blackColor]];
        [progressSubViewSync setBackgroundColor:[UIColor blackColor]];
        [progressSubViewSync setAlpha:0.7f];
        progressSubViewSync.layer.cornerRadius = 10.0f;
        
        activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(20,25,20,20)];
        [activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [progressSubViewSync addSubview:activityIndicator];
        [activityIndicator startAnimating];
        
        lblMessage = [[UILabel alloc] initWithFrame:CGRectMake(60,8,225,60)];
        lblMessage.text = message;
        lblMessage.textColor = [UIColor whiteColor];
        lblMessage.font = [UIFont boldSystemFontOfSize:16];
        lblMessage.textAlignment = NSTextAlignmentCenter;
        lblMessage.backgroundColor = [UIColor clearColor];
        lblMessage.numberOfLines = 2;
        
        [progressSubViewSync addSubview:lblMessage];
        [bgView addSubview:progressSubViewSync];
        
    } else {
        lblMessage.text = message;
    }
    
    
    [senderView addSubview:bgView];
    [senderView bringSubviewToFront:bgView];
}

- (void)showProgressViewWithMessageInLandscape:(NSString *)message onView:(UIView *)senderView withUpdateMessage:(NSString *)updateMessage {
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    [bgView removeFromSuperview];
    
    CGFloat viewWidth=1024.0,viewHeight=768.0,progressViewWidth=350.0,progressViewHeight=75.0;
    
    if (bgView == nil) {
        bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight)];
        [bgView setBackgroundColor:[UIColor clearColor]];
        [bgView setAlpha:1.0];
        
        bgView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin
        | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        
        progressSubViewSync.hidden = FALSE;
        
        CGFloat progressViewX,progressViewY;
        
        progressViewX=(viewWidth/2) - (progressViewWidth/2);
        progressViewY=(viewHeight/2) - (progressViewHeight/2);
        
        progressSubViewSync = [[UIView alloc] initWithFrame:CGRectMake(progressViewX, progressViewY, progressViewWidth, progressViewHeight)];
        [progressSubViewSync setBackgroundColor:[UIColor blackColor]];
        [progressSubViewSync setBackgroundColor:[UIColor blackColor]];
        [progressSubViewSync setAlpha:0.7f];
        progressSubViewSync.layer.cornerRadius = 10.0f;
        
        activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(20,25,20,20)];
        [activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [progressSubViewSync addSubview:activityIndicator];
        [activityIndicator startAnimating];
        
        lblMessage = [[UILabel alloc] initWithFrame:CGRectMake(60,8,225,60)];
        lblMessage.text = message;
        lblMessage.textColor = [UIColor whiteColor];
        lblMessage.font = [UIFont boldSystemFontOfSize:16];
        lblMessage.textAlignment = NSTextAlignmentCenter;
        lblMessage.backgroundColor = [UIColor clearColor];
        lblMessage.numberOfLines = 2;
        
        [progressSubViewSync addSubview:lblMessage];
        [bgView addSubview:progressSubViewSync];
        
    } else {
        lblMessage.text = updateMessage;
    }
    
    
    [senderView addSubview:bgView];
    [senderView bringSubviewToFront:bgView];
}


-(void)updateTextMessage:(NSString *)updateText{
    
    [lblMessage setNeedsLayout];
    lblMessage.text = updateText;
}

- (void)removeProgressView {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
        
        [activityIndicator stopAnimating];
        [activityIndicator removeFromSuperview];
        
        [lblMessage removeFromSuperview];
        [progressSubViewSync removeFromSuperview];
        [bgView removeFromSuperview];
        
        activityIndicator = nil;
        lblMessage = nil;
        progressSubViewSync = nil;
        bgView = nil;
    });
}


@end
