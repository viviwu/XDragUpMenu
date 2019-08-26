//
//  XDragUpMenu.m
//  XTree
//
//  Created by vivi wu on 2019/8/21.
//  Copyright © 2019 viviwu. All rights reserved.
//

#import "XDragUpMenuView.h" 


@interface XDragUpMenuView ()<UITableViewDelegate, UITableViewDataSource>
{
    BOOL DARK;
    BOOL DOWN;
}
@property(nonatomic, strong) UIImageView * dragIcon;

@end

@implementation XDragUpMenuView

- (instancetype)initWithMenuItems:(NSArray<XMenuItem *>*)menuItems{
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
    self = [super initWithEffect:blur];
    if (self) {
        self.menuItems = menuItems;
        CGRect frame = UIScreen.mainScreen.bounds;
        frame.origin.y = kScreenH/2;
        NSLog(@"frame:%@", NSStringFromCGRect(frame));
        self.frame = frame;
        self.clipsToBounds = YES;
        self.layer.cornerRadius = 12;
        self.layer.borderColor = UIColor.clearColor.CGColor;
        self.layer.borderWidth = 0.5;
        self.userInteractionEnabled = YES;
        //        self.alpha =0.5;
        //        self.backgroundColor = UIColor.whiteColor;
        [self.contentView addSubview:self.tableView];
        
        self.dragIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"drag_line_bar"]];
        self.dragIcon.frame = CGRectMake(kScreenW/2-32, 0, 64, 28);
        [self.contentView addSubview:self.dragIcon];
#if 0
        NSString * hsVFL = [NSString stringWithFormat:@"H:|-%d-[tableView]-%d-|", GAP, GAP];
        NSArray<__kindof NSLayoutConstraint *> * hConstraints = [NSLayoutConstraint constraintsWithVisualFormat:hsVFL options:0 metrics:nil views:@{@"tableView":self.tableView}];
        [self.contentView addConstraints:hConstraints];
        
        CGFloat tableH = kCellH * self.menuItems.count + 2*kHeaderH;
        NSString * vsVFL = [NSString stringWithFormat:@"V:|-%d-[tableView(%d)]", TOP, (unsigned int)tableH];
        NSArray<__kindof NSLayoutConstraint *> * vConstraints = [NSLayoutConstraint constraintsWithVisualFormat:vsVFL options:0 metrics:nil views:@{@"tableView":self.tableView}];
        [self.contentView addConstraints:vConstraints];
        NSLog(@"hsVFL:%@ \n vsVFL:%@", hsVFL, vsVFL);
#endif
        [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(onSwitchSkin:) name:switchSkinNotificationName object:nil];
    }
    return self;
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

- (void)setParentController:(UIViewController *)parentController
{
    _parentController = parentController;
}

-(void)dealloc{
    [NSNotificationCenter.defaultCenter removeObserver:self];
}

- (void)onSwitchSkin:(NSNotification *)notify{
    DARK = [notify.object boolValue];
    [self setNeedsLayout];
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    if (DARK) {
        self.effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        self.tableView.backgroundColor = UIColor.darkGrayColor;
    }else{
        if (@available(iOS 10.0, *)) {
            self.effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleProminent];
        } else {
            // Fallback on earlier versions
            self.effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        }
        self.tableView.backgroundColor = UIColor.whiteColor;
    }
    if (DOWN) {
        self.dragIcon.image = [UIImage imageNamed:@"drag_arrow_down"];
    }else{
        self.dragIcon.image = [UIImage imageNamed:@"drag_line_bar"];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event{
 
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event{
    
    UITouch * touch  = touches.anyObject;
    CGPoint location = [touch locationInView:self.parentController.view];
    CGPoint lastPoint = [touch previousLocationInView:self.parentController.view];
    
    CGFloat deltaY = location.y - lastPoint.y;
    self.transform =CGAffineTransformTranslate(self.transform, 0, deltaY);
    
    BOOL arrow_down = NO;
    if (self.frame.origin.y<kScreenH/2) {
        arrow_down = YES;
    }else{
        arrow_down = NO;
    }
    if (arrow_down != DOWN) {
        DOWN = arrow_down;
        [self setNeedsLayout];
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event{
    CGFloat safeTop = 64.0;
    CGFloat safeBottom = 0;
    if (@available(iOS 11.0, *)) {
        safeTop = self.parentController.view.safeAreaInsets.top;
        safeBottom = self.parentController.view.safeAreaInsets.top;
    } else {
        // Fallback on earlier versions
    }
    
    CGFloat deltaY = 0;
    if(self.frame.origin.y<kScreenH*0.4){
        deltaY = self.frame.origin.y - safeTop;
    }else if (self.frame.origin.y>kScreenH*0.6) {
        deltaY = self.frame.origin.y-kScreenH;
    }
    
    if (fabs(deltaY)>0) {
        __weak typeof(self) weakSelf =self;
        [UIView animateWithDuration:0.25 animations:^{
            weakSelf.transform =CGAffineTransformTranslate(weakSelf.transform, 0, -deltaY);
        } completion:^(BOOL finished) {
            if (weakSelf.frame.origin.y>kScreenH-safeTop) {
                [weakSelf removeFromSuperview];
                if (weakSelf.disappear_block) {
                    weakSelf.disappear_block();
                }
                if ([self.delegate conformsToProtocol:@protocol(XDragUpMenuDelegate)]) {
                    [self.delegate  dragUpMenuWillDisappear];
                }
                NSLog(@"[self removeFromSuperview] %@", self);
            }
        }];
    }
    
}


- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event{
     NSLog(@"touchesCancelled");
}

#pragma mark -- UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%s", __func__);
    if ([self.delegate conformsToProtocol:@protocol(XDragUpMenuDelegate)]) {
        [self.delegate  dragUpMenuDidSelectedIndex:indexPath.row];
    }
    if (_clickHandle) {
        [self removeFromSuperview];
        _clickHandle(indexPath.row);
    }
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

@end
