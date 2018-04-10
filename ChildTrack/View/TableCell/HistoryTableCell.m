//
//  HistoryTableCell.m
//  ChildTrack
//
//  Created by zzy on 28/02/2018.
//  Copyright © 2018 zzy. All rights reserved.
//

#import "HistoryTableCell.h"
#import "HistoryFrameModel.h"

static NSString *cellID = @"CellID";

@interface HistoryTableCell()<UIAlertViewDelegate>

/** 身份ID */
@property (nonatomic, strong)UILabel *identifyLbl;
/** 备注 */
@property (nonatomic, strong)UILabel *remarkLbl;

@end

@implementation HistoryTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.identifyLbl = [[UILabel alloc]init];
        self.identifyLbl.textColor = [UIColor grayColor];
        self.identifyLbl.font = [UIFont systemFontOfSize:15];
        self.identifyLbl.textAlignment = NSTextAlignmentLeft;
        self.identifyLbl.numberOfLines = 0;
        [self addSubview:self.identifyLbl];
        
        self.remarkLbl = [[UILabel alloc]init];
        self.remarkLbl.textColor = [UIColor orangeColor];
        self.remarkLbl.font = [UIFont systemFontOfSize:15];
        self.remarkLbl.textAlignment = NSTextAlignmentLeft;
        self.remarkLbl.numberOfLines = 0;
        [self addSubview:self.remarkLbl];
        
        UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress:)];
        longPressGesture.minimumPressDuration = 1.0f;//设置长按 时间
        [self addGestureRecognizer:longPressGesture];
    }
    
    return self;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    self.identifyLbl.frame = self.frameModel.identifyLblFrame;
    
    self.remarkLbl.frame = self.remarkLbl.frame;
}

- (void)setFrameModel:(HistoryFrameModel *)frameModel {
    
    _frameModel = frameModel;
    self.identifyLbl.text = frameModel.historyDict[@"id"];
    self.remarkLbl.text = frameModel.historyDict[@"remark"];
    [self setNeedsLayout];
}

+ (instancetype)cellWithTableView:(UITableView *)table {
    
    HistoryTableCell *cell = [table dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        
        cell = [[HistoryTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}

- (void)longPress:(UILongPressGestureRecognizer *)longRecognizer {
    
    if (longRecognizer.state == UIGestureRecognizerStateBegan) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"添加备注名" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
        UITextField *txtName = [alert textFieldAtIndex:0];
        txtName.placeholder = @"请输入备注名称";
        [alert show];
    }
}

#pragma mark -- UIAlertViewDelegate --
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 1) {
        
        UITextField *txt = [alertView textFieldAtIndex:0];
        NSDictionary *dict = @{
                               @"id":self.frameModel.historyDict[@"id"],
                               @"remark":txt.text
                               };
        self.frameModel.historyDict = dict;
        
        if ([self.delegate respondsToSelector:@selector(addRemark:)]) {
            
            [self.delegate addRemark:self.frameModel];
        }
    }
}
@end
