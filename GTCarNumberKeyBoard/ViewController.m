//
//  ViewController.m
//  GTCarNumberKeyBoard
//
//  Created by mac on 2017/7/26.
//  Copyright © 2017年 GTLand_LeeMiao. All rights reserved.
//

#import "ViewController.h"
#import "GTNumberAndAlphebetKeyboard.h"
#import "GTCarNumFullKeyBoard.h"
@interface ViewController ()<GTNumberAndAlphebetKeyboardDelegate,GTCarNumFullKeyBoardDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    GTCarNumFullKeyBoard *board2 = [GTCarNumFullKeyBoard keyboard];
    board2.needKeyboardSoundEffect=  YES;
    board2.delegate  = self;
    self.textField.inputView =board2;

    UITapGestureRecognizer *singleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeKeyboard:)];
    singleTapGesture.numberOfTapsRequired = 1;
    singleTapGesture.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:singleTapGesture];
    
    
        // Do any additional setup after loading the view, typically from a nib.
}
- (void)closeKeyboard:(UITapGestureRecognizer *)recognizer {
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    [self.textField resignFirstResponder];
}


#pragma mark - GTCarNumFullKeyBoardDelegate 地区键盘
-(void)GTCarNumFullKeyBoard:(GTCarNumFullKeyBoard *)keyboard deleteBtnClickAction:(HJFCustomKeyboardButton *)sender{
    [self.textField deleteBackward];
    
}

-(void)GTCarNumFullKeyBoard:(GTCarNumFullKeyBoard *)keyboard normalBtnClickAction:(HJFCustomKeyboardButton *)sender{
    [self.textField insertText:sender.currentTitle];
}

-(void)GTCarNumFullKeyBoard:(GTCarNumFullKeyBoard *)keyboard switchBtnClickAction:(HJFCustomKeyboardButton *)sender{
    [self.textField resignFirstResponder];
    
    GTNumberAndAlphebetKeyboard *board2 = [GTNumberAndAlphebetKeyboard keyboard];
    board2.needKeyboardSoundEffect=  YES;
    board2.delegate  = self;
    self.textField.inputView =board2;
    [self.textField becomeFirstResponder];
    
    
}


#pragma mark - GTNumberAndAlphebetKeyboardDelegate 字母数字键盘
-(void)GTNumberAndAlphebetKeyboard:(GTNumberAndAlphebetKeyboard *)keyboard normalBtnClickAction:(HJFCustomKeyboardButton *)sender{
    [self.textField insertText:sender.currentTitle];
}

-(void)GTNumberAndAlphebetKeyboard:(GTNumberAndAlphebetKeyboard *)keyboard deleteBtnClickAction:(HJFCustomKeyboardButton *)sender{
    [self.textField deleteBackward];
    
}

-(void)GTNumberAndAlphebetKeyboard:(GTNumberAndAlphebetKeyboard *)keyboard switchBtnClickAction:(HJFCustomKeyboardButton *)sender{
    [self.textField resignFirstResponder];
    
    GTCarNumFullKeyBoard *board2 = [GTCarNumFullKeyBoard keyboard];
    board2.needKeyboardSoundEffect=  YES;
    board2.delegate  = self;
    self.textField.inputView =board2;
    [self.textField becomeFirstResponder];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
