//
//  Common.h
//  SecurityPatternApp
//
//  Created by Fowler, John X - Contractor {BIS} on 7/20/12.
//  Copyright (c) 2013 PepsiCo. All rights reserved.
//

#ifndef WorkWith_Common_h
#define WorkWith_Common_h

//#define ENABLE_LOGS 1

#pragma mark - Useful Macros
//  -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
//
//  Useful Macros
//  
//  -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=


#define NSRangeTo(locStart, locEnd) NSMakeRange(locStart, locEnd - locStart)

#ifdef ENABLE_LOGS
#   define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#   define DLog(...)
#endif

#pragma mark - Constants
//  -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
//
//  Constants
//  
//  -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
typedef enum AuthenticationSourceType {
    AuthenticationSourceServer      = 0,
    AuthenticationSourceKeychain    = 1
} AuthenticationSourceType;

typedef enum AuthenticationError {
    AuthenticationErrorServerNotAvailable = 0,
    AuthenticationFailure    = 1
} AuthenticationError;



#pragma mark - Common Imports
//  -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
//
//  Common Imports
//  
//  -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

//  From Application
#import "LoginConfig.h"
#import "NSError+Creators.h"


#endif
