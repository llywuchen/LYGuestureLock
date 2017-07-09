//
//  LYGuestureLockThumbnail.m
//  LYGuestureLock
//
//  Created by lly on 2017/7/9.
//  Copyright © 2017年 lly. All rights reserved.
//

#import "LYGuestureLockThumbnail.h"

@interface LYGuestureLockThumbnail (){
    NSInteger _rowCount;
}

@property (nonatomic,strong) CAShapeLayer *seletedlayer;

@end

@implementation LYGuestureLockThumbnail

- (instancetype)initWithFrame:(CGRect)frame rowPointCount:(NSInteger)rowCount{
    self = [self initWithFrame:frame];
    if(self){
        _rowCount = rowCount;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self buildDefault];
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview{
    [self drawDefaultPoints];
//    [self performSelector:@selector(drawGuesturePassword:) withObject:@"13574" afterDelay:2];
//    [self performSelector:@selector(clearnGuesturePwd) withObject:nil afterDelay:4];
    
}

- (void)buildDefault{
    self.backgroundColor = [UIColor clearColor];
    
    _rowCount = 3;
    _pointSize = 30;
    _pointMargin = 13;
    _borderColor = [UIColor blueColor];
    _selectedColor = [UIColor blueColor];
}

#pragma mark - getter and setter
- (CAShapeLayer *)seletedlayer{
    if(!_seletedlayer){
        _seletedlayer = [CAShapeLayer layer];
        _seletedlayer.lineWidth = 1;
        _seletedlayer.strokeColor = _borderColor.CGColor;
        _seletedlayer.fillColor = _selectedColor.CGColor; // 默认为blackColor
    }
    return _seletedlayer;
}

#pragma mark - draw
- (void)drawDefaultPoints{
    CGFloat startXMargin = (self.bounds.size.width - (_pointSize *_rowCount) - (_rowCount-1)*_pointMargin)/2;
    CGFloat startYMargin = (self.bounds.size.height - (_pointSize *_rowCount) - (_rowCount-1)*_pointMargin)/2;
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    for(NSInteger i=0;i<_rowCount;i++){
        for(NSInteger j=0;j<_rowCount;j++){
            CGPoint position = CGPointMake(startXMargin + _pointSize/2*(2*i+1) + _pointMargin*i, startYMargin + _pointSize/2*(2*j+1) + _pointMargin*j);
            UIBezierPath *pointPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(position.x-_pointSize/2, position.y-_pointSize/2, _pointSize, _pointSize)];
            [path appendPath:pointPath];
        }
    }
    
    CAShapeLayer *shape = [CAShapeLayer layer];
    shape.lineWidth = 1;
    shape.strokeColor = _borderColor.CGColor;
    shape.path = path.CGPath;
    shape.fillColor = nil;//_selectedColor.CGColor; // 默认为blackColor
    shape.frame = self.bounds;
    [self.layer addSublayer:shape];
    
}

- (void)drawGuesturePassword:(NSString *)guesturePwd{
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGSize viewSize = self.bounds.size;
    CGFloat startXMargin = (viewSize.width - (_pointSize *_rowCount) - (_rowCount-1)*_pointMargin)/2;
    CGFloat startYMargin = (viewSize.height - (_pointSize *_rowCount) - (_rowCount-1)*_pointMargin)/2;
    CGPoint beforePosition = CGPointMake(0, 0);
    for(NSInteger i =0;i<guesturePwd.length;i++){
        NSInteger number = [[guesturePwd substringWithRange:NSMakeRange(i, 1)] integerValue];
        NSInteger row = number%_rowCount;
        NSInteger colunm = number/_rowCount;
        CGPoint position = CGPointMake(startXMargin + _pointSize/2*(2*row+1) + _pointMargin*row, startYMargin + _pointSize/2*(2*colunm+1) + _pointMargin*colunm);
        CGFloat centerPointSize = _pointSize/4;
        UIBezierPath *pointPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(position.x-centerPointSize/2, position.y-centerPointSize/2, centerPointSize, centerPointSize)];
        [path appendPath:pointPath];
        if(i>0){
            UIBezierPath *linePath = [UIBezierPath bezierPath];
            [linePath moveToPoint:beforePosition];
            [linePath addLineToPoint:position];
            [linePath closePath];
            [path appendPath:linePath];
        }
        beforePosition = position;
        
    }
    self.seletedlayer.path = path.CGPath;
    [self.seletedlayer removeFromSuperlayer];
    [self.layer addSublayer:self.seletedlayer];
    [self setNeedsLayout];
}


#pragma mark - action
- (void)setGuesturePwd:(NSString *)pwd{
    [self drawGuesturePassword:pwd];
}

- (void)clearnGuesturePwd{
    [self.seletedlayer removeFromSuperlayer];
    self.seletedlayer.path = nil;
}

@end

