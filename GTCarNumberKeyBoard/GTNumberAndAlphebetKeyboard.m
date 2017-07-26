//
//  GTNumberAndAlphebetKeyboard.m
//  HJFCustomLoginKeyboardDemo
//
//  Created by mac on 2017/7/19.
//  Copyright © 2017年 hjfrun. All rights reserved.
//

#import "GTNumberAndAlphebetKeyboard.h"

#import "Constant.h"
#import "UIImage+ImageWithColor.h"
#import <AVFoundation/AVFoundation.h>
#import "HJFKeyboardPopView.h"
@interface GTNumberAndAlphebetKeyboard ()

@property (strong, nonatomic) IBOutletCollection(HJFCustomKeyboardButton) NSArray *numberBtnArr;
@property (strong, nonatomic) IBOutletCollection(HJFCustomKeyboardButton) NSArray *alphebetBtnArr;

@property (weak, nonatomic) IBOutlet HJFCustomKeyboardButton *SwichBtn;
@property (weak, nonatomic) IBOutlet HJFCustomKeyboardButton *deleteBtn;

@property (nonatomic, strong) HJFKeyboardPopView *popView;

@property (nonatomic, strong) NSTimer *deleteActionTimer;
@property (nonatomic, strong) NSArray *normalButtons;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *functionBtnConstrainW;

@property (nonatomic, assign) SystemSoundID soundID;

@property (nonatomic, strong) HJFCustomKeyboardButton *lastButton;

@end


@implementation GTNumberAndAlphebetKeyboard



#pragma mark - Life Cycle

+ (instancetype)keyboard{
    NSArray *objects = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil];
    
    GTNumberAndAlphebetKeyboard *keyboard = objects.firstObject;
    return keyboard;
}


- (void)awakeFromNib{
    
    if (IS_IPHONE5) {
        self.functionBtnConstrainW.constant = 38;
    }else if (IS_IPHONE6){
        self.functionBtnConstrainW.constant = 40;
    }else if (IS_IPHONE6_PLUS){
        self.functionBtnConstrainW.constant = 42;
    }
    
    for (HJFCustomKeyboardButton *btn in self.normalButtons) {
        btn.userInteractionEnabled = NO;
    }
    [self setupButtons];
    [self.deleteBtn addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(backDeleteButtonClick:)]];
    
//    [self.SwichBtn setTitle:nil forState:UIControlStateNormal];
//    [self.SwichBtn setImage:[UIImage imageNamed:@"keyboard_case_upper"] forState:UIControlStateNormal];
//    [self.SwichBtn setImage:[UIImage imageNamed:@"keyboard_case_lower"] forState:UIControlStateSelected];
    
    [super awakeFromNib];
}

/**
 *  配置键盘上的特殊按键外观
 */
- (void)setupButtons{
    UIImage *whiteBackgroundImage = [UIImage imageWithColor:[UIColor whiteColor]];
//    UIImage *lightGrayBackgroundImage = [UIImage imageWithColor:[UIColor colorWithRed:170 / 255.f green:178 / 255.f blue:189 / 255.f alpha:.6f]];
    
    [self.deleteBtn setBackgroundImage:whiteBackgroundImage forState:UIControlStateHighlighted];
    
    [self.SwichBtn setBackgroundImage:whiteBackgroundImage forState:UIControlStateHighlighted];
    
}



- (void)dealloc{
    [self.deleteActionTimer invalidate];
    self.deleteActionTimer = nil;
    self.popView = nil;
    AudioServicesDisposeSystemSoundID(_soundID);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - Touch Responders

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    self.lastButton = nil;
    [self touchesMoved:touches withEvent:event];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = touches.anyObject;
    
    CGPoint location = [touch locationInView:touch.view];
    HJFCustomKeyboardButton *btn = [self keyboardButtonWithLocation:location];
    
    if (btn) {
        self.lastButton = btn;
        [self.popView showFromButton:btn];
    }
    
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.popView removeFromSuperview];
    
    UITouch *touch = touches.anyObject;
   
    CGPoint location = [touch locationInView:touch.view];
    HJFCustomKeyboardButton *btn = [self keyboardButtonWithLocation:location];
    
    if (btn) {
        [self playSoundEffect];
        if (self.delegate && [self.delegate respondsToSelector:@selector(GTNumberAndAlphebetKeyboard:normalBtnClickAction:)]) {
            

            [self.delegate GTNumberAndAlphebetKeyboard:self normalBtnClickAction:btn];
        }
    } else if (self.lastButton) {
        [self playSoundEffect];

        if (self.delegate && [self.delegate respondsToSelector:@selector(GTNumberAndAlphebetKeyboard:normalBtnClickAction:)]) {

            [self.delegate GTNumberAndAlphebetKeyboard:self normalBtnClickAction:self.lastButton];
        }
    }
    
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.popView removeFromSuperview];
}



- (IBAction)SwichBtnClickAction:(HJFCustomKeyboardButton *)sender {
//    [self playSoundEffect];
//    sender.selected = !sender.isSelected;
//    if (!sender.isSelected) {
//        for (HJFCustomKeyboardButton *button in self.alphebetBtnArr) {
//            [button setTitle:button.currentTitle.uppercaseString forState:UIControlStateNormal];
//        }
//    } else {
//        for (HJFCustomKeyboardButton *button in self.alphebetBtnArr) {
//            [button setTitle:button.currentTitle.lowercaseString forState:UIControlStateNormal];
//        }
//    }
    [self playSoundEffect];
    if (self.delegate && [self.delegate respondsToSelector:@selector(GTNumberAndAlphebetKeyboard:switchBtnClickAction:)]) {
        [self.delegate GTNumberAndAlphebetKeyboard:self switchBtnClickAction:self.SwichBtn];
    }
    
}

- (IBAction)deleteBtnClickAction:(HJFCustomKeyboardButton *)sender {
    [self playSoundEffect];
    if (self.delegate && [self.delegate respondsToSelector:@selector(GTNumberAndAlphebetKeyboard:deleteBtnClickAction:)]) {
        [self.delegate GTNumberAndAlphebetKeyboard:self deleteBtnClickAction:self.deleteBtn];
    }
}


#pragma mark - Lazy Load

- (SystemSoundID)soundID{
    if (_soundID == 0) {
        NSURL *soundURL = [[NSBundle mainBundle] URLForResource:@"keyboard-click-1.aiff" withExtension:nil];
        AudioServicesCreateSystemSoundID((__bridge CFURLRef _Nonnull)(soundURL), &_soundID);
    }
    return _soundID;
}

- (NSArray *)normalButtons{
    if (_normalButtons == nil) {
        NSMutableArray *array = [NSMutableArray arrayWithArray:self.numberBtnArr];
        [array addObjectsFromArray:self.alphebetBtnArr];
        _normalButtons = array;
    }
    return _normalButtons;
}

- (HJFKeyboardPopView *)popView{
    if (_popView == nil) {
        _popView = [HJFKeyboardPopView popView];
    }
    return _popView;
}

- (void)backDeleteButtonClick:(UILongPressGestureRecognizer *)recognizer
{
    switch (recognizer.state) {
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded:
            [self.deleteActionTimer invalidate];
            self.deleteActionTimer = nil;
            break;
        case UIGestureRecognizerStateBegan:
            self.deleteActionTimer = [NSTimer timerWithTimeInterval:0.1f target:self selector:@selector(deleteTimerAction) userInfo:nil repeats:YES];
            [[NSRunLoop mainRunLoop] addTimer:self.deleteActionTimer forMode:NSRunLoopCommonModes];
            
            break;
        case UIGestureRecognizerStateChanged:
            
            
        default:
            break;
    }
}



- (void)deleteTimerAction{
    [self playSoundEffect];
    if (self.delegate && [self.delegate respondsToSelector:@selector(GTNumberAndAlphebetKeyboard:deleteBtnClickAction:)]) {
        [self.delegate GTNumberAndAlphebetKeyboard:self deleteBtnClickAction:self.deleteBtn];
    }
}


#pragma mark - Private Methods

- (HJFCustomKeyboardButton *)keyboardButtonWithLocation:(CGPoint)location
{
    NSUInteger count = self.normalButtons.count;
    for (NSUInteger i = 0; i < count; i++) {
        HJFCustomKeyboardButton *btn = self.normalButtons[i];
        if (CGRectContainsPoint(btn.frame, location)) {
            return btn;
        }
    }
    return nil;
}

- (void)playSoundEffect
{
    if (self.needKeyboardSoundEffect) {
        AudioServicesPlaySystemSound(self.soundID);
    }
}

@end
