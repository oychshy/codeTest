//
//  MidTextField.m
//  DSComic
//
//  Created by xhkj on 2021/9/23.
//  Copyright © 2021 oych. All rights reserved.
//

#import "MidTextField.h"

@implementation MidTextField

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (CGRect)placeholderRectForBounds:(CGRect)bounds {
    CGRect inset = CGRectMake(bounds.origin.x, bounds.origin.y, bounds.size.width, bounds.size.height);
    return inset;
}

- (CGRect)textRectForBounds:(CGRect)bounds {
    CGRect inset = CGRectMake(bounds.origin.x, bounds.origin.y, bounds.size.width, bounds.size.height);
    return inset;
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    if (self.text.length > 0) {
        return [super editingRectForBounds:bounds];
    } else {
        // 可通过默认文案来调整inset.origin.x保证光标在两个字之间
        CGRect inset = CGRectMake(bounds.origin.x + bounds.size.width / 2, bounds.origin.y, bounds.size.width - bounds.size.width / 2, bounds.size.height);
        return inset;
    }
}


@end
