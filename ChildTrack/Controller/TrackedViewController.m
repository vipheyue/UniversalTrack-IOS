//
//  TrackedViewController.m
//  ChildTrack
//
//  Created by zzy on 14/01/2018.
//  Copyright © 2018 zzy. All rights reserved.
//

#import "TrackedViewController.h"
#import "SGQRCode.h"

@interface TrackedViewController ()

@end

@implementation TrackedViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"追踪我";
    
    UILabel *tipLbl = [[UILabel alloc]init];
    tipLbl.text = @"使用本软件，扫一扫二维码好友即可追踪你";
    tipLbl.font = [UIFont systemFontOfSize:14];
    tipLbl.textColor = [UIColor darkGrayColor];
    [tipLbl sizeToFit];
    tipLbl.frame = CGRectMake(0, 85, tipLbl.width, tipLbl.height);
    tipLbl.centerX = self.view.centerX;
    [self.view addSubview:tipLbl];
    
    UIImageView *qrCodeImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, tipLbl.bottom+25, 150, 150)];
    qrCodeImageView.centerX = self.view.centerX;
    qrCodeImageView.image = [SGQRCodeGenerateManager SG_generateWithDefaultQRCodeData:@"https://github.com/kingsic" imageViewWidth:qrCodeImageView.width];
    [self.view addSubview:qrCodeImageView];
    
    UILabel *identityLbl = [[UILabel alloc]init];
    identityLbl.text = @"我的身份ID：12345";
    identityLbl.font = [UIFont systemFontOfSize:14];
    identityLbl.textColor = [UIColor darkGrayColor];
    [identityLbl sizeToFit];
    identityLbl.frame = CGRectMake(0, qrCodeImageView.bottom+25, identityLbl.width, identityLbl.height);
    identityLbl.centerX = self.view.centerX;
    [self.view addSubview:identityLbl];
    
    UIButton *copyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    copyBtn.backgroundColor = [UIColor colorWithHexString:@"de88a5"];
    [copyBtn setTitle:@"点击复制身份ID，叫好友来追踪我" forState:UIControlStateNormal];
    copyBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    copyBtn.layer.cornerRadius = 10;
    copyBtn.frame = CGRectMake(15, identityLbl.bottom+25, ScreenW - 2*15, 50);
    [copyBtn addTarget:self action:@selector(copyBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:copyBtn];

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
