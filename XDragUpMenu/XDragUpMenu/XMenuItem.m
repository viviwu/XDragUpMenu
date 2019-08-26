//
//  XMenuItem.m
//  XDragUpMenu
//
//  Created by vivi wu on 2019/8/23.
//  Copyright © 2019 viviwu. All rights reserved.
//

#import "XMenuItem.h"

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

#pragma mark -- XMenuItem

@implementation XMenuItem

- (instancetype)initWithTitle:(NSString *)menuTitle
                    iconeName:(NSString *)iconeName
{
    self = [super init];
    if (self) {
        _menuTitle = menuTitle;
        _iconName = iconeName;
    }
    return self;
}

+ (instancetype)menuItemWithTitle:(NSString *)menuTitle
                        iconeName:(NSString *)iconeName
{
    return [[XMenuItem alloc]initWithTitle:menuTitle iconeName:iconeName];
}

@end
