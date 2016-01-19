//
//  DATextCellStyleMore.m
//  Distributors
//
//  Created by Tao Yunfei on 12/1/15.
//  Copyright © 2015 AboveGEM. All rights reserved.
//

#import "DALogDetailTriggerCell.h"
#import "GlobalDefine.h"

@implementation DALogDetailTriggerCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self.borderBottomViewStylePaddingL removeFromSuperview];
        
        [self.contentView addSubview:self.borderTopViewStyleSolid];
        [self.contentView addSubview:self.borderBottomViewStyleSolid];
    }
    return self;
}

#pragma mark - styles

//- (void)applySelectedStyle{
//    
//}

- (UIColor *)borderColor{
    return RGBA(233, 233, 233, 1);
}

@end
