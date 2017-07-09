//
//  LYGuestureLockThumbnail.h
//  LYGuestureLock
//
//  Created by lly on 2017/7/9.
//  Copyright © 2017年 lly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LYGuestureLockThumbnail : UIView

@property (nonatomic,strong) UIColor *borderColor;//边缘颜色
@property (nonatomic,strong) UIColor *selectedColor;//选中和连线颜色
@property (nonatomic,assign) CGFloat pointSize; //点大小
@property (nonatomic,assign) CGFloat pointMargin;//点与点之间间隙

- (void)setGuesturePwd:(NSString *)pwd;
- (void)clearnGuesturePwd;

- (instancetype)initWithFrame:(CGRect)frame rowPointCount:(NSInteger)rowCount;

@end
