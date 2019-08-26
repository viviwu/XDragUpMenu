//
//  XDragUpMenu.h
//  XDragUpMenu
//
//  Created by vivi wu on 2019/8/23.
//  Copyright © 2019 viviwu. All rights reserved.
//

#ifndef XDragUpMenu_h
#define XDragUpMenu_h

#import <UIKit/UIKit.h>

#define kScreenH    UIScreen.mainScreen.bounds.size.height
#define kScreenW    UIScreen.mainScreen.bounds.size.width

#define switchSkinNotificationName  @"switchSkinNotificationName"

#define kCellReuseIdentifier    @"kCellReuseIdentifier"
//#define DarkBlurStyle   NO
#define TOP    64
#define kCellH      50
#define GAP        5
#define kHeaderH        1

#import "XMenuItem.h"
#import "XMenuItemCell.h"
//#import "XDragUpMenuView.h"

#endif /* XDragUpMenu_h */



typedef void(^XMenuClickHandle)(NSInteger);


@class XDragUpMenuView;
@protocol XDragUpMenuDelegate <NSObject>

- (void)dragUpMenuDidSelectedIndex:(NSInteger)index;
- (void)dragUpMenuWillDisappear;

@end
