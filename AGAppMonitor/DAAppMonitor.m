//
//  DAAppMonitor.m
//  Distributors
//
//  Created by Tao Yunfei on 1/18/16.
//  Copyright © 2016 AboveGEM. All rights reserved.
//

#import "DAAppMonitor.h"
#import "DAXcodeLoggerFormatter.h"
#import "CocoaLumberjack/CocoaLumberjack.h"
#import <CrashReporter/CrashReporter.h>
#import "Flurry.h"
#import "DAFileLoggerFormatter.h"

@interface DAAppMonitor(){
    
}

@property (nonatomic, strong) DDFileLogger *fileLogger;
@property (nonatomic, strong) DAXcodeLoggerFormatter *xcLoggerFormatter;
@property (nonatomic, strong) DAFileLoggerFormatter *fileLoggerFormatter;



@end

@implementation DAAppMonitor

- (instancetype)init{
    self = [super init];
    if (self) {
        [self enableLogTool];
    }
    return self;
}

#pragma mark -

- (void)enableWithFlurryAPIKey:(NSString *)key flurryCrashReporter:(BOOL)flurryCrashReporter{
    
    
    if (flurryCrashReporter) {
        [Flurry setCrashReportingEnabled:YES];
    }else{
        [self enablePLCrashReporter];
    }
    
    if (key) [Flurry startSession:key];
    
}


#pragma mark - flurry tool stuff

- (void)flurryLogEvent:(NSString *)event{
    [Flurry logEvent:event];
}

#pragma mark - crash reporter stuff

- (void)enablePLCrashReporter{
    
    PLCrashReporter *crashReporter = [PLCrashReporter sharedReporter];
    NSError *error;
    // Check if we previously crashed
    if ([crashReporter hasPendingCrashReport]) [self handleCrashReport];
    
    // Enable the Crash Reporter
    if (![crashReporter enableCrashReporterAndReturnError: &error]){
        DDLogWarn(@"Could not enable crash reporter: %@", error);
    }else{
        DDLogInfo(@"Crash Reporter enabled");
    }
}


- (void)handleCrashReport {
    PLCrashReporter *crashReporter = [PLCrashReporter sharedReporter];
    NSData *crashData;
    NSError *error;
    
         // Try loading the crash report
    crashData = [crashReporter loadPendingCrashReportDataAndReturnError: &error];
    if (crashData == nil) {
        DDLogDebug(@"Could not load crash report: %@", error);
        [crashReporter purgePendingCrashReport];
        return;
    }
    
    // We could send the report from here, but we'll just print out
    // some debugging info instead
    PLCrashReport *report = [[PLCrashReport alloc] initWithData: crashData error: &error];
    if (report == nil) {
        DDLogDebug(@"Could not parse crash report");
        return;
    }else{
        DDLogError(@"Crashed: \n%@ ", [self formattedCrashReport:report]);
    }
    
    [crashReporter purgePendingCrashReport];
}

- (NSString *)formattedCrashReport:(PLCrashReport *)report{
    NSMutableArray *arr = [NSMutableArray array];
    if(report.systemInfo) [arr addObject:[self formattedSystemInfo:report.systemInfo]];
//    if(report.hasMachineInfo) [arr addObject:[self formattedMachineInfo:report.machineInfo]];
    if(report.applicationInfo)[arr addObject:[self formattedApplicationInfo:report.applicationInfo]];
    [arr addObject:[NSString stringWithFormat:@"images -> %ld", (unsigned long)report.images.count]];
    if (report.signalInfo) [arr addObject:[self formattedSignalInfo:report.signalInfo]];
    if (report.hasExceptionInfo) [arr addObject:[self formattedExceptionInfo:report.exceptionInfo]];
    
//    NSString *uuidStr = [self uuidStringFrom:report.uuidRef];
//    if (uuidStr) [arr addObject:[NSString stringWithFormat:@"%@", uuidStr]];
    
    return [arr componentsJoinedByString:@"\n"];
}

- (NSString *)formattedSystemInfo:(PLCrashReportSystemInfo *)systemInfo{
    NSMutableArray *arr = [NSMutableArray array];
    NSString *systemName = [self nameOfSystem:systemInfo.operatingSystem];
    [arr addObject:[NSString stringWithFormat:@"%@ %@",systemName, [systemInfo operatingSystemVersion]]];
    return [arr componentsJoinedByString:@"\n"];
}

- (NSString *)nameOfSystem:(PLCrashReportOperatingSystem)system{
    if (system == PLCrashReportOperatingSystemiPhoneOS) {
        return @"iOS";
    }else if (system == PLCrashReportOperatingSystemiPhoneSimulator) {
        return  @"iOS Simulator";
    }else if (system == PLCrashReportOperatingSystemMacOSX) {
        return @"Mac OS";
    }
    return @"Unknown OS";
}

- (NSString *)formattedApplicationInfo:(PLCrashReportApplicationInfo *)applicationInfo{
    NSMutableArray *arr = [NSMutableArray array];
    [arr addObject:[NSString stringWithFormat:@"%@ %@", applicationInfo.applicationIdentifier, applicationInfo.applicationVersion]];
    return [arr componentsJoinedByString:@"\n"];
}

- (NSString *)formattedMachineInfo:(PLCrashReportMachineInfo *)machineInfo{
    NSMutableArray *arr = [NSMutableArray array];
    [arr addObject:machineInfo.modelName];
    return [arr componentsJoinedByString:@"\n"];
}

- (NSString *)formattedExceptionInfo:(PLCrashReportExceptionInfo *)exceptionInfo{
    NSMutableArray *arr = [NSMutableArray array];
    [arr addObject:[NSString stringWithFormat:@"%@ %@", exceptionInfo.exceptionName, exceptionInfo.exceptionReason]];
    
    if (exceptionInfo.stackFrames) {
        [arr addObject:[self formattedStackFrames:exceptionInfo.stackFrames]];
    }
    
    return [arr componentsJoinedByString:@"\n"];
}

- (NSString *)formattedStackFrames:(NSArray *)stackFrames{
    NSMutableArray *arr = [NSMutableArray array];
    for (NSInteger i = 0; i<stackFrames.count; i++) {
        PLCrashReportStackFrameInfo *item = [stackFrames objectAtIndex:i];
        if (item.symbolInfo) [arr addObject:item.symbolInfo.symbolName];
    }
    return [arr componentsJoinedByString:@"\n"];
}


- (NSString *)formattedSignalInfo:(PLCrashReportSignalInfo *)signalInfo{
    NSMutableArray *arr = [NSMutableArray array];
    [arr addObject:[NSString stringWithFormat:@"Signal %@ (code %@, address=0x%" PRIx64 ")", signalInfo.name,
                    signalInfo.code, signalInfo.address]];
    return [arr componentsJoinedByString:@"\n"];
}

- (NSString *)uuidStringFrom:(CFUUIDRef)uuidRef{
    CFStringRef str = CFUUIDCreateString(NULL, uuidRef);
    return (__bridge_transfer NSString *)str;
}

#pragma mark - log tool stuff

- (void)enableLogTool{
    [DDLog addLogger:[DDTTYLogger sharedInstance] withLevel:DDLogLevelVerbose]; // TTY = Xcode console
    [[DDTTYLogger sharedInstance] setLogFormatter:self.xcLoggerFormatter];
    //    [DDLog addLogger:[DDASLLogger sharedInstance]]; // ASL = Apple System Logs
    
    [DDLog addLogger:self.fileLogger withLevel:DDLogLevelVerbose];
    [self.fileLogger setLogFormatter:self.fileLoggerFormatter];
}

- (id<DDLogFileManager>)logFileManager{
    return self.fileLogger.logFileManager;
}

- (NSArray *)logFileInfos{
    return [self.logFileManager sortedLogFileInfos];
}

- (DAXcodeLoggerFormatter *)xcLoggerFormatter{
    if (!_xcLoggerFormatter) {
        _xcLoggerFormatter = [[DAXcodeLoggerFormatter alloc] init];
    }
    return _xcLoggerFormatter;
}

- (DAFileLoggerFormatter *)fileLoggerFormatter{
    if (!_fileLoggerFormatter) {
        _fileLoggerFormatter = [[DAFileLoggerFormatter alloc] init];
    }
    return _fileLoggerFormatter;
}

- (DDFileLogger *)fileLogger{
    if (!_fileLogger) {
        _fileLogger = [[DDFileLogger alloc] init]; // File Logger
        _fileLogger.rollingFrequency = 60*60*24 ; // 24 hour rolling
        _fileLogger.logFileManager.maximumNumberOfLogFiles = 7;
    }
    return _fileLogger;
}

@end
