//
//  DAAppMonitor.h
//  Distributors
//
//  Created by Tao Yunfei on 1/18/16.
//  Copyright © 2016 AboveGEM. All rights reserved.
//

#import "AGModel.h"
#import "NSObject+Singleton.h"


@class AGRemoterResult;

#define APP_MONITOR [DAAppMonitor singleton]

@interface DAAppMonitor : AGModel

#pragma mark - flurry stuff
- (void)enableWithFlurryAPIKey:(NSString *)key flurryCrashReporter:(BOOL)flurryCrashReporter;
- (void)logEvent:(NSString *)event;
- (void)logRemoterResult:(AGRemoterResult *)result;
- (NSArray *)logFileInfos;

@end
