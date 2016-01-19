//
//  DAAppMonitor.h
//  Distributors
//
//  Created by Tao Yunfei on 1/18/16.
//  Copyright © 2016 AboveGEM. All rights reserved.
//

#import "AGModel.h"
#import "NSObject+Singleton.h"

@interface DAAppMonitor : AGModel

#pragma mark - flurry stuff
- (void)enableWithFlurryAPIKey:(NSString *)key flurryCrashReporter:(BOOL)flurryCrashReporter;
- (void)flurryLogEvent:(NSString *)event;

- (NSArray *)logFileInfos;

@end
