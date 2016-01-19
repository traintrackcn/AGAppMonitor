//
//  DAAppMonitorLogFormatter.m
//  Distributors
//
//  Created by Tao Yunfei on 1/19/16.
//  Copyright © 2016 AboveGEM. All rights reserved.
//

#import "DAXcodeLoggerFormatter.h"

@interface DAXcodeLoggerFormatter(){
//    int loggerCount;
}

//@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@end

@implementation DAXcodeLoggerFormatter

- (NSString *)formatLogMessage:(DDLogMessage *)logMessage{
//    NSString *logLevel;
//    
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


//- (void)didAddToLogger:(id <DDLogger>)logger {
//    loggerCount++;
//    NSAssert(loggerCount <= 1, @"This logger isn't thread-safe");
//}
//
//- (void)willRemoveFromLogger:(id <DDLogger>)logger {
//    loggerCount--;
//}


#pragma mark - 

//- (NSDateFormatter *)dateFormatter{
//    if (!_dateFormatter) {
//        _dateFormatter = [[NSDateFormatter alloc] init];
//        [_dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm:ss:SSS"];
//    }
//    return _dateFormatter;
//}

@end
