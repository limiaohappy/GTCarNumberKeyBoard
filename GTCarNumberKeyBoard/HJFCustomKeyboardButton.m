//
//  HJFCustomKeyboardButton.m
//  HJFCustomLoginKeyboardDemo
//
//  Created by hjfrun on 16/7/5.
//  Copyright © 2016年 hjfrun. All rights reserved.
//

#import "HJFCustomKeyboardButton.h"

static CGFloat const cornerRadius = 5;
static CGFloat const margin = 1;

@implementation HJFCustomKeyboardButton


- (void)awakeFromNib
{
    self.layer.cornerRadius = cornerRadius;
    self.layer.masksToBounds = YES;
    [super awakeFromNib];
}

// 在这里主要是给按钮加上一条下划线，产生3D效果
- (void)drawRect:(CGRect)rect
{
    CGFloat width = rect.size.width;
    CGFloat height = rect.size.height;
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, height - cornerRadius - margin)]; //初始点
    [path addArcWithCenter:CGPointMake(cornerRadius, height - cornerRadius - margin) radius:cornerRadius startAngle:M_PI endAngle:M_PI_2 clockwise:NO]; //左边圆弧，圆心 和 半径  其实角度 和 完毕角度
    [path addLineToPoint:CGPointMake(width - cornerRadius, height - margin)]; // 直线终点
    [path addArcWithCenter:CGPointMake(width - cornerRadius, height - cornerRadius - margin) radius:cornerRadius startAngle:M_PI_2 endAngle:0 clockwise:NO]; //右边圆弧
    
    [path addLineToPoint:CGPointMake(width, height - cornerRadius)]; // 终点
    [path addArcWithCenter:CGPointMake(width - cornerRadius, height - cornerRadius) radius:cornerRadius startAngle:0 endAngle:M_PI_2 clockwise:YES];
    [path addLineToPoint:CGPointMake(cornerRadius, height)];
    [path addArcWithCenter:CGPointMake(cornerRadius, height - cornerRadius) radius:cornerRadius startAngle:M_PI_2 endAngle:M_PI clockwise:YES];
    [path closePath];
    
    CGContextSetFillColorWithColor(ctx, [UIColor colorWithRed:135 / 255.f green:139 / 255.f blue:143 / 255.f alpha:1.f].CGColor);
    CGContextAddPath(ctx, path.CGPath);
    CGContextFillPath(ctx);
}


@end
