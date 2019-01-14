//
//  DZMMagnifierView.m
//  UIMenuController
//
//  Created by 邓泽淼 on 2017/11/27.
//  Copyright © 2017年 邓泽淼. All rights reserved.
//

#define DZMMV_AnimateDuration 0.08

#define DZMMV_Scale 1.8

#define DZMMV_WH 80

#define DZMMV_SCREEN_WIDTH   [UIScreen mainScreen].bounds.size.width
#define DZMMV_SCREEN_HEIGHT  [UIScreen mainScreen].bounds.size.height

#import "DZMMagnifierView.h"

@interface DZMMagnifierView ()

@property (nonatomic, weak) CALayer *contentLayer;
@property (nonatomic, strong) UIView *showView;
@end

@implementation DZMMagnifierView

-(UIView *)showView
{
    if (!_showView) {
        _showView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DZMMV_SCREEN_WIDTH - 40, 118)];
        _showView.backgroundColor = UIColor.redColor;
        [self addSubview:_showView];
        _showView.hidden = YES;
    }
    return _showView;
}

+ (instancetype)magnifierView {
    
    DZMMagnifierView *mv = [[DZMMagnifierView alloc] init];
    
    return mv;
}

- (id)initWithFrame:(CGRect)frame {
    
    if (self == [super initWithFrame:frame]) {
        
    }
    
    return self;
}

- (id)init {
    
    if (self == [super init]) {
        
        self.adjustPoint = CGPointMake(0, 0);
        self.scale = DZMMV_Scale;
        
        self.frame = CGRectMake(0, 0, DZMMV_WH, DZMMV_WH);
//        self.layer.borderWidth = 5;
//        self.layer.borderColor = [[[UIColor grayColor] colorWithAlphaComponent:0.9] CGColor];
        self.layer.cornerRadius = DZMMV_WH / 2;
//        self.layer.masksToBounds = YES;
        self.windowLevel = UIWindowLevelAlert;
        
        CALayer *contentLayer = [CALayer layer];
        contentLayer.frame = self.bounds;
        contentLayer.cornerRadius = contentLayer.frame.size.width/2;
        contentLayer.masksToBounds = YES;
        contentLayer.delegate = self;
        contentLayer.contentsScale = [[UIScreen mainScreen] scale];
        [self.layer addSublayer:contentLayer];
        self.contentLayer = contentLayer;
        
        self.transform = CGAffineTransformMakeScale(0.5, 0.5);
    }
    
    return self;
}

- (void)setAdjustPoint:(CGPoint)adjustPoint {
    
    _adjustPoint = adjustPoint;
    
    [self setTargetPoint:self.targetPoint];
}

- (void)setScale:(CGFloat)scale {
    
    _scale = scale;
    
    [self.contentLayer setNeedsDisplay];
}

- (void)setTargetWindow:(UIView *)targetWindow {
    
    _targetWindow = targetWindow;
    
    [self makeKeyAndVisible];
    
    [UIView animateWithDuration:DZMMV_AnimateDuration animations:^{
        
        self.transform = CGAffineTransformMakeScale(1.0, 1.0);
    }];
    
    [self setTargetPoint:self.targetPoint];
}

- (void)setTargetPoint:(CGPoint)targetPoint {
    
    _targetPoint = targetPoint;
    
    if (self.targetWindow) {
        
        CGPoint center = CGPointMake(targetPoint.x, self.center.y);
        
        if (targetPoint.y > CGRectGetHeight(self.bounds) * 0.5) {
            
            center.y = targetPoint.y -  CGRectGetHeight(self.bounds) / 2;
        }
        
        self.center = CGPointMake(center.x + self.adjustPoint.x, center.y + self.adjustPoint.y);
        
        [self showDetailView:YES];
        
        [self.contentLayer setNeedsDisplay];
    }
}

- (void)remove:(void (^)(void))complete {
    
//    __weak DZMMagnifierView *weakSelf = self;
    
    [UIView animateWithDuration:DZMMV_AnimateDuration animations:^{
        
        self.alpha = 0.5;
        
        self.transform = CGAffineTransformMakeScale(0, 0);
        
    } completion:^(BOOL finished) {
        
        [self.contentLayer removeFromSuperlayer];
        [self.showView removeFromSuperview];
        [self removeFromSuperview];
        
        if (complete) {
            complete();
        }
    }];
}

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx
{
    CGContextTranslateCTM(ctx, DZMMV_WH / 2, DZMMV_WH / 2);
    
    CGContextScaleCTM(ctx, self.scale, self.scale);
    
    CGContextTranslateCTM(ctx, -1 * self.targetPoint.x, -1 * self.targetPoint.y);
    
    [self.targetWindow.layer renderInContext:ctx];
}

- (void)dealloc
{
    [self.contentLayer removeFromSuperlayer];
    
    self.contentLayer = nil;
}


//显示或是隐藏详情界面
-(void)showDetailView:(BOOL)show
{
    self.showView.hidden = !show;
    CGFloat w = self.showView.frame.size.width;
    CGFloat h = self.showView.frame.size.height;
    CGFloat centerX = self.center.x;
//    NSLog(@"中心点偏移X：%.f",centerX);
    self.showView.frame = CGRectMake( DZMMV_WH/2 - centerX + 20, - 30 - h, w, h);
}

@end
