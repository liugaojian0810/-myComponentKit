//
//  UIView+JJExtension.h
//  LGJTestFramework
//
//  Created by 刘高见 on 2021/4/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (JJExtension)

@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGPoint origin;


/// 取消当前或其子视图第一响应
- (BOOL)findAndResignFirstResponder;
/// 所在控制器对象
- (UIViewController *)viewController;
/// 移除所有子控制器
- (void)removeAllSubviews;

/// view切圆角
/// @param corners 各个角
/// @param cornerRadius 角大小
- (void)setCorner:(UIRectCorner)corners withRadius:(CGFloat)cornerRadius;

/// 切圆角
/// @param cornerRadius 圆角度值
- (void)setCornerRadius:(CGFloat)cornerRadius;

/// 以高为基准的圆角 高度的一半
- (void)setCornerHalfHeight;

/// 创建一个xib的视图对象
- (instancetype)createFromNibFile;

/// 震动动画
-(void)shake;

/// path画阴影，
/// @param row 阴影范围
- (void)setShadowColorWith:(NSInteger)row;

/// 绘制虚线
/// @param lineView 目标对象
/// @param lineLength 虚线实线长度
/// @param lineSpacing 虚线长度
/// @param lineColor 实线颜色
+ (void)drawLineOfDashByCAShapeLayer:(UIView *)lineView lineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor;

/// 绘制进度条虚线
/// @param lineLength 虚线实线长度
/// @param lineSpacing 虚线长度
/// @param lineColor 实线颜色
/// @param length 选中长度
+(void)progressViewWithLineLength:(CGFloat)lineLength lineSpacing:(CGFloat)lineSpacing lineColor:(UIColor *)lineColor length: (CGFloat)length lineView:(UIView *)lineView;

/// 设置点击事件
- (void)setTapActionWithBlock:(void (^)(void))block;

@end

NS_ASSUME_NONNULL_END
