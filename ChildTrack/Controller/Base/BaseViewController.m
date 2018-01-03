//
//  BaseViewController.m
//  BathroomShopping
//
//  Created by zzy on 7/2/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    NSDictionary * dict=[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    self.view.backgroundColor = [UIColor colorWithHexString:@"d1d0d5"];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}
@end
