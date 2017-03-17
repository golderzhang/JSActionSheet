//
//  JSActionSheet.m
//
//  Created by Golder on 2017/3/17.
//  Copyright © 2017年 Golder. All rights reserved.
//

#import "JSActionSheet.h"

#define BACK_COLOR [UIColor colorWithWhite:1.0 alpha:0.9]
#define btnH    48

@interface JSAction ()

@property (nonatomic, copy) void (^handler)(JSAction *action);

@end

@implementation JSAction

- (instancetype)initWithTitle:(NSString *)title actionStyle:(JSActionStyle)style handler:(void (^)(JSAction *action))handler {
    self = [super init];
    if (self) {
        _title = title;
        _actionStyle = style;
        _handler = handler;
    }
    return self;
}

+ (JSAction *)actionWithTitle:(NSString *)title actionStyle:(JSActionStyle)style handler:(void (^)(JSAction *action))handler {
    JSAction *action = [[JSAction alloc] initWithTitle:title actionStyle:style handler:handler];
    return action;
}

- (void)action {
    if (_handler) {
        _handler(self);
    }
}

@end

@interface JSActionSheet ()

@property (nonatomic, strong) UIView *backLayer;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) NSMutableArray<JSAction *> *actionsArray;
@property (nonatomic, strong) NSMutableArray<UIButton *> *buttonsArray;
@property NSInteger buttonIndex;

@end

@implementation JSActionSheet

+ (JSActionSheet *)actionSheetWithTitle:(NSString *)title {
    JSActionSheet *sheet = [[JSActionSheet alloc] initWithTitle:title];
    return sheet;
}

- (instancetype)initWithTitle:(NSString *)title {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        
        _buttonIndex = 0;
        
        _actionsArray = [NSMutableArray array];
        _buttonsArray = [NSMutableArray array];
        
        self.backgroundColor = [UIColor clearColor];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
        _maskView = [[UIView alloc] initWithFrame:CGRectZero];
        _maskView.backgroundColor = [UIColor blackColor];
        _maskView.alpha = 0.4;
        [_maskView addGestureRecognizer:tap];
        [self addSubview:_maskView];
        
        _backLayer = [[UIView alloc] initWithFrame:CGRectZero];
        _backLayer.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:_backLayer];
        
        if (title) {
            _title = title;
            self.titleLabel.text = _title;
        }
    }
    return self;
}

- (CGFloat)contentHeight {
    return (_title.length > 0) ? (45 + btnH*_buttonsArray.count) : (btnH*_buttonsArray.count);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _maskView.frame = self.bounds;
    
    CGFloat Height = CGRectGetHeight(self.bounds);
    CGFloat contentWith = CGRectGetWidth(self.bounds);
    CGFloat contentHeight = [self contentHeight];
    CGFloat y = 0;
    
    _maskView.frame = CGRectMake(0, 0, contentWith, Height);
    _backLayer.frame = CGRectMake(0, Height-contentHeight, contentWith, contentHeight);
    if (_title.length > 0) {
        _titleLabel.frame = CGRectMake(0, 0, contentWith, 45);
        y += 45;
    }
    
    for (UIButton *btn in _buttonsArray) {
        NSInteger index = btn.tag;
        JSAction *action = _actionsArray[index];
        if (action.actionStyle == JSActionStyleDefault) {
            btn.frame = CGRectMake(0, y+0.5, contentWith, btnH-0.5);
        } else {
            btn.frame = CGRectMake(0, y+3, contentWith, btnH-3);
        }
        y += btnH;
    }
}

- (void)addAction:(JSAction *)action {
    if (action) {
        [_actionsArray addObject:action];
        UIButton *btn = [self buttonWithAction:action];
        btn.tag = _buttonIndex++;
        [_buttonsArray addObject:btn];
        [_backLayer addSubview:btn];
        [self setNeedsLayout];
    }
}

- (UIButton *)buttonWithAction:(JSAction *)action {
    if (!action)
        return nil;
    
    UIColor *titleColor = (action.actionStyle == JSActionStyleDefault) ? [UIColor blackColor] : [UIColor redColor];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = BACK_COLOR;
    [btn setTitle:action.title forState:UIControlStateNormal];
    [btn setTitleColor:titleColor forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(onClickBtn:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

- (void)onClickBtn:(UIButton *)button {
    [self hide];
    NSInteger index = button.tag;
    JSAction *action = _actionsArray[index];
    [action performSelector:@selector(action)];
}

- (void)show {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        self.frame = window.bounds;
        [window addSubview:self];
        
        CATransition *transition = [CATransition animation];
        transition.type = kCATransitionFade;
        [window.layer addAnimation:transition forKey:@"transition"];
        
        CGFloat sH = CGRectGetMaxY(window.bounds) + [self contentHeight]/2.0;
        CGFloat eH = CGRectGetMaxY(window.bounds) - [self contentHeight]/2.0;
        CABasicAnimation *pop = [CABasicAnimation animationWithKeyPath:@"position.y"];
        pop.fromValue = @(sH);
        pop.toValue = @(eH);
        [_backLayer.layer addAnimation:pop forKey:@"pop"];
    });
}

- (void)hide {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        
        [CATransaction begin];
        [CATransaction setCompletionBlock:^{
            [_maskView.layer removeAnimationForKey:@"opacity"];
            [_backLayer.layer removeAnimationForKey:@"pop"];
            [self removeFromSuperview];
        }];
        
        CABasicAnimation *opacity = [CABasicAnimation animationWithKeyPath:@"opacity"];
        opacity.toValue = @(0.0);
        opacity.fillMode = kCAFillModeForwards;
        opacity.removedOnCompletion = NO;
        [_maskView.layer addAnimation:opacity forKey:@"opacity"];
        
        CGFloat sH = CGRectGetMaxY(window.bounds) - [self contentHeight]/2.0;
        CGFloat eH = CGRectGetMaxY(window.bounds) + [self contentHeight]/2.0;
        CABasicAnimation *pop = [CABasicAnimation animationWithKeyPath:@"position.y"];
        pop.fromValue = @(sH);
        pop.toValue = @(eH);
        pop.fillMode = kCAFillModeForwards;
        pop.removedOnCompletion = NO;
        [_backLayer.layer addAnimation:pop forKey:@"pop"];
        
        [CATransaction commit];
    });
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.backgroundColor = BACK_COLOR;
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.textColor = [UIColor lightGrayColor];
        [_backLayer.layer addSublayer:_titleLabel.layer];
    }
    return _titleLabel;
}

- (NSArray<JSAction *> *)actions {
    return _actionsArray;
}

@end
