//
//  TrackViewController.m
//  ChildTrack
//
//  Created by zzy on 14/01/2018.
//  Copyright © 2018 zzy. All rights reserved.
//

#import "TrackViewController.h"

@interface TrackViewController ()

@end

@implementation TrackViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"追踪他人";
    
    UIButton *scanQrCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    scanQrCodeBtn.backgroundColor = [UIColor colorWithHexString:@"de88a5"];
    [scanQrCodeBtn setTitle:@"扫描要追踪的二维码" forState:UIControlStateNormal];
    scanQrCodeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    scanQrCodeBtn.layer.cornerRadius = 10;
    scanQrCodeBtn.frame = CGRectMake(15, 95, ScreenW - 2*15, 50);
    [scanQrCodeBtn addTarget:self action:@selector(scanQrCodeClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:scanQrCodeBtn];

    UIButton *trackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    trackBtn.backgroundColor = [UIColor colorWithHexString:@"de88a5"];
    [trackBtn setTitle:@"开始追踪" forState:UIControlStateNormal];
    trackBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    trackBtn.layer.cornerRadius = 6;
    trackBtn.frame = CGRectMake(ScreenW-15-80, scanQrCodeBtn.bottom+30, 80, 35);
    [trackBtn addTarget:self action:@selector(trackBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:trackBtn];
    
    UITextField *contentTxt = [[UITextField alloc]init];
    contentTxt.frame = CGRectMake(scanQrCodeBtn.x, scanQrCodeBtn.bottom+33, trackBtn.x - 25 - scanQrCodeBtn.x, 30);
    contentTxt.placeholder = @"请输入要追踪的ID";
    contentTxt.borderStyle = UITextBorderStyleNone;
    contentTxt.font = [UIFont systemFontOfSize:14];
    contentTxt.textColor = [UIColor grayColor];
    contentTxt.tintColor = [UIColor colorWithHexString:@"ff4081"];
    contentTxt.clearButtonMode = UITextFieldViewModeAlways;
    [self.view addSubview:contentTxt];
    
    UIView *line = [[UIView alloc]init];
    line.frame = CGRectMake(contentTxt.x, contentTxt.bottom, contentTxt.width, 1);
    line.backgroundColor = [UIColor colorWithHexString:@"ff4081"];
    [self.view addSubview:line];
}

- (void)scanQrCodeClick {
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}

@end
