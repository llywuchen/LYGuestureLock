//
//  LYGuestureLockView.h
//  LYGuestureLock
//
//  Created by lly on 2017/7/9.
//  Copyright © 2017年 lly. All rights reserved.
//

#import <UIKit/UIKit.h>

#define GTRowCount 3

typedef NS_ENUM(NSInteger,LYGuestureLockType){
    LYGuestureLockTypeSetting,//设置
    LYGuestureLockTypeVerify//验证
};

@protocol LYGuestureLockDelegate <NSObject>

@optional
- (void)guestureLockSetTouchWrong:(NSString *)touchPwd wrongInfo:(NSString *)info;

- (void)guestureLockSetTouchFirst:(NSString *)touchPwd;

- (void)guestureLockSetTouchAgainFinished:(NSString *)touchPwd;

- (void)guestureLockVerify:(BOOL)succes errorCount:(NSInteger)errorCount;

@end

@interface LYGuestureLockView : UIView

@property (nonatomic,weak) id<LYGuestureLockDelegate> delegate;
@property (nonatomic,copy,readonly) NSString *guesturePwd;
@property (nonatomic,assign) LYGuestureLockType type;

- (void)setVerifyGuesturePwd:(NSString *)pwd;

@end
