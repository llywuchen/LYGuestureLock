//
//  LYGuestureLockViewController.m
//  LYGuestureLock
//
//  Created by lly on 2017/7/9.
//  Copyright © 2017年 lly. All rights reserved.
//

#import "LYGuestureLockViewController.h"
#import "LYGuestureLockView.h"
#import "LYGuestureLockThumbnail.h"

@interface LYGuestureLockViewController () <LYGuestureLockDelegate>

@property (nonatomic,copy) NSString *verifyPwd;
@property (nonatomic,assign) LYGuestureLockType type;

@property (nonatomic,strong) LYGuestureLockThumbnail *thunbnailView;
@property (nonatomic,strong) LYGuestureLockView *lockView;

@end

@implementation LYGuestureLockViewController

+ (instancetype)instanceWithSetting{
    LYGuestureLockViewController *v = [[LYGuestureLockViewController alloc]init];
    v.type = LYGuestureLockTypeSetting;
    return v;
}

+ (instancetype)instanceWithVerify:(NSString *)pwd{
    LYGuestureLockViewController *v = [[LYGuestureLockViewController alloc]init];
    v.type = LYGuestureLockTypeVerify;
    v.verifyPwd = pwd;
    return v;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    if(self.type == LYGuestureLockTypeSetting){
        _thunbnailView = [[LYGuestureLockThumbnail alloc]initWithFrame:CGRectMake(0, 50, self.view.frame.size.width, 80) rowPointCount:GTRowCount];
        [self.view addSubview:_thunbnailView];
    }
    
    _lockView = [[LYGuestureLockView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_thunbnailView.frame)+25, self.view.frame.size.width, 500)];
    _lockView.type = self.type;
    [_lockView setVerifyGuesturePwd:self.verifyPwd];
    _lockView.delegate = self;
    [self.view addSubview:_lockView];
    
}

#pragma mark - delegate
- (void)guestureLockVerify:(BOOL)succes errorCount:(NSInteger)errorCount{
    if(succes){
        NSLog(@"手势密码校验成功！");
        [self dismissViewControllerAnimated:true completion:nil];
    }else{
        NSLog(@"手势密码校验失败！失败次数：%ld",errorCount);
    }
}

- (void)guestureLockSetTouchFirst:(NSString *)touchPwd{
    NSLog(@"手势密码设置第一次输入:%@",touchPwd);
    [_thunbnailView setGuesturePwd:touchPwd];
}

- (void)guestureLockSetTouchAgainFinished:(NSString *)touchPwd{
    NSLog(@"手势密码设置第二次输入！:%@，设置成功！！！",touchPwd);
    [_thunbnailView setGuesturePwd:touchPwd];
    [[NSUserDefaults standardUserDefaults] setObject:touchPwd forKey:LYGuestureLockKey];
    [self dismissViewControllerAnimated:true completion:nil];

    
}

- (void)guestureLockSetTouchWrong:(NSString *)touchPwd wrongInfo:(NSString *)info{
    NSLog(@"手势密码:%@,设置失败:%@",touchPwd,info);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
