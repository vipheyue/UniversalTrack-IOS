//
//  HistoryFrameModel.h
//  ChildTrack
//
//  Created by zzy on 28/02/2018.
//  Copyright © 2018 zzy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HistoryFrameModel : NSObject

/**  */
@property(assign, nonatomic)CGRect identifyLblFrame;
/**  */
@property(assign, nonatomic)CGRect remarkLblFrame;
/**  */
@property(assign, nonatomic)CGFloat cellHeight;
/**  */
@property (nonatomic, strong)NSDictionary *historyDict;
/**  */
@property(assign, nonatomic)NSInteger indexPathRow;
@end
