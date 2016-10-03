//
//  SSOController.h
//  WorkWith
//
//  Created by Fowler, John - Contractor {BIS} on 7/8/13.
//  Copyright (c) 2013 PepsiCo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SiteMinderURLRequestFactory : NSObject
{
    NSURL *_responseURL;
    NSData *_responseData;
    
    NSString *_formAction;
    NSString *_formMethod;
    NSString *_inputUserName;
    NSString *_inputPasswordName;
    NSMutableArray *_hiddenNames;
    NSMutableArray *_hiddenValues;
}



+ (BOOL)isSiteMinderURL:(NSURL *)url
;

+ (BOOL)isSiteMinderChallenge:(NSData *)responseData
;

+ (NSMutableURLRequest *)loginRequestFromChallenge:(NSData *)responseData
                                           fromURL:(NSURL *)responseURL
                                          withUser:(NSString *)username
                                          password:(NSString *)password
;

- (id)initWithChallenge:(NSData *)responseData fromURL:(NSURL *)responseURL
;

- (NSMutableURLRequest *)createLoginRequestWithUser:(NSString *)username
                                           password:(NSString *)password
;

@end
