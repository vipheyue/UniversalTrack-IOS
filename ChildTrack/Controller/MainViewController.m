//
//  MainViewController.m
//  ChildTrack
//
//  Created by zzy on 02/01/2018.
//  Copyright © 2018 zzy. All rights reserved.
//

#import "MainViewController.h"

#define Margin 30

@interface MainViewController ()

@end
//x+2x+3x+4x = (ScreenH - 5*Margin)
@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"全能追踪";
    
    UIButton *introduceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    introduceBtn.backgroundColor = [UIColor colorWithHexString:@"a358c2"];
    introduceBtn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [introduceBtn setTitle:@"介绍" forState:UIControlStateNormal];
    introduceBtn.layer.cornerRadius = 10;
    introduceBtn.frame = CGRectMake(Margin, Margin, ScreenW - 2*Margin, (ScreenH - 5*Margin)/10);
    introduceBtn.tag = 101;
    [introduceBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:introduceBtn];
    
    UIButton *myLocationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    myLocationBtn.backgroundColor = [UIColor colorWithHexString:@"f7ce5a"];
    [myLocationBtn setTitle:@"我的轨迹" forState:UIControlStateNormal];
    myLocationBtn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    myLocationBtn.layer.cornerRadius = 10;
    myLocationBtn.frame = CGRectMake(Margin, introduceBtn.bottom+Margin, ScreenW - 2*Margin, (ScreenH - 5*Margin)/5);
    introduceBtn.tag = 102;
    [myLocationBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:myLocationBtn];
    
    UIButton *trackedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    trackedBtn.backgroundColor = [UIColor colorWithHexString:@"ed6a6d"];
    [trackedBtn setTitle:@"让人追踪" forState:UIControlStateNormal];
    trackedBtn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    trackedBtn.layer.cornerRadius = 10;
    trackedBtn.frame = CGRectMake(Margin, myLocationBtn.bottom+Margin, ScreenW - 2*Margin, (ScreenH - 5*Margin)*3/10);
    introduceBtn.tag = 103;
    [trackedBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:trackedBtn];
    
    UIButton *trackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    trackBtn.backgroundColor = [UIColor colorWithHexString:@"7dc6cb"];
    [trackBtn setTitle:@"追踪他人" forState:UIControlStateNormal];
    trackBtn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    trackBtn.layer.cornerRadius = 10;
    trackBtn.frame = CGRectMake(Margin, trackedBtn.bottom+Margin, ScreenW - 2*Margin, (ScreenH - 5*Margin)*2/5);
    introduceBtn.tag = 104;
    [trackBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:trackBtn];
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)btnClick:(UIButton *)sender {
    
    switch (sender.tag) {
        case 101:
            
            break;
        case 102:
            
            break;
        case 103:
            
            break;
        case 104:
            
            break;
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
