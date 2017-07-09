//
//  ViewController.m
//  LYGuestureLock
//
//  Created by lly on 2017/7/9.
//  Copyright © 2017年 lly. All rights reserved.
//

#import "ViewController.h"
#import "LYGuestureLockViewController.h"

@interface ViewController ()

@property (nonatomic,strong) UILabel *label;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _label = [[UILabel alloc]initWithFrame:CGRectMake(50, 50, 200, 30)];
    _label.text = @"密码:null";
    [self.view addSubview:_label];
    
    [self.view addSubview:[self customBtnWithFrame:CGRectMake(50, 100, 200, 30) title:@"设置手势密码" selector:@selector(setPwd)]];
    
    [self.view addSubview:[self customBtnWithFrame:CGRectMake(50, 150, 200, 30) title:@"鉴定手势密码" selector:@selector(verifyPwd)]];
    
    [self.view addSubview:[self customBtnWithFrame:CGRectMake(50, 200, 200, 30) title:@"清除手势密码" selector:@selector(clearnPwd)]];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self showGuesturePwd];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIButton *)customBtnWithFrame:(CGRect)frame title:(NSString *)title selector:(SEL)selector{
    UIButton *btn = [[UIButton alloc]initWithFrame:frame];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor brownColor];
    [btn addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

- (void)setPwd{
    [self presentViewController:[LYGuestureLockViewController instanceWithSetting] animated:false completion:nil];
}

- (void)verifyPwd{
    NSString *pwd = [[NSUserDefaults standardUserDefaults]objectForKey:LYGuestureLockKey];
    [self presentViewController:[LYGuestureLockViewController instanceWithVerify:pwd] animated:false completion:nil];
}

- (void)clearnPwd{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:LYGuestureLockKey];
    [self showGuesturePwd];
}

#pragma mark - 
- (void)showGuesturePwd{
    NSString *pwd = [[NSUserDefaults standardUserDefaults]objectForKey:LYGuestureLockKey];
    self.label.text = [NSString stringWithFormat:@"密码:%@",pwd];
}

@end
