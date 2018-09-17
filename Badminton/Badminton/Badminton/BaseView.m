//
//  BaseView.m
//  YouPlay
//
//  Created by Harvey on 2018/7/5.
//  Copyright © 2018年 Harvey. All rights reserved.
//

#import "BaseView.h"

@implementation BaseView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}

- (void)setUp {
    
}

+ (instancetype)initXiBView{
    NSString *selfClass = NSStringFromClass([self class]);
    return [[[NSBundle mainBundle] loadNibNamed:selfClass owner:nil options:nil] firstObject];
}
@end
