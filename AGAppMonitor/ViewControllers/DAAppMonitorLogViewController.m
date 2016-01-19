//
//  DAAppMonitorLogDetailViewController.m
//  Distributors
//
//  Created by Tao Yunfei on 1/19/16.
//  Copyright © 2016 AboveGEM. All rights reserved.
//

#import "DAAppMonitorLogViewController.h"
#import "CocoaLumberjack/CocoaLumberjack.h"
#import "AGUIDefine.h"
#import "GlobalDefine.h"

@interface DAAppMonitorLogViewController(){
    
}

@property (nonatomic, strong) UITextView *textBox;

@end

@implementation DAAppMonitorLogViewController

- (instancetype)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [self.view addSubview:self.textBox];
}

#pragma mark - setters

- (void)setItem:(DDLogFileInfo *)item{
    _item = item;
    [self.textBox setText:self.detail];
}

#pragma mark - components

- (UITextView *)textBox{
    if (!_textBox) {
        CGFloat w = STYLE_DEVICE_WIDTH;
        CGFloat h = STYLE_DEVICE_CONTENT_HEIGHT_WITH_STATUS_BAR_AND_NAVIGATION_BAR;
        CGFloat y = STYLE_STATUS_BAR_HEIGHT + STYLE_NAVIGATION_BAR_HEIGHT;
        CGFloat x = 0;
        _textBox = [[UITextView alloc] initWithFrame:CGRectMake(x, y, w, h)];
        [_textBox setFont:FONT_LIGHT_WITH_SIZE(14.0)];
        [_textBox setTextColor:RGBA(102,102,102,1)];
    }
    return _textBox;
}

#pragma mark - 

- (NSString *)detail{
    NSString *path = self.item.filePath;
        //    TLOG(@"self.logPath -> %@", self.logPath);
    if (!path) return @"No log founded.";
    return [NSString stringWithContentsOfFile:path
                                     encoding:NSUTF8StringEncoding
                                        error:NULL];
    
}

@end
