//
//  HistoryTableCell.h
//  ChildTrack
//
//  Created by zzy on 28/02/2018.
//  Copyright © 2018 zzy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HistoryFrameModel;

@protocol HistoryTableCellDelegate<NSObject>

- (void)addRemark:(HistoryFrameModel*)frameModel;

@end

@interface HistoryTableCell : UITableViewCell

/**  */
@property (nonatomic, strong)HistoryFrameModel *frameModel;
/** <##> */
@property (nonatomic, weak) id<HistoryTableCellDelegate> delegate;

+ (instancetype)cellWithTableView:(UITableView *)table;

@end
