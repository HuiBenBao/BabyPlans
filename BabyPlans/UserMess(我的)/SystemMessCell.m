//
//  SystemMessCell.m
//  BabyPlans
//
//  Created by apple on 16/5/23.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "SystemMessCell.h"

@interface SystemMessCell ()

@property (nonatomic,strong) UIView * divLine;


@end

@implementation SystemMessCell
+ (instancetype)valueWithTableView:(UITableView *)tableView text:(NSString *)text{

    static NSString * identFier = @"SystemMessCell";
    
    SystemMessCell * cell = [tableView dequeueReusableCellWithIdentifier:identFier];
    
    if (!cell) {
        cell = [[SystemMessCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identFier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.textLabel.text = text;
    
    
    return cell;

}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.textLabel.font = CellTextFont;
        self.textLabel.textColor = ColorI(0x3b3b3b);
        self.textLabel.numberOfLines = 0;
        
        _divLine = [[UIView alloc] init];
        _divLine.backgroundColor = ColorI(0xdddddd);
        
        [self.contentView addSubview:_divLine];
    }
    
    return self;
}

- (void)layoutSubviews{

    [super layoutSubviews];
    _divLine.frame = CGRectMake(0, self.frame.size.height-1, self.width, 1);
}
@end
