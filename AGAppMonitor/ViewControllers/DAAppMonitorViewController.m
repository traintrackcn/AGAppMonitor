//
//  DALogsViewController.m
//  Distributors
//
//  Created by Tao Yunfei on 1/18/16.
//  Copyright © 2016 AboveGEM. All rights reserved.
//

#import "DAAppMonitorViewController.h"
#import "AGViewController.h"
#import "AGViewController+Separator.h"
#import "DAAppMonitor.h"
#import "DALogDetailTriggerCell.h"
#import "DAAppMonitorLogViewController.h"
//#import "DAHeaderViewStyleCompact.h"
#import "CocoaLumberjack/CocoaLumberjack.h"


typedef NS_ENUM(NSInteger, Section) {
    SectionLog,
    SectionException,
    SectionCount
};

typedef NS_ENUM(NSInteger, SectionExceptionCell) {
    SectionExceptionCellCrashWithBadSignal,
    SectionExceptionCellCrashWithUncaughtException,
    SectionExceptionCellCount
};

@interface DAAppMonitorViewController(){
    
}


@end

@implementation DAAppMonitorViewController

- (instancetype)init{
    self = [super init];
    if (self) {
        [self setTitle:@"App Monitor"];
        [self.config setCellCls:[DALogDetailTriggerCell class] inSection:SectionLog];
        [self.config setCellCls:[DALogDetailTriggerCell class] inSection:SectionException];
        [self setBackgroundColor:[UIColor lightGrayColor]];
        
//        for (NSInteger section = 0; section < SectionCount; section ++) {
//            [self.config setHeaderCls:[DAHeaderViewStyleCompact class] forSection:section];
//        }
        
        [self enableSeparators];
    }
    return self;
}

#pragma mark - table view stuff

- (NSInteger)numberOfSections{
    return SectionCount;
}

- (NSInteger)numberOfRowsInSection:(NSInteger)section{
    if (section == SectionLog) return self.logFileInfos.count;
    if (section == SectionException) return SectionExceptionCellCount;
    return 0;
}

- (id)valueAtIndexPath:(NSIndexPath *)indexPath{
    id value;
    NSInteger section = indexPath.section;
    NSInteger idx = indexPath.row;
    
    if (section == SectionLog) {
        NSArray *arr = [[[self.logFileInfos objectAtIndex:idx] fileName] componentsSeparatedByString:@" "];
        value = arr.lastObject;
    }
    
    if (section == SectionException) {
        if (idx == SectionExceptionCellCrashWithBadSignal) {
            value = @"Crash app with bad signal";
        }
        
        if (idx == SectionExceptionCellCrashWithUncaughtException) {
            value = @"Crash app with uncaught exception";
        }
    }
    
    return value;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger section = indexPath.section;
    NSInteger idx = indexPath.row;
    if (section == SectionLog) {
        DDLogFileInfo *item = [self.logFileInfos objectAtIndex:idx];
        DAAppMonitorLogViewController *vc = [DAAppMonitorLogViewController instance];
        [vc setItem:item];
        [self pushViewController:vc];
    }
    
    
    if (section == SectionException) {
        if (idx == SectionExceptionCellCrashWithBadSignal) {
            [self crashAppWithBadSignal];
        }
        
        if (idx == SectionExceptionCellCrashWithUncaughtException) {
            [self crashAppWithUncaughtException];
        }
    }
    
}

- (id)valueForHeaderOfSection:(NSInteger)section{
    id value = [super valueForHeaderOfSection:section];
    
    if (section == SectionLog) {
        value = @"Logs";
    }
    
    if (section == SectionException) {
        value = @"Simulate Exceptions";
    }
    
    return value;
}

#pragma mark - exception tools

- (void)crashAppWithBadSignal{
    strcpy(0, "bla");
}

- (void)crashAppWithUncaughtException{
    NSArray *arr = @[@"abc"];
    [arr objectAtIndex:10];
}


#pragma mark - properties

- (NSArray *)logFileInfos{
    return [DAAppMonitor singleton].logFileInfos;
}

@end
