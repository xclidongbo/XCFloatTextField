//
//  UpShiftTextField.h
//  Test_UPTextField
//
//  Created by 李东波 on 12/6/2018.
//  Copyright © 2018 李东波. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FloatTextField : UITextField


/**
 placeholder 浮动时的颜色
 */
@property (nonatomic, strong) UIColor * animationColor;

/**
 placeholder 浮动时的字体
 */
@property (nonatomic, strong) UIFont * animationFont;



/**
 placeholder 浮动时的文字
 */
@property (nonatomic, strong) NSString * animationText;


/**
 移动距离 默认animationText底部对齐textfield顶端
 */
@property (nonatomic, assign) CGFloat moveDistance;


- (void)becomeFirstResponderComplete:(void(^)(void))block;
- (void)resignFirstResponderComplete:(void(^)(void))block;

@end
