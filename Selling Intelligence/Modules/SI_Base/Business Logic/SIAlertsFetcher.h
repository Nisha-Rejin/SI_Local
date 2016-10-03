//
//  SIAlertsFetcher.h
//  SellingIntelligence
//
//  Created by CTS on 30/10/15.
//  Copyright (c) 2015 Cognizant. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SIBaseFetchParser.h"
#import "SIWebServiceParser.h"




@interface SIAlertsFetcher : NSObject<SIServiceManagerParser>
{
    SIBaseFetchParser *fetchParser;
    
}



-(void)getAlertsDetails:(NSDictionary *)alertsRequestDict;

@end
