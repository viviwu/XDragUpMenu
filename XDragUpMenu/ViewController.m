//
//  ViewController.m
//  XDragUpMenu
//
//  Created by viviwu on 2019/8/21.
//  Copyright © 2019 viviwu. All rights reserved.
//

#import "ViewController.h"
#import "XDragUpMenuView.h"
#import "XDragUpMenuController.h" 

@interface ViewController ()<UIGestureRecognizerDelegate, XDragUpMenuDelegate>
{
    XDragUpMenuView * _dragupMenu;
    XDragUpMenuController *_tView;
}
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UISwitch *skinSwitch;

@end

@implementation ViewController

- (XDragUpMenuView *)dragupMenu{
    if (!_dragupMenu) {
        _dragupMenu = [[XDragUpMenuView alloc]initWithMenuItems:@[self.newMenuItem,
                                                              self.newMenuItem,
                                                              self.newMenuItem,
                                                              self.newMenuItem,
                                                              self.newMenuItem]];
    }else{
//        CGRect frame = _dragupMenu.frame;
//        frame.origin.y = kScreenH/2;
//        _dragupMenu.frame = frame;
    }
    
    return _dragupMenu;
}

- (XMenuItem *)newMenuItem{
    return [XMenuItem menuItemWithTitle:@"菜单" iconeName:@"Icon"];
}

#pragma mark -- XDragUpMenuDelegate
- (void)dragUpMenuDidSelectedIndex:(NSInteger)index
{
    NSLog(@"dragUpMenu didSelectedIndex:%ld", (long)index);
}

- (void)dragUpMenuWillDisappear{
    NSLog(@"dragUpMenuWillDisappear");
}

/*
 UIModalPresentationFullScreen =0,//由下到上,全屏覆盖
 UIModalPresentationPageSheet,//在portrait时是FullScreen，在landscape时和FormSheet模式一样。
 UIModalPresentationFormSheet,// 会将窗口缩小，使之居于屏幕中间。在portrait和landscape下都一样，但要注意landscape下如果软键盘出现，窗口位置会调整。
 UIModalPresentationCurrentContext,//这种模式下，presented VC的弹出方式和presenting VC的父VC的方式相同。
 UIModalPresentationCustom,//自定义视图展示风格,由一个自定义演示控制器和一个或多个自定义动画对象组成。符合UIViewControllerTransitioningDelegate协议。使用视图控制器的transitioningDelegate设定您的自定义转换。
 UIModalPresentationOverFullScreen,//如果视图没有被填满,底层视图可以透过
 UIModalPresentationOverCurrentContext,//视图全部被透过
 UIModalPresentationPopover,
 UIModalPresentationNone ,
 */

- (IBAction)menuAction:(id)sender {
    NSInteger scheme = 2;
    if (0 == scheme) {
        self.dragupMenu.parentController = self;
        [self.view addSubview:_dragupMenu];
        _dragupMenu.clickHandle = ^(NSInteger index) {
            NSLog(@"clickHandle index = %ld", (long)index);
            self->_dragupMenu = nil;
        };
        
        _dragupMenu.disappear_block = ^{
            self->_dragupMenu = nil;
        };
    }else if(1 == scheme){
        if (!_tView) {
            _tView = [[XDragUpMenuController alloc] initWithMenuItems:@[self.newMenuItem,
                                                                        self.newMenuItem,
                                                                        self.newMenuItem,
                                                                        self.newMenuItem,
                                                                        self.newMenuItem]];
        }
        _tView.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        [self presentViewController:_tView animated:YES completion:nil];
    }else{
        _tView = nil;
        if (!_tView) {
            _tView = [[XDragUpMenuController alloc] initWithMenuItems:@[self.newMenuItem,
                                                                        self.newMenuItem,
                                                                        self.newMenuItem,
                                                                        self.newMenuItem,
                                                                        self.newMenuItem]];
        }
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:_tView];
//        nav.navigationBarHidden = YES;
        nav.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        nav.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        //必要配置
        self.modalPresentationStyle = UIModalPresentationCurrentContext;
        self.providesPresentationContextTransitionStyle = YES;
        self.definesPresentationContext = YES;
        [self presentViewController:nav animated:YES completion:nil];
    }
 
}

- (IBAction)tapToDismissMenu:(UITapGestureRecognizer *)sender {
#if 0
    if (sender.view == self.view) {
        [_dragupMenu removeFromSuperview];
        _dragupMenu = nil;
    }else{
        NSLog(@"%@", NSStringFromClass(sender.view.class));
    }
#else
    [_tView dismissViewControllerAnimated:YES completion:^{
        
    }];
    _tView = nil;
#endif
 
}

- (IBAction)switchSkin:(UISwitch *)sender {
    [NSNotificationCenter.defaultCenter postNotificationName:switchSkinNotificationName object:@(sender.on)];
    [NSUserDefaults.standardUserDefaults setBool:sender.on forKey:@"DARK"];
    [NSUserDefaults.standardUserDefaults synchronize];
}

#pragma mark -- UIGestureRecognizerDelegate
//- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
       shouldReceiveTouch:(UITouch *)touch {
    if (touch.view != self.view) {
        return NO;
    }
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(onSwitchSkin:) name:switchSkinNotificationName object:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self switchSkin:_skinSwitch];
    NSLog(@"self.view.frame == %@", NSStringFromCGRect(self.view.frame));
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [NSNotificationCenter.defaultCenter removeObserver:self];
}

- (void)onSwitchSkin:(NSNotification *)notify{
    BOOL dark = [notify.object boolValue];
    if (dark) {
        _imageView.image = [UIImage imageNamed:@"he.png"];
        _imageView.backgroundColor = UIColor.darkGrayColor;
        self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    }else{
        _imageView.image = [UIImage imageNamed:@"hua.jpg"];
        _imageView.backgroundColor = UIColor.whiteColor;
        self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    }
}


@end
