//
//  ReachabilityMonitor.h
//  SecurityPatternApp
//
//  Created by Fowler, John - Contractor {BIS} on 3/27/13.
//  Copyright (c) 2013 PepsiCo. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Reachability.h"


@protocol ReachabilityMonitorDelegate <NSObject>
-(void)reachabilityChanged:(Reachability *)reachability;
@end


@interface ReachabilityMonitor : NSObject

@property (nonatomic, retain) Reachability *hostStatus;
@property (nonatomic, retain) NSMutableArray *reachabilityDelegates;

+(ReachabilityMonitor *)monitor;
+(BOOL)isHostReachable;

-(void)addDelegate:(id<ReachabilityMonitorDelegate>)delegate;
-(BOOL)isDelegate:(id<ReachabilityMonitorDelegate>)delegate;
-(id<ReachabilityMonitorDelegate>)removeDelegate:(id<ReachabilityMonitorDelegate>)delegate;

@end



@interface ReachabilityMonitorDelegateWeakRef : NSObject

@property (nonatomic, weak) id<ReachabilityMonitorDelegate> delegate;

+(ReachabilityMonitorDelegateWeakRef *)refFor:(id<ReachabilityMonitorDelegate>) delegate;

@end
