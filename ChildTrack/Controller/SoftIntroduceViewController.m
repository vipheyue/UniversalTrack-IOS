//
//  SoftIntroduceViewController.m
//  ChildTrack
//
//  Created by zzy on 08/02/2018.
//  Copyright © 2018 zzy. All rights reserved.
//

#import "SoftIntroduceViewController.h"

@interface SoftIntroduceViewController ()

@end

@implementation SoftIntroduceViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.navigationItem.title = @"软件介绍";
    
    UIImageView *introduceImage = [[UIImageView alloc]init];
    introduceImage.frame = CGRectMake(10, 74, ScreenW - 20, ScreenH - 74 - 10);
    introduceImage.image = [UIImage imageNamed:@"soft_introduce"];
    [self.view addSubview:introduceImage];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
