//
//  SelfishTabbar.m
//  自定义的拖动tabbar
//
//  Created by ccSunday on 16/7/4.
//  Copyright © 2016年 ccSunday. All rights reserved.
//

#import "SelfishTabbar.h"
#import "UIView+frame.h"
@implementation SelfishTabbar

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (_show) {
        [self showPlusBtn];
    }else{
        [self removePlusbtn];
    }
}
//
- (void)showPlusBtn{
    _show = YES;
    //系统自带的按钮类型是UITabBarButton，找出这些类型的按钮，然后重新排布位置，空出中间的位置
    Class class = NSClassFromString(@"UITabBarButton");
        
    float btnIndex = 0.0;
    
    for (UIView *btn in self.subviews) {//遍历tabbar的子控件
        if ([btn isKindOfClass:class]) {//如果是系统的UITabBarButton，那么就调整子控件位置，空出中间位置
            //每一个按钮的宽度==tabbar的五分之一
            
            btn.width = self.width*2 /9;
            
            btn.x = btn.width * btnIndex;
            
            btnIndex++;
            //如果是索引是1(从0开始的)，直接让索引++，目的就是让消息按钮的位置向右移动，空出来发布按钮的位置
            if (btnIndex == 2) {
                btnIndex = btnIndex+0.5;
            }
            
        }
    }

}

- (void)removePlusbtn{
    _show = NO;
    Class class = NSClassFromString(@"UITabBarButton");
    int btnIndex = 0;
    for (UIView *btn in self.subviews) {//遍历tabbar的子控件
        if ([btn isKindOfClass:class]) {//如果是系统的UITabBarButton，那么就调整子控件位置，空出中间位置
            //每一个按钮的宽度==tabbar的五分之一
            btn.width = self.width / 4;
            btn.x = btn.width * btnIndex;
            btnIndex++;
            
        }
    }
}


//- (UIButton *)plusBtn{
//    if (!_plusBtn) {
//        _plusBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
//        _plusBtn.clipsToBounds = YES;
//        _plusBtn.frame = CGRectMake(self.width/2-30 , -30, 60, 60);
//    }
//    return _plusBtn;
//    
//}


////重写hitTest方法，去监听发布按钮的点击，目的是为了让凸出的部分点击也有反应
//- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
//    if (self.isHidden == NO) {
//        
//        //将当前tabbar的触摸点转换坐标系，转换到发布按钮的身上，生成一个新的点
//        CGPoint newP = [self convertPoint:point toView:self.plusBtn];
//        
//        //判断如果这个新的点是在发布按钮身上，那么处理点击事件最合适的view就是发布按钮
//        if ( [self.plusBtn pointInside:newP withEvent:event]) {
//            return self.plusBtn;
//        }else{//如果点不在发布按钮身上，直接让系统处理就可以了
//            return [super hitTest:point withEvent:event];
//        }
//    }
//    else {//tabbar隐藏了，那么说明已经push到其他的页面了，这个时候还是让系统去判断最合适的view处理就好了
//        return [super hitTest:point withEvent:event];
//    }
//    
//}

@end
