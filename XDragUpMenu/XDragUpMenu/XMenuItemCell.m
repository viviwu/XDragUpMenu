//
//  XMenuItemCell.m
//  XDragUpMenu
//
//  Created by vivi wu on 2019/8/23.
//  Copyright © 2019 viviwu. All rights reserved.
//

#import "XMenuItemCell.h"
 

@implementation XMenuItemCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = UIColor.clearColor;
        self.contentView.backgroundColor = UIColor.clearColor;
        self.textLabel.backgroundColor = UIColor.clearColor;
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)refreshWithData:(XMenuItem *)menuItem
{
    self.imageView.image = [UIImage imageNamed:menuItem.iconName];
    self.textLabel.text = menuItem.menuTitle;
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end


