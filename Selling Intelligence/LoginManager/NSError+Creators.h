//
//  NSError+Creators.h
//  WorkWith
//
//  Created by Fowler, John - Contractor {BIS} on 2/28/13.
//  Copyright (c) 2013 PepsiCo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSError (Creators)

+(NSError *)appError:(NSString *)localizedDescription;
+(NSError *)appError:(NSString *)localizedDescription withCode:(NSUInteger)code;

@end
