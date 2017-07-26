//
//  GTNumberAndAlphebetKeyboard.h
//  HJFCustomLoginKeyboardDemo
//
//  Created by mac on 2017/7/19.
//  Copyright © 2017年 hjfrun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HJFCustomKeyboardButton.h"
@class GTNumberAndAlphebetKeyboard;

@protocol GTNumberAndAlphebetKeyboardDelegate <NSObject>

/** 点击了普通按钮, 包括自负标点符号等 */
-(void)GTNumberAndAlphebetKeyboard:(GTNumberAndAlphebetKeyboard *)keyboard normalBtnClickAction:(HJFCustomKeyboardButton *)sender;

/** 点击了删除键 */
-(void)GTNumberAndAlphebetKeyboard:(GTNumberAndAlphebetKeyboard *)keyboard deleteBtnClickAction:(HJFCustomKeyboardButton *)sender;

/** 点击了大小写切换键 */
-(void)GTNumberAndAlphebetKeyboard:(GTNumberAndAlphebetKeyboard *)keyboard switchBtnClickAction:(HJFCustomKeyboardButton *)sender;

@end




@interface GTNumberAndAlphebetKeyboard : UIView

@property (nonatomic,weak) id <GTNumberAndAlphebetKeyboardDelegate> delegate;
/**
 *  键盘是否需要音效
 */
@property (nonatomic, assign) BOOL needKeyboardSoundEffect;


/**
 初始化
 @return 返回
 */
+ (instancetype)keyboard;

@end
