//
//  UIView+JJExtension.m
//  LGJTestFramework
//
//  Created by 刘高见 on 2021/4/23.
//

#import "UIView+JJExtension.h"
#import <objc/message.h>

static char JJActionHandlerTapGestureKey;
static char JJActionHandlerTapBlockKey;

@implementation UIView (JJExtension)

- (void)setX:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (void)setY:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)x
{
    return self.frame.origin.x;
}

- (CGFloat)y
{
    return self.frame.origin.y;
}

- (void)setCenterX:(CGFloat)centerX
{
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (CGFloat)centerX
{
    return self.center.x;
}

- (void)setCenterY:(CGFloat)centerY
{
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

- (CGFloat)centerY
{
    return self.center.y;
}

- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (void)setSize:(CGSize)size
{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGSize)size
{
    return self.frame.size;
}

- (void)setOrigin:(CGPoint)origin
{
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGPoint)origin
{
    return self.frame.origin;
}

- (BOOL)findAndResignFirstResponder
{
    if (self.isFirstResponder) {
        [self resignFirstResponder];
        return YES;
    }
    for (UIView *subView in self.subviews) {
        if ([subView findAndResignFirstResponder])
            return YES;
    }
    return NO;
}

- (void)removeAllSubviews
{
    while (self.subviews.count)
    {
        UIView* child = self.subviews.lastObject;
        [child removeFromSuperview];
    }
}

- (UIViewController *)viewController
{
    UIResponder *responder = self;
    while ((responder = [responder nextResponder]))
        if ([responder isKindOfClass: [UIViewController class]])
            return (UIViewController *)responder;
    return nil;
}

- (void)setCorner:(UIRectCorner)corners withRadius:(CGFloat)cornerRadius
{
    [self layoutIfNeeded];
    CGRect rect = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:corners cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
    CAShapeLayer *shapLayer = [[CAShapeLayer alloc] init];
    shapLayer.frame = rect;
    shapLayer.path = path.CGPath;
    self.layer.mask = shapLayer;
}

- (void)setCornerRadius:(CGFloat)cornerRadius{
    CGRect rect = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:cornerRadius];
    CAShapeLayer *shapLayer = [[CAShapeLayer alloc] init];
    shapLayer.frame = rect;
    shapLayer.path = path.CGPath;
    self.layer.mask = shapLayer;
}

- (void)setCornerHalfHeight
{
    CGFloat height = self.height;
    UIBezierPath *maskPath=  [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(height/2-1, height/2-1)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    self.layer.masksToBounds=YES;
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

- (instancetype)createFromNibFile
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] firstObject];
}

-(void)shake
{
    self.translatesAutoresizingMaskIntoConstraints = YES;
    CALayer *lbl = [self layer];
    CGPoint posLbl = [lbl position];
    CGPoint y = CGPointMake(posLbl.x-3, posLbl.y);
    CGPoint x = CGPointMake(posLbl.x+3, posLbl.y);
    CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"position"];
    [animation setTimingFunction:[CAMediaTimingFunction
                                  functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [animation setFromValue:[NSValue valueWithCGPoint:x]];
    [animation setToValue:[NSValue valueWithCGPoint:y]];
    [animation setAutoreverses:YES];
    [animation setDuration:0.07];
    [animation setRepeatCount:3];
    [lbl addAnimation:animation forKey:nil];
    self.translatesAutoresizingMaskIntoConstraints = NO;
}

- (void)setShadowColorWith:(NSInteger)row {
    //路径阴影
       UIBezierPath *path = [UIBezierPath bezierPath];
       
       float width = self.bounds.size.width;
       float height = self.bounds.size.height;
       float x = self.bounds.origin.x;
       float y = self.bounds.origin.y;
       float addWH = row;
       
       CGPoint topLeft      = self.bounds.origin;
       CGPoint topMiddle = CGPointMake(x+(width/2),y-addWH);
       CGPoint topRight     = CGPointMake(x+width,y);
       
       CGPoint rightMiddle = CGPointMake(x+width+addWH,y+(height/2));
       
       CGPoint bottomRight  = CGPointMake(x+width,y+height);
       CGPoint bottomMiddle = CGPointMake(x+(width/2),y+height+addWH);
       CGPoint bottomLeft   = CGPointMake(x,y+height);
       
       
       CGPoint leftMiddle = CGPointMake(x-addWH,y+(height/2));
       
       [path moveToPoint:topLeft];
       //添加四个二元曲线
       [path addQuadCurveToPoint:topRight
                    controlPoint:topMiddle];
       [path addQuadCurveToPoint:bottomRight
                    controlPoint:rightMiddle];
       [path addQuadCurveToPoint:bottomLeft
                    controlPoint:bottomMiddle];
       [path addQuadCurveToPoint:topLeft
                    controlPoint:leftMiddle];
       //设置阴影路径
       self.layer.shadowPath = path.CGPath;
}

+ (void)drawLineOfDashByCAShapeLayer:(UIView *)lineView lineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor {
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setBounds:lineView.bounds];
    [shapeLayer setPosition:CGPointMake(CGRectGetWidth(lineView.frame) / 2, CGRectGetHeight(lineView.frame))];
    [shapeLayer setFillColor:[UIColor clearColor].CGColor];
    //  设置虚线颜色为blackColor
    [shapeLayer setStrokeColor:lineColor.CGColor];
    //  设置虚线宽度
    [shapeLayer setLineWidth: CGRectGetHeight(lineView.frame) > CGRectGetWidth(lineView.frame) ? CGRectGetWidth(lineView.frame) : CGRectGetHeight(lineView.frame)];
    [shapeLayer setLineJoin: kCALineJoinRound];
    //  设置线宽，线间距
    [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:lineLength], [NSNumber numberWithInt:lineSpacing],nil]];
    //  设置路径
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path,NULL, 0,0);
    if (CGRectGetHeight(lineView.frame) > CGRectGetWidth(lineView.frame)) {
        CGPathAddLineToPoint(path,NULL,0,CGRectGetHeight(lineView.frame));
    } else {
        CGPathAddLineToPoint(path,NULL,CGRectGetWidth(lineView.frame),0);
    }
    [shapeLayer setPath:path];
    CGPathRelease(path);
    //  把绘制好的虚线添加上来
    [lineView.layer addSublayer:shapeLayer];
}

+(void)progressViewWithLineLength:(CGFloat)lineLength lineSpacing:(CGFloat)lineSpacing lineColor:(UIColor *)lineColor length: (CGFloat)length lineView:(UIView *)lineView {
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setBounds:lineView.bounds];
    [shapeLayer setPosition:CGPointMake(CGRectGetWidth(lineView.frame) / 2, CGRectGetHeight(lineView.frame))];
    [shapeLayer setFillColor:[UIColor clearColor].CGColor];
    //  设置虚线颜色为blackColor
    [shapeLayer setStrokeColor:lineColor.CGColor];
    //  设置虚线宽度
    [shapeLayer setLineWidth: CGRectGetHeight(lineView.frame) > CGRectGetWidth(lineView.frame) ? CGRectGetWidth(lineView.frame) : CGRectGetHeight(lineView.frame)];
    [shapeLayer setLineJoin: kCALineJoinRound];
    //  设置线宽，线间距
    [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:lineLength], [NSNumber numberWithInt:lineSpacing],nil]];
    //  设置路径
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path,NULL, 0,0);
    if (CGRectGetHeight(lineView.frame) > CGRectGetWidth(lineView.frame)) {
        CGPathAddLineToPoint(path,NULL,0,length);
    } else {
        CGPathAddLineToPoint(path,NULL,length,0);
    }
    
    [shapeLayer setPath:path];
    CGPathRelease(path);
    //  把绘制好的虚线添加上来
    [lineView.layer addSublayer:shapeLayer];
}

- (void)setTapActionWithBlock:(void (^)(void))block {
    // 运行时获取单击对象
    UITapGestureRecognizer *gesture = objc_getAssociatedObject(self, &JJActionHandlerTapGestureKey);
    if (!gesture) {
        // 如果没有该对象，就创建一个
        gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleActionForTapGesture:)];
        [self addGestureRecognizer:gesture];
        // 绑定一下gesture
        objc_setAssociatedObject(self, &JJActionHandlerTapGestureKey, gesture, OBJC_ASSOCIATION_RETAIN);
    }
    // 绑定一下block
    objc_setAssociatedObject(self, &JJActionHandlerTapBlockKey, block, OBJC_ASSOCIATION_COPY);
}

- (void)handleActionForTapGesture:(UITapGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateRecognized) {
        // 取出上面绑定的block
        void(^action)(void) = objc_getAssociatedObject(self, &JJActionHandlerTapBlockKey);
        if (action) {
            action();
        }
    }
}


@end
