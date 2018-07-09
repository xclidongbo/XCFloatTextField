//
//  UpShiftTextField.m
//  Test_UPTextField
//
//  Created by 李东波 on 12/6/2018.
//  Copyright © 2018 李东波. All rights reserved.
//

#import "FloatTextField.h"
#import <objc/runtime.h>

static char kBeginBlock;
static char kEndBlock;

@interface FloatTextField ()

@property (nonatomic,copy) NSString * placeholderText;
/**
 占位字体
 */
@property (nonatomic,strong) UIFont * placeholderFont;

/**
 占位颜色
 */
@property (nonatomic,strong) UIColor * placeholderColor;

@property (nonatomic,strong) UILabel * placeholderAnimationLbl;
@property (nonatomic,strong) NSAttributedString * placeHolderAttributedString;
//@property (nonatomic, assign) BOOL isUp;

@property (nonatomic, strong)NSLayoutConstraint * topConstraint;

@end

@implementation FloatTextField

static const NSTimeInterval kDuration = 0.3;

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self configureView];
    }
    return self;
}


- (void)configureView {
//    _placeholdAnimationable = YES;
    self.placeholderAnimationLbl = [[UILabel alloc] init];
    self.placeholderAnimationLbl.userInteractionEnabled = NO;
    self.placeholderAnimationLbl.font = [UIFont systemFontOfSize:14];
    self.placeholderFont = self.placeholderAnimationLbl.font;
    
    self.placeholderAnimationLbl.textColor = [UIColor colorWithRed:146/255.0 green:146/255.0 blue:146/255.0 alpha:1];
    self.placeholderColor = self.placeholderAnimationLbl.textColor;
    
    self.animationColor = self.placeholderColor;
//    self.animationFont = self.placeholderFont;
    self.animationFont = [UIFont systemFontOfSize:12];
    
    self.placeholderAnimationLbl.textAlignment = NSTextAlignmentLeft;
    
    self.clipsToBounds = NO;
    
    self.font = [UIFont systemFontOfSize:16];
    self.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
    [self addSubview:self.placeholderAnimationLbl];
    
    
    self.translatesAutoresizingMaskIntoConstraints = NO;
    self.placeholderAnimationLbl.translatesAutoresizingMaskIntoConstraints = NO;

    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.placeholderAnimationLbl attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.placeholderAnimationLbl attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.placeholderAnimationLbl attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
    _topConstraint = [NSLayoutConstraint constraintWithItem:self.placeholderAnimationLbl attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
    [self addConstraint:_topConstraint];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeEditing) name:UITextFieldTextDidChangeNotification object:nil];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidBeginEditing:) name:UITextFieldTextDidBeginEditingNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidEndEditing:) name:UITextFieldTextDidEndEditingNotification object:nil];
}

- (void)dealloc{
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidBeginEditingNotification object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidEndEditingNotification object:nil];
}


- (void)layoutSubviews {
    [super layoutSubviews];
//    NSLog(@"========================");
//    NSLog(@"Self frame: %@", NSStringFromCGRect(self.frame));
//    NSLog(@"Label frame: %@", NSStringFromCGRect(self.placeholderAnimationLbl.frame));
    
}
#pragma mark -
#pragma mark - getter setter

- (void)setPlaceholder:(NSString *)placeholder {
    _placeholderText = placeholder;
    self.placeholderAnimationLbl.text = placeholder;
}
- (void)setAttributedPlaceholder:(NSAttributedString *)attributedPlaceholder {
    _placeHolderAttributedString = attributedPlaceholder;
    self.placeholderAnimationLbl.attributedText = attributedPlaceholder;
}

- (void)setText:(NSString *)text{
    if (text.length > 0) {
        [self upAnimation];
    }else{
        [self restoreAnimation];
    }
    [super setText:text];
}

- (void)setFont:(UIFont *)font {
    [super setFont:font];
//    self.placeholderFont = font;
//    self.placeholderAnimationLbl.font = font;
}

//- (void)setAnimationFont:(UIFont *)animationFont {
//
//}
//
//- (void)setAnimationColor:(UIColor *)animationColor {
//
//}



- (BOOL)becomeFirstResponder {
    [self upAnimation];
    void(^beginBlock)(void) = objc_getAssociatedObject(self, &kBeginBlock);
    if (beginBlock) beginBlock();
    
    return [super becomeFirstResponder];
}
- (BOOL)resignFirstResponder {
    [self restoreAnimation];
    void(^endBlock)(void) = objc_getAssociatedObject(self, &kEndBlock);
    if (endBlock) endBlock();
    return [super resignFirstResponder];
}

//- (void)textFieldDidBeginEditing:(UITextField *)textField {
////    NSLog(@"%@",textField);
//    [self upAnimation];
//
//}
//
//- (void)textFieldDidEndEditing: (UITextField *)textField {
////    NSLog(@"%@", textField);
//    [self restoreAnimation];
//    void(^endBlock)(UITextField *) = objc_getAssociatedObject(self, &kEndBlock);
//    if (endBlock) endBlock(textField);
//}

#pragma mark -
#pragma mark - textfield

- (void)becomeFirstResponderComplete:(void(^)(void))block {
    objc_setAssociatedObject(self, &kBeginBlock, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)resignFirstResponderComplete:(void(^)(void))block {
    objc_setAssociatedObject(self, &kEndBlock, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
}


#pragma mark -
#pragma mark - keyboard notification

//- (void)keyboarWillShow: (NSNotification * )notification {
//    [self upAnimation];
//}
//
//- (void)keyboardWillHide: (NSNotification * )notification {
//    [self restoreAnimation];
//}

//- (void)changeEditing {
////    if (self.isUp) {
////        self.placeholderAnimationLbl.hidden = NO;
////    } else {
////        if ([self.text isEqualToString:@""]) {
////            self.placeholderAnimationLbl.hidden = NO;
////        } else {
////            self.placeholderAnimationLbl.hidden = YES;
////        }
////    }
//
////    NSLog(@"Self frame: %@", NSStringFromCGRect(self.frame));
////    NSLog(@"Label frame: %@", NSStringFromCGRect(self.placeholderAnimationLbl.frame));
//
//}


#pragma mark -
#pragma mark - animation

- (void)upAnimation {
    [self layoutIfNeeded];
    CGFloat height = -self.bounds.size.height;
    CGFloat constant = self.moveDistance<0?-(self.moveDistance+height):height ;
    
    [UIView animateWithDuration:kDuration delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:15 options:0 animations:^{
        
        self.topConstraint.constant = constant;
        self.placeholderAnimationLbl.alpha = 1;
        self.placeholderAnimationLbl.textColor = self.animationColor;
        self.placeholderAnimationLbl.font = self.animationFont;
        self.placeholderAnimationLbl.text = self.animationText;
        [self layoutIfNeeded];
        
    } completion:^(BOOL finished) {
    }];
    
}


- (void)restoreAnimation {
    if (self.text.length == 0) {
        [UIView animateWithDuration:kDuration animations:^{
            self.topConstraint.constant = 0;
            //        if (![self.text isEqualToString:@""]) self.placeholderAnimationLbl.alpha = 0;
            [self layoutIfNeeded];
        } completion:^(BOOL finished) {
            self.placeholderAnimationLbl.textColor = self.placeholderColor;
            if (self.placeHolderAttributedString) self.placeholderAnimationLbl.attributedText = self.placeHolderAttributedString;
            self.placeholderAnimationLbl.font = self.placeholderFont;
            self.placeholderAnimationLbl.text = self.placeholderText;
        }];
    }
    
}









@end
