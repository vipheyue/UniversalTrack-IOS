//
//  SoftAgreementViewController.m
//  ChildTrack
//
//  Created by zzy on 03/01/2018.
//  Copyright © 2018 zzy. All rights reserved.
//

#import "SoftAgreementViewController.h"
#import "MainViewController.h"
#import "BaseNavigationController.h"

@interface SoftAgreementViewController ()

@property (nonatomic, weak) UIButton *agreeBtn;

@end

@implementation SoftAgreementViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"全能追踪";
    UIButton *agreeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [agreeBtn setImage:[UIImage imageNamed:@"checkbox"] forState:UIControlStateNormal];
    [agreeBtn setImage:[UIImage imageNamed:@"checkbox_selected"] forState:UIControlStateSelected];
    [agreeBtn setTitle:@"同意协议" forState:UIControlStateNormal];
    [agreeBtn setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
    agreeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    agreeBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 4, 0, 0);
    [agreeBtn sizeToFit];
    agreeBtn.frame = CGRectMake(30, ScreenH - agreeBtn.height - 50, agreeBtn.width+4, agreeBtn.height);
    [agreeBtn addTarget:self action:@selector(agreeClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:agreeBtn];
    self.agreeBtn = agreeBtn;
    
    UIButton *startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [startBtn setTitle:@"开始使用" forState:UIControlStateNormal];
    startBtn.backgroundColor = [UIColor colorWithHexString:@"3f51b5"];
    startBtn.layer.cornerRadius = 25;
    CGFloat startBtnX = agreeBtn.right + 20;
    startBtn.frame = CGRectMake(startBtnX, 0, ScreenW - startBtnX - 20, 50);
    startBtn.centerY = agreeBtn.centerY;
    [startBtn addTarget:self action:@selector(startClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:startBtn];
    
    UIScrollView *scroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, kNavigationPlusStatusHeight, ScreenW, startBtn.y - 10 - kNavigationPlusStatusHeight)];
    [self.view addSubview:scroll];
    
    UILabel *agreementLbl = [[UILabel alloc]init];
    agreementLbl.numberOfLines = 0;
    agreementLbl.text = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"softagreement"ofType:@"txt"] encoding:NSUTF8StringEncoding error:nil];
    agreementLbl.textColor = [UIColor darkGrayColor];
    agreementLbl.font = [UIFont systemFontOfSize:15];
    agreementLbl.frame = CGRectMake(8, 8, ScreenW - 8 - 8, 0);
    [scroll addSubview:agreementLbl];
    
   CGRect agreementLblRect = [agreementLbl.text boundingRectWithSize:CGSizeMake(agreementLbl.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:agreementLbl.font} context:nil];
    agreementLbl.height = agreementLblRect.size.height;
    scroll.contentSize = CGSizeMake(0, agreementLbl.height + 8);
}

- (void)agreeClick:(UIButton *)sender {
    
    sender.selected = !sender.selected;
}

- (void)startClick {
    
    if (!self.agreeBtn.selected) {
        
        [SVProgressHUD showImage:nil status:@"请勾选同意软件协议！"];
        return;
    }
    
    [[CommUtils sharedInstance] saveAgreeSoftState:YES];
    MainViewController *mainVC = [[MainViewController alloc]init];
    BaseNavigationController *nav = [[BaseNavigationController alloc]initWithRootViewController:mainVC];
    mainVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:nav animated:YES completion:^{
        
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}
@end
