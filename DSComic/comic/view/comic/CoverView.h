//
//  CoverView.h
//  DSComic
//
//  Created by xhkj on 2021/7/29.
//  Copyright © 2021 oych. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CoverView : UIView
@property (nonatomic, copy) void(^backBtnAction)(void);
@property (nonatomic, copy) void(^tapSend)(void);
@property (nonatomic, copy) void(^slidePage)(NSInteger selectedPage);

@property(retain,nonatomic)UIView *topView;
@property(retain,nonatomic)UIView *clearView;
@property(retain,nonatomic)UIView *bottomView;

-(void)setCoverViewWithTitle:(NSString*)title CurrentPage:(NSInteger)currentPage Totle:(NSInteger)totlePage;

@end

NS_ASSUME_NONNULL_END
