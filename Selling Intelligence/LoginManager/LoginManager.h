//
//  LoginManager.h
//  Scorecard
//
//  Created by Fowler, John X - Contractor {BIS} on 7/20/12.
//  Copyright (c) 2013 PepsiCo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#import "Common.h"
#import "KeychainItemWrapper.h"

@protocol LoginManagerDelegate;

@interface LoginManager : NSObject
{
    
    
    //  These store the userid / password coming from the keychain
    NSString *_keychainGPID;
    NSString *_keychainPass;
    
    //  These are used in making a request against the server
    NSMutableURLRequest *_urlRequest;
    NSURLConnection *_urlConnection;
    NSURLCredential *_credentials;
    NSHTTPURLResponse *_urlResponse;
    NSMutableData *_responseData;
    BOOL _receivedChallengeFromServer;
    
    BOOL _isSiteMinderRequest;
    BOOL _foundSiteMinderCookie;
    BOOL _userEnteredCredentials;

}



@property (nonatomic, weak) id <LoginManagerDelegate> delegate;


//Singleton instance
+(id) sharedInstance;

//Call this method for validation.
-(void)validateAgainstServerWithGPID:(NSString *)gpid andPass:(NSString *)pass;

//This will return TRUE when ever the login details to be asked
-(BOOL) needsPrompt;

//This will clear the credential informations which is present in keychain
-(BOOL)clearKeyChain:(BOOL)showMessage;

//Log out - Will inturn clear the cookie
-(void)performLogout;

@end

//// LoginManagerDelegate - Call this delegate once you called the method -(void)validateAgainstServerWithGPID:(NSString *)gpid andPass:(NSString *)pass for getting success or failure message.

@protocol LoginManagerDelegate <NSObject>

@required

-(void)userSuccessfullyAuthenticated:(AuthenticationSourceType)authenticationSource;

-(void)userFailedToAuthorize:(AuthenticationError) authenticationError;

@end
