//
//  JSActionSheet.h
//
//  Created by Golder on 2017/3/17.
//  Copyright © 2017年 Golder. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    JSActionStyleDefault,
    JSActionStyleCancel,
} JSActionStyle;

@interface JSAction : NSObject

+ (JSAction *)actionWithTitle:(NSString *)title actionStyle:(JSActionStyle)style handler:(void (^)(JSAction *action))handler;

@property (nonatomic, readonly, copy) NSString *title;
@property (readonly) JSActionStyle actionStyle;

@end

@interface JSActionSheet : UIView

+ (JSActionSheet *)actionSheetWithTitle:(NSString *)title;
- (void)addAction:(JSAction *)action;
- (void)show;

@property (nonatomic, readonly, copy) NSString *title;
@property (nonatomic, readonly, strong) NSArray<JSAction *> *actions;

@end
