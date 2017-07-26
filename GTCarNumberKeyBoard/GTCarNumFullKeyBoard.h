//
//  GTCarNumFullKeyBoard.h
//  HJFCustomLoginKeyboardDemo
//
//  Created by mac on 2017/7/24.
//  Copyright © 2017年 hjfrun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HJFCustomKeyboardButton.h"

@class GTCarNumFullKeyBoard;




@protocol GTCarNumFullKeyBoardDelegate <NSObject>

/** 点击了普通按钮, 包括自负标点符号等 */
-(void)GTCarNumFullKeyBoard:(GTCarNumFullKeyBoard *)keyboard normalBtnClickAction:(HJFCustomKeyboardButton *)sender;

/** 点击了删除键 */
-(void)GTCarNumFullKeyBoard:(GTCarNumFullKeyBoard *)keyboard deleteBtnClickAction:(HJFCustomKeyboardButton *)sender;

/** 点击了切换键 */
-(void)GTCarNumFullKeyBoard:(GTCarNumFullKeyBoard *)keyboard switchBtnClickAction:(HJFCustomKeyboardButton *)sender;

@end


@interface GTCarNumFullKeyBoard : UIView


@property (nonatomic,weak) id <GTCarNumFullKeyBoardDelegate> delegate;
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
