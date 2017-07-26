//
//  GTCarNumFullKeyBoard.m
//  HJFCustomLoginKeyboardDemo
//
//  Created by mac on 2017/7/24.
//  Copyright © 2017年 hjfrun. All rights reserved.
//

#import "GTCarNumFullKeyBoard.h"
#import "Constant.h"
#import "UIImage+ImageWithColor.h"
#import <AVFoundation/AVFoundation.h>
#import "HJFKeyboardPopView.h"


@interface GTCarNumFullKeyBoard ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *functionBtnConstrainW;
@property (weak, nonatomic) IBOutlet HJFCustomKeyboardButton *SwichBtn;
@property (weak, nonatomic) IBOutlet HJFCustomKeyboardButton *deleteBtn;
@property (strong, nonatomic) IBOutletCollection(HJFCustomKeyboardButton) NSArray *itemBtnArr;

@property (nonatomic, strong) HJFKeyboardPopView *popView;
@property (nonatomic, strong) NSTimer *deleteActionTimer;
@property (nonatomic, assign) SystemSoundID soundID;
@property (nonatomic, strong) HJFCustomKeyboardButton *lastButton;

@end





@implementation GTCarNumFullKeyBoard

#pragma mark - Life Cycle
+ (instancetype)keyboard{
    NSArray *objects = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil];
    GTCarNumFullKeyBoard *keyboard = objects.firstObject;
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
    
    for (HJFCustomKeyboardButton *btn in self.itemBtnArr) {
        btn.userInteractionEnabled = NO;
    }
    [self setupButtons];
    [self.deleteBtn addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(backDeleteButtonClick:)]];
    
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
        if (self.delegate && [self.delegate respondsToSelector:@selector(GTCarNumFullKeyBoard:normalBtnClickAction:)]) {
            [self.delegate GTCarNumFullKeyBoard:self normalBtnClickAction:btn];
        }
    } else if (self.lastButton) {
        [self playSoundEffect];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(GTCarNumFullKeyBoard:normalBtnClickAction:)]) {
            
            [self.delegate GTCarNumFullKeyBoard:self normalBtnClickAction:self.lastButton];
        }
    }
    
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.popView removeFromSuperview];
}





- (IBAction)deleteBtnClickAction:(HJFCustomKeyboardButton *)sender {
    
    [self playSoundEffect];
    if (self.delegate && [self.delegate respondsToSelector:@selector(GTCarNumFullKeyBoard:deleteBtnClickAction:)]) {
        [self.delegate GTCarNumFullKeyBoard:self deleteBtnClickAction:self.deleteBtn];
    }
}

- (IBAction)SwichBtnClickAction:(HJFCustomKeyboardButton *)sender {
    
    [self playSoundEffect];
    if (self.delegate && [self.delegate respondsToSelector:@selector(GTCarNumFullKeyBoard:switchBtnClickAction:)]) {
        [self.delegate GTCarNumFullKeyBoard:self switchBtnClickAction:self.SwichBtn];
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

//- (NSArray *)normalButtons{
//    if (_normalButtons == nil) {
//        NSMutableArray *array = [NSMutableArray arrayWithArray:self.itemBtnArr];
//        _normalButtons = [array copy];
//    }
//    return _normalButtons;
//}

- (HJFKeyboardPopView *)popView{
    if (_popView == nil) {
        _popView = [HJFKeyboardPopView popView];
    }
    return _popView;
}

- (void)backDeleteButtonClick:(UILongPressGestureRecognizer *)recognizer{
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
    if (self.delegate && [self.delegate respondsToSelector:@selector(GTCarNumFullKeyBoard:deleteBtnClickAction:)]) {
        [self.delegate GTCarNumFullKeyBoard:self deleteBtnClickAction:self.deleteBtn];
    }
}


#pragma mark - Private Methods

- (HJFCustomKeyboardButton *)keyboardButtonWithLocation:(CGPoint)location{
    NSUInteger count = self.itemBtnArr.count;
    for (NSUInteger i = 0; i < count; i++) {
        HJFCustomKeyboardButton *btn = self.itemBtnArr[i];
        if (CGRectContainsPoint(btn.frame, location)) {
            return btn;
        }
    }
    return nil;
}

- (void)playSoundEffect{
    if (self.needKeyboardSoundEffect) {
        AudioServicesPlaySystemSound(self.soundID);
    }
}


@end
