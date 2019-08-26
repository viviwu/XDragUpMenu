//
//  XDragUpMenuController.m
//  XDragUpMenu
//
//  Created by vivi wu on 2019/8/23.
//  Copyright © 2019 viviwu. All rights reserved.
//

#import "XDragUpMenuController.h"
 #import <objc/runtime.h>

static XDragUpMenuController * instance = nil;

@interface XDragUpMenuController ()<UITableViewDelegate, UITableViewDataSource>
{
    BOOL DARK;
    BOOL DOWN;
}
@property(nonatomic, strong) UIImageView * dragIcon;
@property(nonatomic, strong) UIVisualEffectView * effectView;

- (UIView *)targetView;

@end


@implementation XDragUpMenuController

- (instancetype)init{
    self = [super init];
    if (self) {
//        [self initialization];
        
        [self.view addSubview:self.effectView];
        [self.view addSubview:self.tableView];
    }
    return self;
}

- (instancetype)initWithMenuItems:(NSArray<XMenuItem *>*)menuItems{
   
    self = [super init];
    if (self) {
        self.menuItems = menuItems;
//        [self initialization];
        
        [self.view addSubview:self.effectView];
        [self.view addSubview:self.tableView];
        
        self.dragIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"drag_line_bar"]];
        self.dragIcon.frame = CGRectMake(kScreenW/2-32, 0, 64, 28);
        [self.view addSubview:self.dragIcon];
 
        [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(onSwitchSkin:) name:switchSkinNotificationName object:nil];
    }
    return self;
}

-(UIVisualEffectView *)effectView{
    if (!_effectView) {
        DARK = NO;
        DARK = [NSUserDefaults.standardUserDefaults   boolForKey:@"DARK"];
        UIBlurEffect * blur = nil;
        if (DARK) {
            blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        }else{
            if (@available(iOS 10.0, *)) {
                blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleProminent];
            } else {
                blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
            }
        }
        _effectView = [[UIVisualEffectView alloc]initWithEffect:blur];
        _effectView.frame = self.view.bounds;
    }
    return _effectView;
}

- (UITableView *)tableView{
    if (!_tableView) {
        CGFloat tableH = kCellH * self.menuItems.count + 2*kHeaderH;
        CGRect rect = CGRectMake(GAP, TOP, kScreenW-2*GAP, tableH);
        _tableView = [[UITableView alloc]initWithFrame:rect style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:XMenuItemCell.class forCellReuseIdentifier:kCellReuseIdentifier];
        
        _tableView.layer.cornerRadius = 2;
        _tableView.layer.borderColor = UIColor.clearColor.CGColor;
        _tableView.layer.borderWidth = 0.5;
        _tableView.alpha = 0.8;
        //        _tableView.backgroundColor = UIColor.darkGrayColor;
    }
    return _tableView;
}

- (void)setMenuItems:(NSArray<XMenuItem *> *)menuItems
{
    _menuItems = menuItems;
    [self layoutSubviews];
}

- (void)initialization{
    UIView * view = self.view;
    if (self.navigationController) {
        view = self.navigationController.view;
    }
    [self qualifyView:view];
}

- (void)qualifyView:(UIView *)view{
    view.clipsToBounds = YES;
    view.layer.cornerRadius = 12;
    view.layer.borderColor = UIColor.clearColor.CGColor;
    view.layer.borderWidth = 0.5;
    view.userInteractionEnabled = YES;
    view.backgroundColor = UIColor.clearColor;
}

- (UIView *)targetView{
    if (self.navigationController) {
        return self.navigationController.view;
    }else
        return self.view;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    [self initialization];
    
    instance = self;
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.navigationController) {
//        [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
//        [self.navigationController.navigationBar setShadowImage:nil];
        [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    }
  
    [self layoutSubviews];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    [self resetViewFrame];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
   self.title = @"XDragUpMenu";
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)resetViewFrame{
    UIView * view = self.view;
    if (self.navigationController) {
        view = self.navigationController.view;
    }
    CGRect frame = view.frame;
    frame.origin.y = kScreenH/2;
    view.frame = frame;
}

- (void)onSwitchSkin:(NSNotification *)notify{
    DARK = [notify.object boolValue];
    [self layoutSubviews];
}

- (void)layoutSubviews
{
    CGFloat tableH = kCellH * self.menuItems.count + 2*kHeaderH;
    CGRect rect = CGRectMake(GAP, TOP, kScreenW-2*GAP, tableH);
    self.tableView.frame = rect;
    if (DARK) {
        self.effectView.effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        self.tableView.backgroundColor = UIColor.darkGrayColor;
    }else{
        if (@available(iOS 10.0, *)) {
            self.effectView.effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleProminent];
        } else {
            // Fallback on earlier versions
            self.effectView.effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        }
        self.tableView.backgroundColor = UIColor.whiteColor;
    }
    if (DOWN) {
        self.dragIcon.image = [UIImage imageNamed:@"drag_arrow_down"];
    }else{
        self.dragIcon.image = [UIImage imageNamed:@"drag_line_bar"];
    }
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event{
//    UITouch * touch  = touches.anyObject;
//    CGPoint location = [touch locationInView:self.view];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event{
    UITouch * touch  = touches.anyObject;
    CGPoint location = [touch locationInView:self.view];
    CGPoint lastPoint = [touch previousLocationInView:self.view];
    CGFloat deltaY = location.y - lastPoint.y;
//    NSLog(@"touchesBegan location:%@", NSStringFromCGPoint(location));
    BOOL arrow_down = NO;
    UIView * view = self.view;
    if (self.navigationController) {
        view = self.navigationController.view;
    }
    view.transform =CGAffineTransformTranslate(view.transform, 0, deltaY);
    if (view.frame.origin.y<kScreenH*0.4) {
        arrow_down = YES;
    }else{
        arrow_down = NO;
    }
    if (arrow_down != DOWN) {
        DOWN = arrow_down;
        [self layoutSubviews];
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event{
    CGFloat safeTop = 64.0;
    CGFloat safeBottom = 0;
    if (@available(iOS 11.0, *)) {
        safeTop = self.view.safeAreaInsets.top;
        safeBottom = self.view.safeAreaInsets.top;
    } else {
        // Fallback on earlier versions
    }
//    NSLog(@"safeTop==%f safeBottom==%f", safeTop, safeBottom);
    CGFloat deltaY = 0;
    UIView * view = self.view;
    if (self.navigationController) {
        view = self.navigationController.view;
    }
    if(view.frame.origin.y<kScreenH*0.4){
        deltaY = view.frame.origin.y - safeTop;
    }else if (view.frame.origin.y>kScreenH*0.6) {
        deltaY = view.frame.origin.y-kScreenH;
    }
    if (fabs(deltaY)>0) {
        __weak typeof(self) weakSelf = self;
        [UIView animateWithDuration:0.25 animations:^{
            view.transform =CGAffineTransformTranslate(view.transform, 0, -deltaY);
        } completion:^(BOOL finished) {
            if (view.frame.origin.y>kScreenH-safeTop) {
                [view removeFromSuperview];
                if (weakSelf.disappear_block) {
                    weakSelf.disappear_block();
                }
                if ([self.delegate conformsToProtocol:@protocol(XDragUpMenuDelegate)]) {
                    [self.delegate  dragUpMenuWillDisappear];
                }
                
                UIViewController * vc = weakSelf.navigationController ?: weakSelf;
                [vc dismissViewControllerAnimated:YES completion:^{ }];
                NSLog(@"[self removeFromSuperview] %@", self);
            }
        }];
    }
}


#pragma mark -- UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate conformsToProtocol:@protocol(XDragUpMenuDelegate)]) {
        [self.delegate  dragUpMenuDidSelectedIndex:indexPath.row];
    }
    if (_clickHandle) {
        _clickHandle(indexPath.row);
    }
    
    [self dismissViewControllerAnimated:YES completion:^{ }];
//    UITableViewController * tabbleVC = [[UITableViewController alloc]initWithStyle:UITableViewStylePlain];
//    [self.navigationController pushViewController:tabbleVC animated:YES];

}

#pragma mark -- UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.menuItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XMenuItemCell * cell = [tableView dequeueReusableCellWithIdentifier:kCellReuseIdentifier forIndexPath:indexPath];
    
    XMenuItem * item = self.menuItems[indexPath.row];
    [cell refreshWithData:item];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kCellH;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return kHeaderH;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return kHeaderH;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end


#pragma mark -- UINavigationBar (X)

@implementation UINavigationBar (X)

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (self == instance.navigationController.navigationBar) {
        [instance touchesMoved:touches withEvent:event];
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (self == instance.navigationController.navigationBar) {
        [instance touchesEnded:touches withEvent:event];
    }
}

@end
