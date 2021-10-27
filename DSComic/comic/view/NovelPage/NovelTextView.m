//
//  NovelTextView.m
//  DSComic
//
//  Created by xhkj on 2021/10/26.
//  Copyright © 2021 oych. All rights reserved.
//

#import "NovelTextView.h"

@implementation NovelTextView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    [UIMenuController sharedMenuController].menuVisible = NO;  //donot display the menu
    [self resignFirstResponder];                      //do not allow the user to selected anything
    return NO;
}

@end
