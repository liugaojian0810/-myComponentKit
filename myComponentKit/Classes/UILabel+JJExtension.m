//
//  UILabel+JJExtension.m
//  LGJTestFramework
//
//  Created by 刘高见 on 2021/4/23.
//

#import "UILabel+JJExtension.h"
#import <objc/message.h>
#import <CoreText/CoreText.h>

static char JJLabelActionHandlerTapGestureKey;
static char JJLabelActionHandlerTapBlockKey;

@implementation UILabel (JJExtension)

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    return (action == @selector(copyText:));
}

- (void)attachTapHandler {
    self.userInteractionEnabled = YES;
    UILongPressGestureRecognizer *g = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self addGestureRecognizer:g];
}

//  处理手势相应事件
- (void)handleTap:(UIGestureRecognizer *)g {
    [self becomeFirstResponder];
    UIMenuItem *item = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(copyText:)];
    [[UIMenuController sharedMenuController] setMenuItems:[NSArray arrayWithObject:item]];
    [[UIMenuController sharedMenuController] setTargetRect:self.frame inView:self.superview];
    [[UIMenuController sharedMenuController] setMenuVisible:YES animated:YES];
}

//  复制时执行的方法
- (void)copyText:(id)sender {
    //  通用的粘贴板
    UIPasteboard *pBoard = [UIPasteboard generalPasteboard];
    
    //  有些时候只想取UILabel的text中的一部分
    NSString *text = @"";
    if (objc_getAssociatedObject(self, @"expectedText")) {
        text = objc_getAssociatedObject(self, @"expectedText");
    } else {
        
        //  因为有时候 label 中设置的是attributedText
        //  而 UIPasteboard 的string只能接受 NSString 类型
        //  所以要做相应的判断
        if (self.text) {
            text = self.text;
        } else {
            text = self.attributedText.string;
        }
    }
    if (self.canFilterEmpty) {
        // 去除空格
        text = [text stringByReplacingOccurrencesOfString:@" " withString:@""];
    }
    pBoard.string = text;
}

- (BOOL)canBecomeFirstResponder {
    return [objc_getAssociatedObject(self, @selector(isCopyable)) boolValue];
}

- (void)setIsCopyable:(BOOL)number {
    objc_setAssociatedObject(self, @selector(isCopyable), [NSNumber numberWithBool:number], OBJC_ASSOCIATION_ASSIGN);
    [self attachTapHandler];
}

- (BOOL)isCopyable {
    return [objc_getAssociatedObject(self, @selector(isCopyable)) boolValue];
}

- (void)setCanFilterEmpty:(BOOL)canFilterEmpty{
    objc_setAssociatedObject(self, @selector(canFilterEmpty), [NSNumber numberWithBool:canFilterEmpty], OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)canFilterEmpty{
    return [objc_getAssociatedObject(self, @selector(canFilterEmpty)) boolValue];
}


#pragma mark--------内边距设置

- (void)mydrawTextInRect:(CGRect)rect
{
    UIEdgeInsets insets = {0, 5, 0, 5};
    [self drawTextInRect:UIEdgeInsetsInsetRect(rect, insets)];
}

- (void)adjust
{
    CGSize stringSize = [self.text boundingRectWithSize:CGSizeMake(self.frame.size.width, self.frame.size.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.font} context:nil].size;
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, stringSize.width, stringSize.height);
}

- (CGSize)boundingRectWithSize:(CGSize)size
{
    NSDictionary *attribute = @{NSFontAttributeName: self.font};
    
    CGSize retSize = [self.text boundingRectWithSize:size
                                             options:\
                      NSStringDrawingTruncatesLastVisibleLine |
                      NSStringDrawingUsesLineFragmentOrigin |
                      NSStringDrawingUsesFontLeading
                                          attributes:attribute
                                             context:nil].size;
    
    return retSize;
}

- (void)setColumnSpace:(CGFloat)columnSpace { NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText]; //调整间距
    [attributedString addAttribute:(__bridge NSString *)kCTKernAttributeName value:@(columnSpace) range:NSMakeRange(0, [attributedString length])];
    self.attributedText = attributedString;
    
}

- (void)setRowSpace:(CGFloat)rowSpace { self.numberOfLines = 0; NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText]; //调整行距
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init]; paragraphStyle.lineSpacing = rowSpace; paragraphStyle.baseWritingDirection = NSWritingDirectionLeftToRight; [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [self.text length])];
    self.attributedText = attributedString;
    
}

#pragma mark--------点击

- (void)setTapActionWithBlockWithLabel:(void (^)(void))block {
    // 运行时获取单击对象
    UITapGestureRecognizer *gesture = objc_getAssociatedObject(self, &JJLabelActionHandlerTapGestureKey);
    if (!gesture) {
        // 如果没有该对象，就创建一个
        gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleActionForTapGesture:)];
        [self addGestureRecognizer:gesture];
        // 绑定一下gesture
        objc_setAssociatedObject(self, &JJLabelActionHandlerTapGestureKey, gesture, OBJC_ASSOCIATION_RETAIN);
    }
    // 绑定一下block
    objc_setAssociatedObject(self, &JJLabelActionHandlerTapBlockKey, block, OBJC_ASSOCIATION_COPY);
}

- (void)handleActionForTapGesture:(UITapGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateRecognized) {
        // 取出上面绑定的block
        void(^action)(void) = objc_getAssociatedObject(self, &JJLabelActionHandlerTapBlockKey);
        if (action) {
            action();
        }
    }
}

@end
