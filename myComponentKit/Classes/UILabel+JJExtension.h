//
//  UILabel+JJExtension.h
//  LGJTestFramework
//
//  Created by 刘高见 on 2021/4/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UILabel (JJExtension)

// 是否启用copy，默认为NO-不开启
@property (nonatomic, assign) BOOL isCopyable;

// 是否需要过滤空格，默认为NO-不过滤
@property (nonatomic, assign) BOOL canFilterEmpty;

/// label内边距
/// @param rect 内边距范围
- (void)mydrawTextInRect:(CGRect)rect;

- (void)adjust;

- (CGSize)boundingRectWithSize:(CGSize)size;

/**
 *  设置字间距
 */
- (void)setColumnSpace:(CGFloat)columnSpace;
/**
 *  设置行距
 */
- (void)setRowSpace:(CGFloat)rowSpace;

// 设置点击事件
- (void)setTapActionWithBlockWithLabel:(void (^)(void))block;


@end

NS_ASSUME_NONNULL_END
