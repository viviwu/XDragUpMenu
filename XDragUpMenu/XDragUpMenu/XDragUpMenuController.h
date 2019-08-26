//
//  XDragUpMenuController.h
//  XDragUpMenu
//
//  Created by vivi wu on 2019/8/23.
//  Copyright © 2019 viviwu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XDragUpMenu.h"

NS_ASSUME_NONNULL_BEGIN

@interface XDragUpMenuController : UIViewController

@property(nonatomic, strong) UITableView * tableView;

@property(nonatomic, strong) NSArray<XMenuItem *>* menuItems;

@property(nonatomic, copy) XMenuClickHandle clickHandle;
@property(nonatomic, copy) dispatch_block_t disappear_block;

@property(nonatomic, weak) id<XDragUpMenuDelegate> delegate;


- (instancetype)initWithMenuItems:(NSArray<XMenuItem *>*)menuItems;
 

@end

NS_ASSUME_NONNULL_END
