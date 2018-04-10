//
//  HistoryFrameModel.m
//  ChildTrack
//
//  Created by zzy on 28/02/2018.
//  Copyright © 2018 zzy. All rights reserved.
//

#import "HistoryFrameModel.h"

@implementation HistoryFrameModel

- (void)setHistoryDict:(NSDictionary *)historyDict {
    
    _historyDict = historyDict;
    
    NSString *identify = historyDict[@"id"];
    NSString *remark = historyDict[@"remark"];
    CGFloat w = ScreenW - 2*15;
    UIFont *font = [UIFont systemFontOfSize:15];
    
    CGRect identifyLblRect = [identify boundingRectWithSize:CGSizeMake(w, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil];
    self.identifyLblFrame = CGRectMake(0, 0, w, identifyLblRect.size.height);
    
    CGRect remarkLblRect = [remark boundingRectWithSize:CGSizeMake(w, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil];
    self.remarkLblFrame = CGRectMake(0, CGRectGetMaxY(identifyLblRect) + 5, w, remarkLblRect.size.height);

    self.cellHeight = remark.length == 0 ? CGRectGetMaxY(self.identifyLblFrame) + 10 : CGRectGetMaxY(self.remarkLblFrame) + 10;
}

@end
