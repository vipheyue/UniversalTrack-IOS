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

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"全能追踪";
    
    UIButton *myLocationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    myLocationBtn.backgroundColor = [UIColor colorWithHexString:@"201b1f"];
    [myLocationBtn setTitle:@"我的轨迹" forState:UIControlStateNormal];
    myLocationBtn.layer.cornerRadius = 10;
    
    myLocationBtn.frame = CGRectMake(Margin, Margin, ScreenW - 2*Margin, (ScreenH - 4*Margin)/6);
    [self.view addSubview:myLocationBtn];
    
    UIButton *trackedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    trackedBtn.backgroundColor = [UIColor colorWithHexString:@"201b1f"];
    [trackedBtn setTitle:@"让人追踪" forState:UIControlStateNormal];
    trackedBtn.layer.cornerRadius = 10;
    
    trackedBtn.frame = CGRectMake(Margin, myLocationBtn.bottom+Margin, ScreenW - 2*Margin, (ScreenH - 4*Margin)/3);
    [self.view addSubview:trackedBtn];
    
    UIButton *trackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    trackBtn.backgroundColor = [UIColor colorWithHexString:@"201b1f"];
    [trackBtn setTitle:@"追踪他人" forState:UIControlStateNormal];
    trackBtn.layer.cornerRadius = 10;
    
    trackBtn.frame = CGRectMake(Margin, trackedBtn.bottom+Margin, ScreenW - 2*Margin, (ScreenH - 4*Margin)/2);
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
