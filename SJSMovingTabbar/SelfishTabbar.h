//
//  SelfishTabbar.h
//  自定义的拖动tabbar
//
//  Created by ccSunday on 16/7/4.
//  Copyright © 2016年 ccSunday. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SelfishTabbar : UITabBar

@property(nonatomic,assign)  BOOL show;

//-(instancetype)init;

- (void)showPlusBtn;
- (void)removePlusbtn;
@end
