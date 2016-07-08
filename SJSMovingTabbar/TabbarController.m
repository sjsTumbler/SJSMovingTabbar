//
//  TabbarController.m
//  自定义的拖动tabbar
//
//  Created by ccSunday on 16/7/4.
//  Copyright © 2016年 ccSunday. All rights reserved.
//

#import "TabbarController.h"
#import "ViewController0.h"
#import "ViewController1.h"
#import "ViewController2.h"
#import "ViewController3.h"

// 颜色
// 参数格式为：0xFFFFFF
#define iColorWithHex(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16)) / 255.0 \
green:((float)((rgbValue & 0xFF00) >> 8)) / 255.0 \
blue:((float)(rgbValue & 0xFF)) / 255.0 alpha:1.0]


#define iViewWidth              [[UIScreen mainScreen] bounds].size.width       //界面宽度

#define iViewHeight             [[UIScreen mainScreen] bounds].size.height      //界面高度


@interface TabbarController ()
@property (nonatomic, strong)SelfishTabbar *selfBar;
@property (nonatomic, strong)NSMutableArray *selfishArray;
@end

@implementation TabbarController
{
    UIButton *  _workButton;
    int  _clickOrDrag;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpTabBar];
    [self initWithType:0];
    
    
    
    // 工作看板的入口按钮
    _workButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *workImage = [UIImage imageNamed:@"work_input"];
    CGRect mainBounds = [UIScreen mainScreen].bounds;
    NSDictionary * point = [[NSUserDefaults standardUserDefaults]objectForKey:@"workButtonPoint"];
    if(point == nil || [point objectForKey:@"x"]==0 || [point objectForKey:@"y"]==0 ){
        _workButton.frame = CGRectMake(mainBounds.size.width - workImage.size.width, mainBounds.size.height - 49 - workImage.size.height, workImage.size.width, workImage.size.height);
        NSMutableDictionary * pointDic = [NSMutableDictionary dictionary];
        [pointDic setObject:@(_workButton.center.x) forKey:@"x"];
        [pointDic setObject:@(_workButton.center.y) forKey:@"y"];
        [[NSUserDefaults standardUserDefaults]setObject:pointDic forKey:@"workButtonPoint"];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }else{
        
        _workButton.frame = CGRectMake(0 , 0, workImage.size.width, workImage.size.height);
        _workButton.center = CGPointMake([[point objectForKey:@"x"]floatValue],[[point objectForKey:@"y"]floatValue]);
    }
    [_workButton setBackgroundImage:workImage forState:UIControlStateNormal];
    [_workButton addTarget:self action:@selector(gotoWorkCollectionView:) forControlEvents:UIControlEventTouchUpInside];
    [_workButton addTarget:self action:@selector(dragMoving:withEvent: )forControlEvents: UIControlEventTouchDragInside];
    _clickOrDrag = 0;
    [self.view addSubview:_workButton];
    
}
#pragma mark   进入工作看板页面
/**
 @author Jesus
 
 @brief   进入工作看板页面
 */
- (void)gotoWorkCollectionView:(UIButton *)button
{
    if (_clickOrDrag == 0) {
        
    }else{
        //拖动后还原标志位
        _clickOrDrag = 0;
        CGPoint point = button.center;
        
        //30
        if (point.x > iViewWidth/2) {
            point.x = iViewWidth-30;
        }else{
            point.x = 30;
        }
        if (point.y < 30){
            point.y = 30;
        }
        //居中
        if(point.y > iViewHeight-80){
            point.y = iViewHeight-49;
            point.x = iViewWidth/2;
            
            [self.selfBar showPlusBtn];
        }else{
            [self.selfBar removePlusbtn];
        }
        
        NSMutableDictionary * pointDic = [NSMutableDictionary dictionary];
        [pointDic setObject:@(point.x) forKey:@"x"];
        [pointDic setObject:@(point.y) forKey:@"y"];
        [[NSUserDefaults standardUserDefaults]setObject:pointDic forKey:@"workButtonPoint"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        button.center = point;
    }
    
}
#pragma mark 拖动工作看板按钮
/**
 @author Jesus         , 16-06-15 10:06:26
 
 @brief  拖动工作看板按钮
 
 @param
 */
- (void) dragMoving: (UIButton *) button withEvent:event
{
    //拖动时改变标志位
    _clickOrDrag = 1;
    
    button.center = [[[event allTouches] anyObject] locationInView:self.view];
}

/**
 *  利用 KVC 把 系统的 tabBar改为自定义类型。
 */
- (void)setUpTabBar{
    [self setValue:self.selfBar forKey:@"tabBar"];//tabBar
}


- (void)initWithType:(NSInteger)type{
    
    self.viewControllers = self.selfishArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark 自定义tabbar
- (SelfishTabbar *)selfBar{
    if (!_selfBar) {
        _selfBar = [[SelfishTabbar alloc]init];
        NSDictionary * point = [[NSUserDefaults standardUserDefaults]objectForKey:@"workButtonPoint"];
        if(point != nil ){
            if ( [[point objectForKey:@"y"]intValue]  == iViewHeight-49 &&
                [[point objectForKey:@"x"]intValue] == iViewWidth/2){
                [self.selfBar showPlusBtn];
            }
        }
    }
    return _selfBar;
}

- (NSMutableArray *)selfishArray{
    if (!_selfishArray) {
        // 1.读plist文件
        NSString *path = [NSString stringWithFormat:@"%@/STabbar.plist",[[NSBundle mainBundle] resourcePath]];
        NSDictionary *plistDict = [[NSDictionary alloc] initWithContentsOfFile:path];
        NSArray *plistArr = plistDict[@"items"];
        
        
        _selfishArray = [NSMutableArray array];
        
        // 2.添加子控制器
        for (NSDictionary *unitDit in plistArr) {
            //1、获取子控制器
            UIViewController *destinationVc = [(UIViewController *)[NSClassFromString(unitDit[@"controller"]) alloc] init];
            //2.封装一个导航控制器
            UINavigationController *nav=[[UINavigationController alloc] initWithRootViewController:destinationVc];
            
            UIImage *selectedimage = [[UIImage imageNamed:[unitDit objectForKey:@"image_sel"]]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] ;
            UIImage *unselectedimage = [[UIImage imageNamed:[unitDit objectForKey:@"image"]]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            
            nav.tabBarItem = [[UITabBarItem alloc]initWithTitle:[unitDit objectForKey:@"title"] image:unselectedimage selectedImage:selectedimage];
            [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                               [UIColor whiteColor], NSForegroundColorAttributeName,
                                                               nil] forState:UIControlStateNormal];
            UIColor *titleHighlightedColor = iColorWithHex(0x4d9858);
            [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                               titleHighlightedColor, NSForegroundColorAttributeName,
                                                               nil] forState:UIControlStateSelected];
            //3.添加到子控制器
            [_selfishArray addObject: nav];
        }
    }
    return _selfishArray;
    
}






@end