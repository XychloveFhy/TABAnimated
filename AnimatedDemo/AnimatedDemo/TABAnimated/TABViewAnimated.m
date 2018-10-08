//
//  TABViewAnimated.m
//  lifeAndSport
//
//  Created by tigerAndBull on 2018/9/14.
//  Copyright © 2018年 tigerAndBull. All rights reserved.
//

#import "TABViewAnimated.h"
#import "TABMethod.h"
#import "UIView+Animated.h"
#import "UITableView+Animated.h"

static CGFloat defaultDuration = 0.4;
static CGFloat defaultLongAimatedWidth = 200;
static CGFloat defaultShortAimatedWidth = 130;

@implementation TABViewAnimated

- (void)startOrEndViewAnimated:(UIView *)view {
    
    switch (view.animatedStyle) {
            
        case TABViewAnimationStart:
            // 将状态设置为 进行中
            view.animatedStyle = TABViewAnimationRuning;
            // 添加并开启动画
            for (int i = 0; i < view.subviews.count; i++) {
                
                UIView *v = view.subviews[i];
                if ( v.loadStyle != TABViewLoadAnimationDefault ) {
                    [self initLayerWithView:v withColor:_animatedColor];
                }
            }
            break;
            
        case TABViewAnimationEnd:
            
            // 结束动画
            if ( view.subviews.count > 0 ) {
                
                // 移除动画图层
                for (int i = 0; i < view.subviews.count; i++) {
                    
                    UIView *v = view.subviews[i];
                    
                    if ( v.layer.sublayers.count > 0 ) {
                        
                        NSArray<CALayer *> *subLayers = v.layer.sublayers;
                        NSArray<CALayer *> *removedLayers = [subLayers filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id  _Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
                            
                            if ([evaluatedObject isKindOfClass:[CALayer class]]) {
                                
                                // 找出CALayer是你需要移除的，这里根据背景色来判断的
                                CALayer *layer = (CALayer *)evaluatedObject;
                                if (CGColorEqualToColor(layer.backgroundColor,self->_animatedColor.CGColor)) {
                                    return YES;
                                }
                                return NO;
                            }
                            return NO;
                        }]];
                        
                        [removedLayers enumerateObjectsUsingBlock:^(CALayer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                            [obj removeFromSuperlayer];
                        }];
                    }
                }
            }
            break;
            
        default:
            break;
    }
}

- (void)startOrEndTableAnimated:(UITableViewCell *)cell {
    
    UITableView *superView = (UITableView *)cell.superview;
    
    switch (superView.animatedStyle) {
            
        case TABTableViewAnimationStart:
            // 添加并开启动画
            for (int i = 0; i < cell.contentView.subviews.count; i++) {
                UIView *v = cell.contentView.subviews[i];
                if ( v.loadStyle != TABViewLoadAnimationDefault ) {
                    [self initLayerWithView:v withColor:_animatedColor];
                }
            }
            break;
            
        case TABTableViewAnimationEnd:
            
            // 结束动画
            if ( cell.contentView.subviews.count > 0 ) {
                
                // 移除动画图层
                for (int i = 0; i < cell.contentView.subviews.count; i++) {
                    
                    UIView *v = cell.contentView.subviews[i];
                    
                    if ( v.layer.sublayers.count > 0 ) {
                        
                        NSArray<CALayer *> *subLayers = v.layer.sublayers;
                        NSArray<CALayer *> *removedLayers = [subLayers filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id  _Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
                            
                            if ([evaluatedObject isKindOfClass:[CALayer class]]) {
                                
                                // 找出CALayer是你需要移除的，这里根据背景色来判断的
                                CALayer *layer = (CALayer *)evaluatedObject;
                                if (CGColorEqualToColor(layer.backgroundColor,self->_animatedColor.CGColor)) {
                                    return YES;
                                }
                                return NO;
                            }
                            return NO;
                        }]];
                        
                        [removedLayers enumerateObjectsUsingBlock:^(CALayer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                            [obj removeFromSuperlayer];
                        }];
                    }
                }
            }
            break;
            
        default:
            break;
    }
}

#pragma mark - Private Methods

- (void)addLinesLabAnimated:(UILabel *)lab withColor:(UIColor *)color{
    
    for (int i = 0; i < lab.numberOfLines; i++) {
        
        CALayer *layer = [[CALayer alloc]init];
        layer.backgroundColor = color.CGColor;
        layer.anchorPoint = CGPointMake(0, 0);
        layer.position = CGPointMake(0, 0);
        
        if (i == (lab.numberOfLines-1)) {
            layer.frame = CGRectMake(0, (i == 0)?(0):(i*(lab.frame.size.height/(lab.numberOfLines)-10)+10), lab.frame.size.width/2, lab.frame.size.height/(lab.numberOfLines)-10);
            // 添加一个基本动画
            [layer addAnimation:[self scaleXAnimation:lab.loadStyle] forKey:@"scaleAnimation"];
        }else {
            layer.frame = CGRectMake(0, (i == 0)?(0):(i*(lab.frame.size.height/(lab.numberOfLines)-10)+10), lab.frame.size.width, lab.frame.size.height/(lab.numberOfLines)-10);
        }
        [lab.layer addSublayer:layer];
    }
}

/**
 加载CALayer,设置动画,同时启动
 
 @param view 需要动画的view
 @param color 动画颜色
 */
- (void)initLayerWithView:(UIView *)view withColor:(UIColor *)color {

//    if ([view isKindOfClass:[UILabel class]]) {
//        UILabel *lab = (UILabel *)view;
//        if ( lab.numberOfLines != 1 ) {
//            [self addLinesLabAnimated:lab withColor:color];
//        }else {
//            CALayer *layer = [[CALayer alloc]init];
//            layer.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height);
//            layer.backgroundColor = color.CGColor;
//            layer.anchorPoint = CGPointMake(0, 0);
//            layer.position = CGPointMake(0, 0);
//            // 添加一个基本动画
//            [layer addAnimation:[self scaleXAnimation:view.loadStyle] forKey:@"scaleAnimation"];
//
//            [view.layer addSublayer:layer];
//        }
//    }
    
    if (view.frame.size.width == 0) {
        
        if (view.loadStyle == TABViewLoadAnimationShort) {
            view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y, view.tabViewWidth>0?view.tabViewWidth:defaultLongAimatedWidth, view.frame.size.height);
        }else {
            if (view.loadStyle == TABViewLoadAnimationLong) {
                view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y, view.tabViewWidth>0?view.tabViewWidth:defaultShortAimatedWidth, view.frame.size.height);
            }
        }
    }
    
    CALayer *layer = [[CALayer alloc]init];
    layer.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height);
    layer.backgroundColor = color.CGColor;
    layer.anchorPoint = CGPointMake(0, 0);
    layer.position = CGPointMake(0, 0);
    // 添加一个基本动画
    [layer addAnimation:[self scaleXAnimation:view.loadStyle] forKey:@"scaleAnimation"];
    
    [view.layer addSublayer:layer];
}

/**
 根据动画类型设置对应基础动画
 
 @param style 动画类型
 @return 动画
 */
- (CABasicAnimation *)scaleXAnimation:(TABViewLoadAnimationStyle)style {
    
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"transform.scale.x"];
    anim.removedOnCompletion = NO;        // 保证从前台进入后台仍能执行
    anim.duration = _animatedDuration;
    anim.autoreverses = YES;              // 往返都有动画
    anim.repeatCount = MAXFLOAT;          // 执行次数
    
    switch (style) {
            
        case TABViewLoadAnimationShort:{
            anim.toValue = @0.6;
        }
        break;
            
        case TABViewLoadAnimationLong:{
            anim.toValue = @1.6;
        }
        break;
            
        default:{
            anim.toValue = @0.6;
        }
    }
    
    return anim;
}

#pragma mark - Initize Methods

+ (TABViewAnimated *)sharedAnimated {
    
    static TABViewAnimated *tabAnimated;
    
    if (tabAnimated == nil){
        tabAnimated = [[TABViewAnimated alloc] init];
    }
    return tabAnimated;
}

- (instancetype)init {
    
    self = [super init];
    
    if (self) {
        _animatedDuration = defaultDuration;
        _animatedColor = tab_kBackColor;
    }
    return self;
}

- (void)initWithAnimatedDuration:(CGFloat)duration withColor:(UIColor *)color {
    
    if (self) {
        _animatedDuration = duration;
        _animatedColor = color;
    }
}

@end
