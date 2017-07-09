//
//  LYGuestureLockViewController.h
//  LYGuestureLock
//
//  Created by lly on 2017/7/9.
//  Copyright © 2017年 lly. All rights reserved.
//

#import <UIKit/UIKit.h>

#define LYGuestureLockKey @"LYGuestureLockKey"

@interface LYGuestureLockViewController : UIViewController

+ (instancetype)instanceWithSetting;
+ (instancetype)instanceWithVerify:(NSString *)pwd;

@end
