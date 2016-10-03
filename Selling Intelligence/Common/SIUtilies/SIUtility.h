//
//  Selling_Intelligence.h
//  Selling Intelligence
//
//  Created by Sailesh on 23/09/15.
//  Copyright (c) 2015 Cognizant. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface SIUtility : NSObject
{
    UIView * progressView;
    UIView * bgView;
}

+ (SIUtility *)sharedUtility;


@property (nonatomic, retain) NSString * GPID;
@property (nonatomic, retain) NSString * password;
@property (nonatomic, retain) UILabel * lblMessage;
@property (nonatomic, retain) UIView *progressSubViewSync;
@property (strong, nonatomic) UIWindow *window;


- (void)showProgressViewWithMessageInLandscape:(NSString *)message withView:(UIView*)senderView;
- (void)removeProgressView;
- (void)showProgressViewWithMessageInLandscape:(NSString *)message onView:(UIView *)senderView withUpdateMessage:(NSString *)updateMessage;
-(void)updateTextMessage:(NSString *)updateText;
- (void)showProgressViewWithMessage:(NSString *)message withView:(UIView *)senderView isPortraid:(BOOL)isPortraid;


@end
