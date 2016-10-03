//
//  SISubmitAlerts.h
//  SellingIntelligence
//
//  Created by MSP on 01/11/15.
//  Copyright (c) 2015 Cognizant. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SIWebServiceParser.h"
#import "SISubmitAlertsParser.h"

@interface SISubmitAlerts : NSObject<SIServiceManagerParser>

{
    SISubmitAlertsParser *submitAlertsParser;
}


-(void)submitAlerts:(NSDictionary *)submitAlertsDictionary;
- (void)formRequestForSubmittingAlerts:(BOOL)isSubmission;
-(BOOL)unactionedAlertsToBeSubmitted;

@end
