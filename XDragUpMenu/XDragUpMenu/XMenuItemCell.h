//
//  XMenuItemCell.h
//  XDragUpMenu
//
//  Created by vivi wu on 2019/8/23.
//  Copyright © 2019 viviwu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMenuItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface XMenuItemCell : UITableViewCell

- (void)refreshWithData:(XMenuItem *)menuItem;

@end

NS_ASSUME_NONNULL_END
