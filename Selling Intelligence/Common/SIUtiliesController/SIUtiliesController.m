#import "SIUtiliesController.h"
#import "Selling_IntelligenceConstants.h"

#include <sys/time.h>

@implementation SIUtiliesController

+(BOOL)checkForNull:(id)value forParameter:(id)idtype{
    
    if (![value isKindOfClass:[NSNull class]] && value!=nil  && [value isKindOfClass:idtype]) {
        
        if ([value isKindOfClass:[NSString class]]) {
            if (![value isEqualToString:@""] && ![value isEqualToString:@"(null)"] && ![value isEqualToString:@" "]) {
                return YES;
            }
            else
            {
                return NO;
            }
        }
        
        return YES;
        
    }
    else
    {
        return NO;
    }
        
}

+ (BOOL)isValidEmailAddress:(NSString *)emailAddress {
    
   // NSString *stricterFilterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}" ;
    NSString *stricterFilterString = @"^(([a-zA-Z0-9_\\-\\.]+)@([a-zA-Z0-9_\\-\\.]+)\\.([a-zA-Z]{2,5}){1,25})+([;.](([a-zA-Z0-9_\\-\\.]+)@([a-zA-Z0-9_\\-\\.]+)\\.([a-zA-Z]{2,5}){1,25})+)*$";
    
    
    //Create predicate with format matching your regex string
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:
                              @"SELF MATCHES %@", stricterFilterString];
    
    //return true if email address is valid
    return [emailTest evaluateWithObject:emailAddress];
}

+ (void) showAlertWithMessage:(NSString*) message
{
    [SIUtiliesController showAlertWithMessage:message title:KAPPNAME];
}

+ (void) showAlertWithMessage:(NSString*) message
                        title:(NSString*) title
{
    [SIUtiliesController showAlertWithMessage:message title:title delegate:nil cancelButtonTitle:nil otherButtonTitle:kOK];
}

+ (void)showAlertWithMessage:(NSString*) message
                       title:(NSString*) title
                    delegate:(id)delegate
           cancelButtonTitle:(NSString*) cancelButtonTitle
            otherButtonTitle:(NSString*) otherButtonTitle
{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:delegate
                                              cancelButtonTitle:cancelButtonTitle
                                              otherButtonTitles:otherButtonTitle, nil];
        [alert show];
    });
  
}

+ (void)showAlertWithMessage:(NSString*) message
                       title:(NSString*) title
                    delegate:(id)delegate
           cancelButtonTitle:(NSString*) cancelButtonTitle
            otherButtonTitle:(NSString*) otherButtonTitle
                         tag:(NSInteger) tag
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:delegate
                                          cancelButtonTitle:cancelButtonTitle
                                          otherButtonTitles:otherButtonTitle, nil];
    alert.tag = tag;
    [alert show];
}



+ (NSString *)getShortText_OfDate:(NSDate *)date {
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	
	[formatter setDateStyle:NSDateFormatterMediumStyle];
	NSString *stringFromDate = [formatter stringFromDate:date];
	
	return stringFromDate;
}

+ (NSString *)getLongText_OfDate:(NSDate *)date {
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	
	[formatter setDateStyle:/*kCFDateFormatterLongStyle*/NSDateFormatterLongStyle];
	[formatter setTimeStyle:/*kCFDateFormatterShortStyle*/NSDateFormatterShortStyle];
	NSString *stringFromDate = [formatter stringFromDate:date];
	
	return stringFromDate;
}

+(void)setgpID:(NSString *)gpID
{
    NSUserDefaults *storeData = [NSUserDefaults standardUserDefaults];
    [storeData setObject:gpID forKey:kGPID];
    [storeData synchronize];
}

+(NSString *)getgpID
{
    if([[NSUserDefaults standardUserDefaults] objectForKey:kGPID])
    {
        return [[NSUserDefaults standardUserDefaults] objectForKey:kGPID];
    }
    return 0;
}


+(void)setPassword:(NSString *)password
{
    NSUserDefaults *storeData = [NSUserDefaults standardUserDefaults];
    [storeData setObject:password forKey:kPassword];
    [storeData synchronize];
}

+(NSString *)getPassword
{
    if([[NSUserDefaults standardUserDefaults] objectForKey:kPassword])
    {
        return [[NSUserDefaults standardUserDefaults] objectForKey:kPassword];
    }
    return 0;
}
+(NSString *)getAppID
{
    if([[NSUserDefaults standardUserDefaults] objectForKey:kAppId])
    {
        return [[NSUserDefaults standardUserDefaults] objectForKey:kAppId];
    }
    return 0;
}

+(void)setAppID:(NSString *)appID
{
    NSUserDefaults *storeData = [NSUserDefaults standardUserDefaults];
    [storeData setObject:appID forKey:kAppId];
    [storeData synchronize];
}


+(void)setStoreID:(NSString *)storeID
{
    NSUserDefaults *storeData = [NSUserDefaults standardUserDefaults];
    [storeData setObject:storeID forKey:kStoreID];
    [storeData synchronize];
}

+(NSString *)getStoreID
{
    if([[NSUserDefaults standardUserDefaults] objectForKey:kStoreID])
    {
        return [[NSUserDefaults standardUserDefaults] objectForKey:kStoreID];
    }
    return 0;
}

+(void)setMfoID:(NSString *)mfoID;
{
    NSUserDefaults *storeData = [NSUserDefaults standardUserDefaults];
    [storeData setObject:mfoID forKey:kMfoId];
    [storeData synchronize];
}

+(NSString *)getMfoID;
{
    if([[NSUserDefaults standardUserDefaults] objectForKey:kMfoId])
    {
        return [[NSUserDefaults standardUserDefaults] objectForKey:kMfoId];
    }
    return 0;
}



+ (NSString *)getSystemTimeZone:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setTimeZone:[NSTimeZone systemTimeZone]];
    
    [formatter setDateFormat:@"dd-MMM-yy HH:mm:ss"];
    
    NSString *stringFromDate = [formatter stringFromDate:date];
    
    return stringFromDate;
}

+ (NSString *)flattenHTML:(NSString *)htmlString {
    NSScanner *theScanner;
    NSString *text = nil;
    theScanner = [NSScanner scannerWithString:htmlString];
    while ([theScanner isAtEnd] == NO) {
        // find start of tag
        [theScanner scanUpToString:@"<title>" intoString:NULL] ;
        // find end of tag
        [theScanner scanUpToString:@"</title>" intoString:&text] ;
        // replace the found tag with a space
        //(you can filter multi-spaces out later if you wish)
        // htmlString = [htmlString stringByReplacingOccurrencesOfString:[ NSString stringWithFormat:@"%@>", text] withString:@" "];
        if (![text isEqualToString:@"<title>SSO Login Services"]) {
            text = nil;
        }
    } // while //
    return text;
}


+(BOOL)isHtmlString:(NSString *)html{

    NSRange divRange = [html rangeOfString:@"<html" options:NSCaseInsensitiveSearch];
    
    if (divRange.location != NSNotFound)
    {
        return YES;
    }
    return NO;
}

+ (NSString *)getSpecifiedFormat_OfDate:(NSDate *)date {
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"dd-MMM-yy HH:mm:ss"];
	NSString *stringFromDate = [formatter stringFromDate:date];
	
	return stringFromDate;
}

+ (NSString *)getFormattedDateFromString:(NSString *)dateString {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];  //  2015-02-26 17:05:30 - input
    NSDate *date = [formatter dateFromString:dateString];
    [formatter setDateFormat:@"dd-MMM-yy HH:mm:ss"];//output
    NSString *stringFromDate = [formatter stringFromDate:date];
    
    return stringFromDate;
}

+(NSDate *)getUTCFormateDate:(NSDate *)localDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [dateFormatter setTimeZone:timeZone];
   [dateFormatter setDateFormat:@"dd-MMM-yyyy HH:mm:ss Z"];
    
    NSString *dateString = [dateFormatter stringFromDate:localDate];
    
     NSDate *date=[dateFormatter dateFromString:dateString];
    return date;
}



+ (NSString *)getDateAndTimeString_OfCurrentDate {
	struct timeval tv;
	struct tm *ptm;

	if(gettimeofday(&tv, NULL) == -1) {
		tv.tv_usec = 0;
	}	
	ptm = localtime (&tv.tv_sec);
	NSString *DateTimeStr = [NSString stringWithFormat:@"%02d%02d%02d_%02d%02d%02d.%06d", ptm->tm_mday, (ptm->tm_mon +1), (ptm->tm_year + 1900), ptm->tm_hour, ptm->tm_min, ptm->tm_sec, tv.tv_usec];
	
	return DateTimeStr;
}

+ (NSString *)handlingSpecialCharactersWhileSendingRequest:(NSString *) aContentString
{
	NSString *resultsString = aContentString;

	resultsString =[resultsString stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"];
	
	resultsString =[resultsString stringByReplacingOccurrencesOfString:@"'" withString:@"&#39;"];
	
	return resultsString;
}

+ (BOOL)isSubStringOfBaseString:(NSString *)baseString subString:(NSString *)subString {
    NSRange range = [baseString rangeOfString:subString]; 
    BOOL found = (range.location != NSNotFound);  
    return found; 
}

+ (NSDate *)getDateObjectWithGivenString:(NSString *)aStringObject
{
	NSRange timeRange;
	timeRange.location = 0;
	timeRange.length = [aStringObject length]-2;
	NSString *dateString = [aStringObject substringWithRange:timeRange];
	
	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];				
	[dateFormat setDateFormat:@"MM-dd-yyyy HH:mm:ss"];
	NSDate *dateObj = [dateFormat dateFromString:dateString];
	return dateObj;
}


+(NSNumber *)convertStringToNumber:(NSString *)string
{
    NSNumberFormatter * formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber * number = [formatter numberFromString:string];
    return number;
}


+(void)setCurrentTimestampInDB:(NSString *)currentTimeStamp
{
    NSUserDefaults *currentDBTime = [NSUserDefaults standardUserDefaults];
    [currentDBTime setObject:currentTimeStamp forKey:@"CURRENTDBTIME"];
    [currentDBTime synchronize];
}



+(NSString *)getCurrentTimestampInDB{
    
    NSString * emptyString = @"";
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"CURRENTDBTIME"])
    {
        return [[NSUserDefaults standardUserDefaults] objectForKey:@"CURRENTDBTIME"];
    }
    return emptyString;
}

+(void)setCurrentTimestampInDBForVelocityData:(NSString *)currentTimeStamp forKey:(NSString *)customAndSegmentID
{
    NSUserDefaults *currentDBTime = [NSUserDefaults standardUserDefaults];
    [currentDBTime setObject:currentTimeStamp forKey:customAndSegmentID];
    [currentDBTime synchronize];
}
+(NSString *)getCurrentTimestampInDBForVelocityDataForKey:(NSString *)customAndSegmentID
{
    NSString * emptyString = @"";
    if([[NSUserDefaults standardUserDefaults] objectForKey:customAndSegmentID])
    {
        return [[NSUserDefaults standardUserDefaults] objectForKey:customAndSegmentID];
    }
    return emptyString;
}

+(NSString *)fetchDocumentsDirectoryPath
{
    NSArray* documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
    NSString* documentDirectory = [documentDirectories objectAtIndex:0];
    return documentDirectory;
}


+(NSString *) timeStamp {
    return [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970] * 1000];
}

/*
+(NSString *)getFetchAlertURLPath
{
    if( [[SIUtiliesController activeAlertLibraryBundlePath] objectForInfoDictionaryKey:kTarget]){
        NSString *target =  [[SIUtiliesController activeAlertLibraryBundlePath] objectForInfoDictionaryKey:kTarget];
        NSString *fetchAlertString = @"";
        if([[SIUtiliesController activeAlertLibraryBundlePath] objectForInfoDictionaryKey:target]){
            NSDictionary *dicTarget = [[NSDictionary alloc]initWithDictionary:[[SIUtiliesController activeAlertLibraryBundlePath] objectForInfoDictionaryKey:target]];
            if([dicTarget objectForKey:kActiveAlertFetchURL]){
                fetchAlertString = [dicTarget objectForKey:kActiveAlertFetchURL];
            }
            return fetchAlertString;
        }
    }
    return nil;
}
*/

+(NSString *)getFetchAlertURLPath
{
    NSDictionary *dicSellingIntelligenceConfig = [[NSDictionary alloc]initWithDictionary:[SIUtiliesController soSellingIntelligenceConfig]];
    if([dicSellingIntelligenceConfig objectForKey:kTarget]){
        NSString *target =  [dicSellingIntelligenceConfig objectForKey:kTarget];
        NSString *fetchAlertString = @"";
        if([dicSellingIntelligenceConfig objectForKey:target]){
            NSDictionary *dicTarget = [[NSDictionary alloc]initWithDictionary:[dicSellingIntelligenceConfig objectForKey:target]];
            if([dicTarget objectForKey:kActiveAlertFetchURL]){
                fetchAlertString = [dicTarget objectForKey:kActiveAlertFetchURL];
            }
            return fetchAlertString;
        }
    }
    return nil;
}

+(NSString *)getVersionNumber{
     NSDictionary *dicSellingIntelligence = [[NSDictionary alloc]initWithDictionary:[SIUtiliesController soSellingIntelligenceConfig]];
    NSString *version = @"";
    if([dicSellingIntelligence objectForKey:kVersion]){
        version = [NSString stringWithFormat:@"V %@",[dicSellingIntelligence objectForKey:kVersion]];
    }
    return version;
}

/*
+(NSString *)getSubmitAlertURLPath
{
    if( [[SIUtiliesController activeAlertLibraryBundlePath] objectForInfoDictionaryKey:kTarget]){
        NSString *target =  [[SIUtiliesController activeAlertLibraryBundlePath] objectForInfoDictionaryKey:kTarget];
        NSString *submitAlertString = @"";
        if([[SIUtiliesController activeAlertLibraryBundlePath] objectForInfoDictionaryKey:target]){
            NSDictionary *dicTarget = [[NSDictionary alloc]initWithDictionary:[[SIUtiliesController activeAlertLibraryBundlePath] objectForInfoDictionaryKey:target]];
            if([dicTarget objectForKey:kActiveAlertSubmitURL]){
                submitAlertString = [dicTarget objectForKey:kActiveAlertSubmitURL];
            }
            return submitAlertString;
        }
    }
    return nil;
}
*/

+(NSString *)getSubmitAlertURLPath
{
     NSDictionary *dicSellingIntelligenceConfig = [[NSDictionary alloc]initWithDictionary:[SIUtiliesController soSellingIntelligenceConfig]];
    if([dicSellingIntelligenceConfig objectForKey:kTarget]){
        NSString *target =  [dicSellingIntelligenceConfig objectForKey:kTarget];
        NSString *submitAlertString = @"";
        if([dicSellingIntelligenceConfig objectForKey:target]){
            NSDictionary *dicTarget = [[NSDictionary alloc]initWithDictionary:[dicSellingIntelligenceConfig objectForKey:target]];
            if([dicTarget objectForKey:kActiveAlertSubmitURL]){
                submitAlertString = [dicTarget objectForKey:kActiveAlertSubmitURL];
            }
            return submitAlertString;
        }
    }
    return nil;
}

+(NSBundle *)activeAlertLibraryBundlePath{
    
    NSString* mainBundlePath = [[NSBundle mainBundle] resourcePath];
    NSString* frameworkBundlePath = [mainBundlePath stringByAppendingPathComponent:kSIBundle];
    NSBundle *frameworkBundle = [NSBundle bundleWithPath:frameworkBundlePath];
    return frameworkBundle;
}

/*
+(NSString *)getProductCatalogueImageDownloadPath{
    if( [[SIUtiliesController activeAlertLibraryBundlePath] objectForInfoDictionaryKey:kTarget]){
        NSString *target =  [[SIUtiliesController activeAlertLibraryBundlePath] objectForInfoDictionaryKey:kTarget];
        NSString *productCatalogueImagePath = @"";
        if([[SIUtiliesController activeAlertLibraryBundlePath] objectForInfoDictionaryKey:target]){
            NSDictionary *dicTarget = [[NSDictionary alloc]initWithDictionary:[[SIUtiliesController activeAlertLibraryBundlePath] objectForInfoDictionaryKey:target]];
            if([dicTarget objectForKey:kProductcatalogueImageBaseURL]){
                 NSString *imagePath = [dicTarget objectForKey:kProductcatalogueImageBaseURL];
                productCatalogueImagePath = [NSString stringWithFormat:@"%@%@",imagePath,kProductCatalogueImagePath];
            }
            return productCatalogueImagePath;
        }
    }
    return nil;
}
*/

+(NSString *)getProductCatalogueImageDownloadPath{
    NSDictionary *dicSellingIntelligenceConfig = [[NSDictionary alloc]initWithDictionary:[SIUtiliesController soSellingIntelligenceConfig]];
    if([dicSellingIntelligenceConfig objectForKey:kTarget]){
       NSString *target =  [dicSellingIntelligenceConfig objectForKey:kTarget];
        NSString *productCatalogueImagePath = @"";
       if([dicSellingIntelligenceConfig objectForKey:target]){
            NSDictionary *dicTarget = [[NSDictionary alloc]initWithDictionary:[dicSellingIntelligenceConfig objectForKey:target]];
            if([dicTarget objectForKey:kProductcatalogueImageBaseURL]){
                NSString *imagePath = [dicTarget objectForKey:kProductcatalogueImageBaseURL];
                productCatalogueImagePath = [NSString stringWithFormat:@"%@%@",imagePath,kProductCatalogueImagePath];
            }
            return productCatalogueImagePath;
        }
    }
    return nil;
}

/*
+(NSString *)getPurePlayImageDownloadPath{
    if( [[SIUtiliesController activeAlertLibraryBundlePath] objectForInfoDictionaryKey:kTarget]){
        NSString *target =  [[SIUtiliesController activeAlertLibraryBundlePath] objectForInfoDictionaryKey:kTarget];
        NSString *purePlayImagePath = @"";
        if([[SIUtiliesController activeAlertLibraryBundlePath] objectForInfoDictionaryKey:target]){
            NSDictionary *dicTarget = [[NSDictionary alloc]initWithDictionary:[[SIUtiliesController activeAlertLibraryBundlePath] objectForInfoDictionaryKey:target]];
            if([dicTarget objectForKey:kPurePlayImageBaseURL]){
                NSString *imagePath = [dicTarget objectForKey:kPurePlayImageBaseURL];
                purePlayImagePath = [NSString stringWithFormat:@"%@%@",imagePath,kPurePlayImagePath];
            }
            return purePlayImagePath;
        }
    }
    return nil;
}
*/

+(NSString *)getPurePlayImageDownloadPath{
     NSDictionary *dicSellingIntelligenceConfig = [[NSDictionary alloc]initWithDictionary:[SIUtiliesController soSellingIntelligenceConfig]];
    if([dicSellingIntelligenceConfig objectForKey:kTarget]){
       NSString *target =  [dicSellingIntelligenceConfig objectForKey:kTarget];
        NSString *purePlayImagePath = @"";
        if([dicSellingIntelligenceConfig objectForKey:target]){
            NSDictionary *dicTarget = [[NSDictionary alloc]initWithDictionary:[dicSellingIntelligenceConfig objectForKey:target]];
            if([dicTarget objectForKey:kPurePlayImageBaseURL]){
                NSString *imagePath = [dicTarget objectForKey:kPurePlayImageBaseURL];
                purePlayImagePath = [NSString stringWithFormat:@"%@%@",imagePath,kPurePlayImagePath];
            }
            return purePlayImagePath;
        }
    }
    return nil;
}


+(void)setLibraryInputsDict:(NSDictionary *)libInputsObject
{
    NSUserDefaults *userData = [NSUserDefaults standardUserDefaults];
    [userData setObject:libInputsObject forKey:@"LIBRARYINPUTS"];
    [userData synchronize];
}
+(NSDictionary *)getLibraryInputs
{
    NSDictionary *value=[NSDictionary dictionary];
    NSUserDefaults *userData = [NSUserDefaults standardUserDefaults];
    value = [userData valueForKey:@"LIBRARYINPUTS"];
    [userData synchronize];
    return value;
}


+(void)setAnnotationObject:(NSDictionary *)annotationObject
{
    NSUserDefaults *userData = [NSUserDefaults standardUserDefaults];
    [userData setObject:annotationObject forKey:@"CURRENTANNOTATIONOBJECT"];
    [userData synchronize];
}
+(NSDictionary *)getAnnotationObject
{
    NSDictionary *value=[NSDictionary dictionary];
    NSUserDefaults *userData = [NSUserDefaults standardUserDefaults];
    value = [userData valueForKey:@"CURRENTANNOTATIONOBJECT"];
    [userData synchronize];
    return value;
}

+(BOOL)isValid:(id)value;
{
     if([value isEqualToString:@"null"] || [value isEqual:[NSNull null]] || [value isEqualToString:@""])
         return NO;
    else
        return YES;
}

+(NSDictionary *)soWebserviceErrorDict
{
    NSString* filePath = [[SIUtiliesController activeAlertLibraryBundlePath] pathForResource:@"SIServiceAdapatorErrorList"
                                                         ofType:@"plist"];
    NSDictionary* plist = [NSDictionary dictionaryWithContentsOfFile:filePath];
    
    return plist;
}

+(NSDictionary *)soSellingIntelligenceConfig
{
    NSString* filePath = [[NSBundle mainBundle] pathForResource:@"SellingIntelligenceConfig"
                                                         ofType:@"plist"];
    NSDictionary* plist = [NSDictionary dictionaryWithContentsOfFile:filePath];
    
    return plist;
}

+(NSDictionary *)soSellingIntelligencePlist
{
    NSString* filePath = [[SIUtiliesController activeAlertLibraryBundlePath] pathForResource:@"SellingIntelligenceLib"
                                                         ofType:@"plist"];
    NSDictionary* plist = [NSDictionary dictionaryWithContentsOfFile:filePath];
    
    return plist;
}

+ (UIInterfaceOrientation)fetchCurrentInterfaceOrientation
{
    return [UIApplication sharedApplication].statusBarOrientation;
}

+ (UIDeviceOrientation)fetchCurrentDeviceOrientation
{
    return [UIDevice currentDevice].orientation;
}

+(NSString *)pathToUnzippedAlertImages
{
    NSString *path = [self fetchDocumentsDirectoryPath];
    NSString *directoryName = kFileNameForDownloadedProductAlertImages;
    NSString *filePathAndDirectory = [path stringByAppendingPathComponent:directoryName];
    return filePathAndDirectory;
}

+(BOOL)saveProductImageToDocumentDirectory:(NSData*)imgData fileName:(NSString *)strFileName
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *filePath  = [SIUtiliesController pathToUnzippedAlertImages];
    
    [fileManager createDirectoryAtPath:[NSString stringWithFormat:@"%@",filePath] withIntermediateDirectories:YES attributes:nil error:nil];
    
    NSString *fileName=[strFileName  stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    filePath=[filePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",fileName]];
    
    if ([SIUtiliesController isImageValid:imgData])
    {
        BOOL saveSuccess = [imgData writeToFile:filePath options:NSDataWritingFileProtectionComplete error:nil];
        
        if(saveSuccess)
            DebugLog(@"Image downloaded  Success");
        
        NSError *attributesError = nil;
        
        NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:&attributesError];
        NSNumber *fileSizeNumber = [fileAttributes objectForKey:NSFileSize];
        
        if ([fileSizeNumber intValue] >2000) {
           return YES;
        }
        else
        {
            [fileManager removeItemAtPath:filePath error:&attributesError];
            return NO;
        }
    }
    DebugLog(@"Image download failed");
    return NO;
}

+(BOOL)isImageValid:(NSData *)data
{
    BOOL val = YES;
    
    if ([data length] < 4)
        val = NO;
    
    const char * bytes = (const char *)[data bytes];
    
    if (bytes[0] != (char)0x89 || bytes[1] != (char)0x50)
        val = NO;
    
    if (bytes[[data length] - 2] != (char)0x60 ||
        bytes[[data length] - 1] != (char)0x82)
        val = NO;
    
    return val;
}

+(NSString *)applicationDocumentsDirectory {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

+(UIImage *)getAlertImageFromDirectory:(NSString *)strFileName{
    NSString *filePath  = [SIUtiliesController pathToUnzippedAlertImages];
    NSString *fileName=[strFileName  stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    filePath=[filePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",fileName]];
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfFile:filePath]];
    return image;
}



@end
