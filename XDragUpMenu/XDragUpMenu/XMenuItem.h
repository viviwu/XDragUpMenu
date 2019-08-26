//
//  XMenuItem.h
//  XDragUpMenu
//
//  Created by vivi wu on 2019/8/23.
//  Copyright © 2019 viviwu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface XMenuItem : NSObject

@property(nonatomic, copy) NSString * menuTitle;
@property(nonatomic, copy) NSString * iconName;
@property(nonatomic, assign) int type;

- (instancetype)initWithTitle:(NSString *)menuTitle
                    iconeName:(NSString *)iconeName;

+ (instancetype)menuItemWithTitle:(NSString *)menuTitle
                        iconeName:(NSString *)iconeName;

@end

NS_ASSUME_NONNULL_END
