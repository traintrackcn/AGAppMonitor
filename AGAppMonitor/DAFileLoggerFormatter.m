//
//  DAFileLoggerFormatter.m
//  AGAppMonitor
//
//  Created by Tao Yunfei on 1/19/16.
//  Copyright © 2016 AboveGEM. All rights reserved.
//

#import "DAFileLoggerFormatter.h"

@implementation DAFileLoggerFormatter


- (NSString *)formatLogMessage:(DDLogMessage *)logMessage{
//    NSString *logLevel;
//    NSInteger flag = logMessage.flag;
    
//    switch (logMessage.flag) {
//        case DDLogFlagError    : logLevel = @"E"; break;
//        case DDLogFlagWarning  : logLevel = @"W"; break;
//        case DDLogFlagInfo     : logLevel = @"I"; break;
//        case DDLogFlagDebug    : logLevel = @"D"; break;
//        default                : logLevel = @"V"; break;
//    }
    
    //    NSString *dateStr = [self.dateFormatter stringFromDate:logMessage.timestamp];
    
    return [NSString stringWithFormat:@"%@:%ld %@", logMessage.function, logMessage.line,logMessage.message];
}

@end
