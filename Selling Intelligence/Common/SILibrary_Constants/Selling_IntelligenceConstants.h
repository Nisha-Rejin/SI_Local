//  AppConstants.h
//  AlertDashboard
//
//  Created by Sailesh on 23/09/15.
//  Copyright (c) 2015 Cognizant. All rights reserved.
//

#ifndef AlertDashboard_AppConstants_h
#define AlertDashboard_AppConstants_h


//forgot password URL

#define kFORGOT_PASSWORD_URL            @"https://idmt.mypepsico.com"


#define kTimeoutInterval 120.0
#define kProductTimeoutInterval 120.0
#define kERROR_INVALID_RESPONSE_ERROR      @"INVALID_RESPONSE"
#define kERROR_DOMAIN_PAGE_NOT_FOUND       @"PAGE_NOT_FOUND"
#define kERROR_DOMAIN_ACCESS_DENIED        @"ACCESS_DENIED"
#define kERROR_DOMAIN_SESSION_EXPIRED      @"SESSION_EXPIRED"
#define kIsOfflineMode @"isofflinemode"

// target

#define kTarget @"Target"
#define kDevelopmentTarget @"DEV"
#define kFitTarget @"FIT"
#define kProductionTarget @"PROD"
#define kCFBundleVersion @"CFBundleVersion"

#define kActiveAlertFetchURL @"ActiveAlertFetchURL"
#define kProductcatalogueImageBaseURL @"ProductcatalogueImageBaseURL"
#define kPurePlayImageBaseURL @"PurePlayImageBaseURL"
#define kActiveAlertSubmitURL @"ActiveAlertSubmitURL"

//Entity Constants

#define kConfigurationEntity           @"Configuration"
#define kPurePlayEntity                @"Pureplay"
#define kSKUVoidsEntity                @"SKUVoids"
#define kMissingSKUinPOGEntity         @"MissingSKUinPOG"
#define kInnovationEntity              @"Innovation"


//Service Agent Constants

#define kCookie          @"Cookie"
#define kAccept          @"Accept"
#define kContentType     @"Content-Type"
#define kApplicationType @"application/json"
#define kError401        @"Error 401--Unauthorized"
#define kError400        @"Error 400  Page Not Found"
#define kError403        @"Error 403--Forbidden"
#define kSSOString       @"https://sso"
#define kPost            @"POST"
#define kGet             @"GET"
#define kCustomerId       @"customerId"
#define kAppId            @"appId"
#define kMfoId            @"mfoId"
#define kMFOIDVALUE          @"099"
#define kEmailFrom              @"emailFrom"
#define kEMAILTO                @"emailTo"
#define ksubject                @"subject"
#define kmessage                @"message"
#define kEMAILVIEW              @"emailView"
#define kEMAILCC                @"emailCC"
#define kEMAILBCC               @"emailBCC"
#define kEmailFromValue         @"1234@XXXXX.com"
#define kROOTCERT                       @"DEV2IDXRootCert"
#define kCertificateFileExtension       @"cer"
#define KAPPNAME    @"Selling INTELLIGENCE"
#define kDeviceName @"deviceName"
#define kDeviceType @"IPAD"
#define kOK @"OK"
#define kPLISTERRORCODE @"ErrorCode"
#define kSESSIONEXPIEDERROR @"Your session has expired. Please login again"
#define kNetworkIssue @"Please check your internet connection or try again later."
#define kOfflinemodeWarning @"You are in offline mode. Please switch to online mode to work."
#define kNetworkErrorWarning @"You are not connected to network.Please switch to offline mode"
#define kDeleteStoreConfirmation @"Are you sure you want to delete this store?"

#define kSessionExpiredNotificationName @"Your session has expired. Please log in again."

// service static value

#define kSpaceAppId             @"2"
#define kStoreFactAppId         @"1"
#define kValueMfoId             @"99"



// Alerts Menu

#define kSKUVoids       @"SKU Voids"
#define kAlertCount     @"AlertCount"
#define kAlertType      @"AlertType"
#define kPurePlay       @"Pure Play"
#define kMissingSKUs    @"missingSKUs"
#define kCountryCode    @"countryCode"
#define kGeoLevelTypeCode @"geoLevelTypeCode"
#define kGPID               @"gpId"
#define kPassword           @"password"
#define kIsInnovation   @"isInnovation"
#define kIsMissingSKUs  @"isMissingSKUs"
#define kIsPurePlay     @"isPurePlay"
#define kIsSKUVoids     @"isSKUVoids"
# define kImagesArray [NSMutableArray arrayWithObjects:@"skus-missing",@"skus-voids",@"innovation",@"pure-play", nil]
#define kActionedDate   @"actionedDate"
#define kActionedFlag     @"actionedFlag"
#define kSKUVelocity      @"skuVelocity"
#define kSKURank          @"skuRank"
#define kskuRate   @"skuRate"
#define kInnovationStartDate    @"innovationStartDate"
#define kInnovationEndDate      @"innovationEndDate"
#define kInnovation       @"innovation"

#define kSIBundle                  @"/SellingIntelligence.bundle"
#define kSIStoryBoardName          @"SIMain"
#define kSINavigation              @"SINVC"
#define kAlertsDisplayVC           @"AlertsDisplayVC"
#define kInnovationAndPureplayVC   @"InnovationAndPureplayVC"
#define kSkuVoidsVC                 @"SkuVoidsVC"
#define kAlertID                    @"alertId"
#define kStoreID                    @"storeID"
#define kYesActionEnabled           @"isYesActionEnabled"
#define kNoActionEnabled            @"isNoActionEnabled"
//#define kMissingSKUPOG         @"Missing SKU's (POG)"
#define kMissingSKUPOG         @"POG SKUs not Ordered"
//#define kInnovationName        @"Innovation"
#define kInnovationName        @"Target Innovation Gaps"
//#define kPurePlayName          @"Pure Play"
#define kPurePlayName          @"Pure Play Opportunities"
//#define kSKUMissinginPOG       @"SKUs Missing in Planogram"
#define kSKUMissinginPOG       @"POG SKUs not Ordered"
//#define kInnovationOpportunity @"Innovation Opportunity"
#define kInnovationOpportunity @"Target Innovation Gaps"
//#define kPurePlayOpportunity   @"Pure Play Opportunity"
#define kPurePlayOpportunity   @"Pure Play Opportunities"
#define kUnactionedAlertsCount           @"unActionedAlertsCount"
#define kActionedAlertsCount             @"actionedAlertsCount"
#define kActioned                        @"actioned"
#define kUnActioned                      @"unActioned"

#define kUPC                @"upc"
#define kAltUPC             @"alt_Upc"
#define kSkuName            @"skuName"
#define kSkuId              @"skuVoidId"
#define kSkuFlg             @"skuVoidFlag"
#define kPogId              @"missingSkuInPogId"
#define kPogFlg             @"missingSkuInPogFlag"
#define kInnoId             @"innovationId"
#define kInnoFlg            @"innovationFlag"
#define kVersion            @"version"
#define kPureplayId         @"purePlayId"
#define kGeoLevelId         @"geoLevelId"
#define ksrbuNum            @"srbuNum"
#define kActionedAlertsRequest @"actionedAlertsRequest"
#define kPurePlayActionedRequest @"purePlayActionedRequest"
#define kQuestionId         @"questionId"
#define kQuestionDescription       @"questionDescription"
#define kHeaderId                  @"headerId"
#define kImageId            @"imageId"
#define kDefId              @"defId"
#define kYes                @"Y"
#define kNo                 @"N"
#define kinvenID            @"invenID"

// submit alert parser

#define kKeySubmitStatus            @"status"
#define kKeyStatusCode        @"statusCode"
#define kKeySubmitStatusCode        @"101"
#define kKeyEmptyCode @"103"
#define kKeyFailDesc @"failureDesc"
#define kKeySubmissionFailed @"Reponses Submission Failed"

#define kSuccessValueSubmitStatus   @"Success"


//Log Constants

#define kFailed             @"FAILED"


// product catalogue image path

#define kProductCatalogueImagePath @"SpaceOptimization.Products"
#define kPurePlayImagePath @"SurveyFileDownloadServlet"
#define kPurePlayImageId @"img_id"

#define kUnActionedInnovation   @"unactInnAlertsResponse"
#define kActionedInnovation     @"actInnAlertsResponse"
#define kUnActionedMissingSKUs  @"unactMisSkuAlertsResponse"
#define kActionedMissingSKUs    @"actMisSkuAlertsResponse"
#define kUnActionedSKUVoids     @"unactSkuAlertsResponse"
#define kActionedSKUVoids       @"actSkuAlertsResponse"
#define kUnActionedPurePlay     @"unactPurePlayAlertsResponse"
#define kActionedPurePlay       @"actPurePlayAlertsResponse"
#define kPurePlayAlertsResponse @"purePlayAlertsResponse"
#define kSkuVoidAlertsResponse  @"skuVoidAlertsResponse"
#define kMissingSkuInPogAlertsResponse @"missingSkuInPogAlertsResponse"
#define kInnovationAlertsResponse @"innovationAlertsResponse"
#define kAlertTypes             @"alertTypes"

#define kFileNameForDownloadedProductAlertImages             @"ProductAlertImages"
//Email Parser

#define kERRORCODE @"errorCode"
#define kERRORDESC @"errorDescription"
#define kRESPONSESUCCESSCODE @"1000"
#define kSERVERERRORCODE @"100"
#define kDBERRORCODE @"101"
#define kSSLERRORCODE @"1009"
#define kSuccess @"Success"


//Library Enum's

typedef enum {
    MISSINGSKUSINPOG=1,
    SKUVOIDS,
    INNOVATION,
    PUREPLAY,
} SELECTEDALERT;




typedef enum    //----------- Open or COmplete
{
    Open =1,
    Completed
}searchType;


//Library COnstants

#define kViewFrame CGRectMake(262,self.view.frame.origin.y+45, self.view.frame.size.width-262, self.view.frame.size.height-45)
#define kSelectedColor [UIColor colorWithPatternImage:[UIImage imageNamed:@"selectedtab" inBundle:[SIBaseLogic libraryBundlePath] compatibleWithTraitCollection:nil]]


#endif