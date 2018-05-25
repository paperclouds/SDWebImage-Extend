//
//  ViewController.m
//  SDWebImage-Extend
//
//  Created by paperclouds on 2018/5/25.
//  Copyright © 2018年 hechang. All rights reserved.
//

#import "ViewController.h"
#import "UIImageView+Network.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 200)];
    [self.view addSubview:imageView];
    [imageView sd_ssetImageWithURL:@"http://ww1.sinaimg.cn/large/61b69811gw1f6bqb1bfd2j20b4095dfy.jpg"];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
