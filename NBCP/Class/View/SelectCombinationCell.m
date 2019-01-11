//
//  SelectCombinationCell.m
//  NBCP
//
//  Created by Michael on 2019/1/11.
//  Copyright © 2019 Michael. All rights reserved.
//

#import "SelectCombinationCell.h"

NSString * const SelectCombinationCellID = @"SelectCombinationCellID";

@interface SelectCombinationCell ()
{
    UIImageView *icon;
    UILabel *title;
    
    UILabel *highest;
    UILabel *minimum;
}
@end

@implementation SelectCombinationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUI];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

-(void)setUI
{
    UIView *fatherView = self.contentView;
    
    icon = [UIImageView new];
    title = [UILabel new];
    UIImageView *rightArrow = [UIImageView new];
    highest = [UILabel new];
    UILabel *label1 = [UILabel new];
    minimum = [UILabel new];
    UILabel *label2 = [UILabel new];
    
    [fatherView sd_addSubviews:@[
                                 icon,
                                 title,
                                 
                                 rightArrow,
                                 
                                 highest,
                                 label1,
                                 minimum,
                                 label2,
                                 
                                 ]];
    
    icon.sd_layout
    .centerYEqualToView(fatherView)
    .leftSpaceToView(fatherView, 28)
    .widthIs(30)
    .heightEqualToWidth()
    ;
    
    title.sd_layout
    .centerYEqualToView(fatherView)
    .leftSpaceToView(icon, 38)
    .heightIs(20)
    ;
    [title setSingleLineAutoResizeWithMaxWidth:100];
    title.font = PFFontL(16);
    
    rightArrow.sd_layout
    .centerYEqualToView(fatherView)
    .rightSpaceToView(fatherView, 19)
    .widthIs(6)
    .heightIs(11)
    ;
    rightArrow.image = UIImageNamed(@"rightArrow");
    
    highest.sd_layout
    .centerYEqualToView(fatherView)
    .rightSpaceToView(rightArrow, 20)
    .widthIs(60)
    .heightIs(20)
    ;
    highest.textAlignment = NSTextAlignmentRight;
    highest.font = PFFontL(12);
    
    label1.sd_layout
    .centerYEqualToView(fatherView)
    .rightSpaceToView(highest, 5)
    .widthIs(40)
    .heightIs(20)
    ;
    label1.textAlignment = NSTextAlignmentCenter;
    label1.font = PFFontL(12);
    label1.textColor = HexColor(#808181);
    label1.text = @"-最高";
    
    minimum.sd_layout
    .centerYEqualToView(fatherView)
    .rightSpaceToView(label1, 5)
    .widthIs(40)
    .heightIs(20)
    ;
    minimum.textAlignment = NSTextAlignmentRight;
    minimum.font = PFFontL(12);
    
    label2.sd_layout
    .centerYEqualToView(fatherView)
    .rightSpaceToView(minimum, 5)
    .widthIs(40)
    .heightIs(20)
    ;
    label2.textAlignment = NSTextAlignmentCenter;
    label2.font = PFFontL(12);
    label2.textColor = HexColor(#808181);
    label2.text = @"最低";
}

-(void)setModel:(NSDictionary *)model
{
    _model = model;
    icon.image = UIImageNamed(model[@"icon"]);
    title.text = model[@"title"];
    minimum.text = model[@"low"];
    highest.text = model[@"high"];
}

@end
