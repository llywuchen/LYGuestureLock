//
//  LYGuestureLockView.m
//  LYGuestureLock
//
//  Created by lly on 2017/7/9.
//  Copyright © 2017年 lly. All rights reserved.
//

#import "LYGuestureLockView.h"

#define GTPointSize 80
#define GTPointMargin 30
#define GTLineWidth 6

#define GTUnselectedColor [UIColor blueColor]
#define GTSelectedColor [UIColor greenColor]
#define GTWrongColor [UIColor redColor]
#define GTLineColor [UIColor grayColor]

@interface LYGuestureLockView (){
    CGPoint _currentPoint;
    NSString *_firstTouchPwd;
    NSInteger _verifyErrorCount;
}

@property (nonatomic,copy) NSString *verifyPwd;

@property (nonatomic,strong) NSMutableArray<UIButton *> *selectedBtns;

@end

@implementation LYGuestureLockView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self.backgroundColor = [UIColor clearColor];
        _selectedBtns = [NSMutableArray arrayWithCapacity:GTRowCount*GTRowCount];
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview{
    [super willMoveToSuperview:newSuperview];
    [self initSubViews];
}

- (void)initSubViews{
    
    CGFloat startXMargin = (self.bounds.size.width - (GTPointSize *GTRowCount) - (GTRowCount-1)*GTPointMargin)/2;
    CGFloat startYMargin = (self.bounds.size.height - (GTPointSize *GTRowCount) - (GTRowCount-1)*GTPointMargin)/2;
    
    UIImage *unselectedImage = [self drawUnselectedImage];
    UIImage *selectedImage = [self drawSelectedImage];
    for(NSInteger i=0;i<GTRowCount;i++){
        for(NSInteger j=0;j<GTRowCount;j++){
            CGPoint position = CGPointMake(startXMargin + GTPointSize/2*(2*j+1) + GTPointMargin*j, startYMargin + GTPointSize/2*(2*i+1) + GTPointMargin*i);
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(position.x-GTPointSize/2, position.y-GTPointSize/2, GTPointSize, GTPointSize);
            btn.tag = i*GTRowCount+j;
            [btn setImage:unselectedImage forState:UIControlStateNormal];
            [btn setImage:selectedImage forState:UIControlStateSelected];
            btn.userInteractionEnabled = NO;
            [self addSubview:btn];
            
        }
    }
}

#pragma mark - getter and setter
- (void)setVerifyGuesturePwd:(NSString *)pwd{
    if(self.type == LYGuestureLockTypeVerify){
        self.verifyPwd = pwd;
    }
}

#pragma mark - action
-(void)resetView
{
    UIImage *selectedImage = [self drawSelectedImage];
    for (UIButton *btn  in _selectedBtns) {
        [btn setImage:selectedImage forState:UIControlStateSelected];
        btn.selected = NO;
    }
    [_selectedBtns  removeAllObjects];
    [self setNeedsDisplay];
    self.userInteractionEnabled = YES;
    
}

- (NSString *)checkGuesturePwdRule{
    return self.selectedBtns.count<4?@"至少选择4个!":nil;
}

#pragma mark === Touches

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    for (UIButton *btn in self.subviews) {
        if (CGRectContainsPoint(btn.frame, point)) {
            btn.selected = YES;
            if (![_selectedBtns containsObject:btn]) {
                [_selectedBtns addObject:btn];
            }
            break;
        }
    }
    [self resetView];
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    _currentPoint = point;
    for (UIButton *btn in self.subviews) {
        if (CGRectContainsPoint(btn.frame, point)) {
            btn.selected = YES;
            if (![_selectedBtns containsObject:btn]) {
                [_selectedBtns addObject:btn];
            }
        }
    }
    [self setNeedsDisplay];
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSMutableString *resultStr = [[NSMutableString alloc]initWithCapacity:0];
    for (UIButton *btn in _selectedBtns) {
        [resultStr appendFormat:@"%ld",(long)btn.tag];
    }
    UIButton *lastBtn = [_selectedBtns lastObject];
    _currentPoint = lastBtn.center;
    self.userInteractionEnabled = NO;
    
    if(self.type == LYGuestureLockTypeSetting){
        if(!_firstTouchPwd.length){
            NSString *wrongInfo = [self checkGuesturePwdRule];
            if(wrongInfo){
                for (UIButton *btn in _selectedBtns) {
                    [btn setImage:[self drawWrongImage] forState:UIControlStateSelected];
                }
                [self setNeedsDisplay];
                if(self.delegate &&[self.delegate respondsToSelector:@selector(guestureLockSetTouchWrong:wrongInfo:)]){
                    [self.delegate guestureLockSetTouchWrong:resultStr wrongInfo:wrongInfo];
                }
            }else{
                _firstTouchPwd = resultStr;
                if(self.delegate &&[self.delegate respondsToSelector:@selector(guestureLockSetTouchFirst:)]){
                    [self.delegate guestureLockSetTouchFirst:resultStr];
                }
            }
        }else{
            if(![_firstTouchPwd isEqualToString:resultStr]){
                for (UIButton *btn in _selectedBtns) {
                    [btn setImage:[self drawWrongImage] forState:UIControlStateSelected];
                }
                [self setNeedsDisplay];
                if(self.delegate &&[self.delegate respondsToSelector:@selector(guestureLockSetTouchWrong:wrongInfo:)]){
                    [self.delegate guestureLockSetTouchWrong:resultStr wrongInfo:@"两次输入的密码不一致!"];
                }
            }else{
                if(self.delegate &&[self.delegate respondsToSelector:@selector(guestureLockSetTouchAgainFinished:)]){
                    [self.delegate guestureLockSetTouchAgainFinished:resultStr];
                }
            }
        }
        
    }else if (self.type == LYGuestureLockTypeVerify){
        if(self.delegate &&[self.delegate respondsToSelector:@selector(guestureLockVerify:errorCount:)]){
            BOOL success = [self.verifyPwd isEqualToString:resultStr];
            if(!success){
                for (UIButton *btn in _selectedBtns) {
                    [btn setImage:[self drawWrongImage] forState:UIControlStateSelected];
                }
                [self setNeedsDisplay];
            }
            _verifyErrorCount++;
            [self.delegate guestureLockVerify:success errorCount:_verifyErrorCount];
        }
    }
    
    
    [self performSelector:@selector(resetView) withObject:nil afterDelay:0.5];
    
}

#pragma mark drawRect
-(void)drawRect:(CGRect)rect
{
    UIBezierPath *path;
    if (_selectedBtns.count == 0) {
        return;
    }
    path = [UIBezierPath bezierPath];
    path.lineWidth = GTLineWidth;
    path.lineJoinStyle = kCGLineCapRound;
    path.lineCapStyle = kCGLineCapRound;
    
    [GTLineColor set];
    for (int i = 0; i < _selectedBtns.count; i ++) {
        UIButton *btn = _selectedBtns[i];
        
        if (i == 0) {
            [path moveToPoint:btn.center];
        }else
        {
            [path addLineToPoint:btn.center];
        }
    }
    [path addLineToPoint:_currentPoint];
    [path stroke];
}


#pragma draw Image
- (UIImage *)drawUnselectedImage{
    return [self drawImageWithCircleRadius:0 CircleColor:nil fillRadius:10 fillColor:GTUnselectedColor];
}

- (UIImage *)drawSelectedImage{
    return [self drawImageWithCircleRadius:GTPointSize CircleColor:GTSelectedColor fillRadius:10 fillColor:GTSelectedColor];
}

- (UIImage *)drawWrongImage{
    return [self drawImageWithCircleRadius:GTPointSize CircleColor:GTWrongColor fillRadius:10 fillColor:GTWrongColor];
}

- (UIImage *)drawImageWithCircleRadius:(CGFloat)cRadius CircleColor:(UIColor *)cColor fillRadius:(CGFloat)fRadius fillColor:(UIColor *)fColor{
    
    UIGraphicsBeginImageContext(CGSizeMake(GTPointSize, GTPointSize));
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    if(cRadius>0){
        CGContextAddEllipseInRect(context, CGRectMake(GTLineWidth/2, GTLineWidth/2, cRadius-GTLineWidth, cRadius-GTLineWidth));
        [cColor setStroke];
        CGContextSetLineWidth(context, GTLineWidth);
        
        CGContextDrawPath(context, kCGPathStroke);
        
        CGContextAddEllipseInRect(context, CGRectMake(GTLineWidth, GTLineWidth, cRadius-GTLineWidth*2, cRadius-GTLineWidth*2));
        [cColor setStroke];
        [[UIColor whiteColor] set];
        CGContextDrawPath(context, kCGPathFillStroke);
    }
    
    if(fRadius>0){
        CGContextAddEllipseInRect(context, CGRectMake(GTPointSize/2-fRadius/2, GTPointSize/2-fRadius/2, fRadius, fRadius));
        [fColor set];
        CGContextDrawPath(context, kCGPathFillStroke);
    }
    
    UIImage *unselectIma = UIGraphicsGetImageFromCurrentImageContext() ;
    UIGraphicsEndImageContext();
    return unselectIma;
    
}

@end
