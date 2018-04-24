//
//  MainViewController.m
//  ChildTrack
//
//  Created by zzy on 02/01/2018.
//  Copyright © 2018 zzy. All rights reserved.
//

#import "MainViewController.h"
#import "SoftIntroduceViewController.h"
#import "MapViewController.h"
#import "TrackViewController.h"
#import "TrackedViewController.h"
#import "TrackManage.h"
#import "CTPushTransition.h"

#define Margin 30

@interface MainViewController ()<UINavigationControllerDelegate>

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"全能追踪";
    
    UIButton *introduceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    introduceBtn.backgroundColor = [UIColor colorWithHexString:@"a358c2"];
    introduceBtn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [introduceBtn setTitle:@"介绍" forState:UIControlStateNormal];
    introduceBtn.layer.cornerRadius = 10;
    introduceBtn.frame = CGRectMake(ScreenW, Margin, ScreenW - 2*Margin, (ScreenH - 5*Margin)/10);
    introduceBtn.tag = 101;
    [introduceBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:introduceBtn];
    
    UIButton *myLocationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    myLocationBtn.backgroundColor = [UIColor colorWithHexString:@"f7ce5a"];
    [myLocationBtn setTitle:@"我的轨迹" forState:UIControlStateNormal];
    myLocationBtn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    myLocationBtn.layer.cornerRadius = 10;
    myLocationBtn.frame = CGRectMake(ScreenW, introduceBtn.bottom+Margin, ScreenW - 2*Margin, (ScreenH - 5*Margin)/5);
    myLocationBtn.tag = 102;
    [myLocationBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:myLocationBtn];
    
    UIButton *trackedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    trackedBtn.backgroundColor = [UIColor colorWithHexString:@"ed6a6d"];
    [trackedBtn setTitle:@"让人追踪" forState:UIControlStateNormal];
    trackedBtn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    trackedBtn.layer.cornerRadius = 10;
    trackedBtn.frame = CGRectMake(ScreenW, myLocationBtn.bottom+Margin, ScreenW - 2*Margin, (ScreenH - 5*Margin)*3/10);
    trackedBtn.tag = 103;
    [trackedBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:trackedBtn];
    
    UIButton *trackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    trackBtn.backgroundColor = [UIColor colorWithHexString:@"7dc6cb"];
    [trackBtn setTitle:@"追踪他人" forState:UIControlStateNormal];
    trackBtn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    trackBtn.layer.cornerRadius = 10;
    trackBtn.frame = CGRectMake(ScreenW, trackedBtn.bottom+Margin, ScreenW - 2*Margin, (ScreenH - 5*Margin)*2/5);
    trackBtn.tag = 104;
    [trackBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:trackBtn];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        for (int i = 0; i < 4; i++) {
            
            [UIView animateWithDuration:0.2 delay:i*0.08 usingSpringWithDamping:0.5 initialSpringVelocity:0.1 options:UIViewAnimationOptionCurveEaseIn animations:^{
                
                UIButton *btn = [self.view viewWithTag:101+i];
                btn.x = Margin;
                
            } completion:^(BOOL finished) {
                
            }];
        }
    });
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.navigationController.delegate = self;
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    if (self.navigationController.delegate == self) {
        self.navigationController.delegate = nil;
    }
}

#pragma mark UINavigationControllerDelegate
- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    if (fromVC == self && [toVC isKindOfClass:[SoftIntroduceViewController class]]) {
        return [[CTPushTransition alloc] init];
        
    } else {
        return nil;
    }
}

- (void)btnClick:(UIButton *)sender {
    
    switch (sender.tag) {
        case 101:
        {
            SoftIntroduceViewController *softIntroduceVC = [[SoftIntroduceViewController alloc]init];
            [self.navigationController pushViewController:softIntroduceVC animated:YES];
            break;
        }
        case 102: //我的轨迹
        {
            [SVProgressHUD show];
            __weak typeof (self)wSelf = self;
            [[TrackManage sharedInstance] trackWithCompletionBlock:[[FCUUID uuidForDevice] substringFromIndex:16] trackBlock:^(BMKMapPoint *points, NSMutableArray *poisWithoutZero) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [SVProgressHUD dismiss];
                    MapViewController *mapVC = [[MapViewController alloc]initWithParams:poisWithoutZero points:points];
                    [wSelf.navigationController pushViewController:mapVC animated:YES];
                });
                
            }];
            break;
        }
        case 103:
        {
            TrackedViewController *trackedVC = [[TrackedViewController alloc]init];
            [self.navigationController pushViewController:trackedVC animated:YES];
            break;
        }
        case 104:
        {
            TrackViewController *trackVC = [[TrackViewController alloc]init];
            [self.navigationController pushViewController:trackVC animated:YES];
            break;
        }
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
