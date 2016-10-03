#import <UIKit/UIKit.h>
#define kImageHeight 135
#define kImageWidth 158

#define kDetailImageWidth 765.0
#define kDetailImageHeight 1024.0

#define kDetailImageCompressionWidth 325.0
#define kDetailImageCompressionHeight 394.0

@interface SIUtiliesController : NSObject
{
}


+(BOOL)checkForNull:(id)value forParameter:(id)idtype;
+(NSString *)getPassword;
+(void)setPassword:(NSString *)password;
+(void)setStoreID:(NSString *)storeID;
+(NSString *)getStoreID;
+(void)setMfoID:(NSString *)mfoID;
+(NSString *)getMfoID;
+(void)setgpID:(NSString *)gpID;
+(NSString *)getgpID;
+(NSString *)getAppID;
+(void)setAppID:(NSString *)appID;


+ (NSString *)getSystemTimeZone:(NSDate *)date;
+(NSString *)getShortText_OfDate:(NSDate *)date;
+(NSString *)getLongText_OfDate:(NSDate *)date;
+(NSString *)getSpecifiedFormat_OfDate:(NSDate *)date;
+(NSString *)getFormattedDateFromString:(NSString *)dateString;
+(NSDate *)getUTCFormateDate:(NSDate *)localDate;
+(NSString *)getDateAndTimeString_OfCurrentDate;
+(NSString *)handlingSpecialCharactersWhileSendingRequest:(NSString *) aContentString;
+(NSDate *)getDateObjectWithGivenString:(NSString *)aStringObject;
+ (BOOL)isSubStringOfBaseString:(NSString *)baseString subString:(NSString *)subString;
+(NSNumber *)convertStringToNumber:(NSString *)string;

+ (BOOL)isValidEmailAddress:(NSString *)emailAddress;

+(NSDictionary *)soSellingIntelligenceConfig;



+(void)setCurrentTimestampInDB:(NSString *)currentTimeStamp;
+(NSString *)getCurrentTimestampInDB;


+(void)setCurrentTimestampInDBForVelocityData:(NSString *)currentTimeStamp forKey:(NSString *)customAndSegmentID;
+(NSString *)getCurrentTimestampInDBForVelocityDataForKey:(NSString *)customAndSegmentID;


+(NSString *)fetchDocumentsDirectoryPath;

//+(NSString *)getDownloadedTimeStamp:(NSString *)downloadString;
+ (NSString *) timeStamp;
+(NSDictionary *)soWebserviceErrorDict;


+(void)setAnnotationObject:(NSDictionary *)annotationObject;
+(NSDictionary *)getAnnotationObject;
+(NSDictionary *)getLibraryInputs;
+(void)setLibraryInputsDict:(NSDictionary *)libInputsObject;


+(BOOL)isValid:(id)value;
+ (NSString *)flattenHTML:(NSString *)htmlString;

+(BOOL)isHtmlString:(NSString *)html;

//---
// Showing the alert with simple message with appropriate title.
//---
+ (void) showAlertWithMessage:(NSString*) message
                        title:(NSString*) title;
//---
// Showing the alert with simple message with appropriate title with Required Buttons.
//---
+ (void)showAlertWithMessage:(NSString*) message
                       title:(NSString*) title
                    delegate:(id)delegate
           cancelButtonTitle:(NSString*) cancelButtonTitle
            otherButtonTitle:(NSString*) otherButtonTitle;

//---
// Showing the alert with simple message with appropriate title with Required Buttons and Tags.
//---
+ (void)showAlertWithMessage:(NSString*) message
                       title:(NSString*) title
                    delegate:(id)delegate
           cancelButtonTitle:(NSString*) cancelButtonTitle
            otherButtonTitle:(NSString*) otherButtonTitle
                         tag:(NSInteger) tag;


+ (UIInterfaceOrientation)fetchCurrentInterfaceOrientation;
+ (UIDeviceOrientation)fetchCurrentDeviceOrientation;
+(BOOL)saveProductImageToDocumentDirectory:(NSData*)imgData fileName:(NSString *)strFileName;
+(UIImage *)getAlertImageFromDirectory:(NSString *)strFileName;
+(NSBundle *)activeAlertLibraryBundlePath;
+(NSString *)getPurePlayImageDownloadPath;
+(NSString *)getProductCatalogueImageDownloadPath;

+(NSString *)getFetchAlertURLPath;
+(NSString *)getSubmitAlertURLPath;
+(NSDictionary *)soSellingIntelligencePlist;
+(NSString *)getVersionNumber;

@end
