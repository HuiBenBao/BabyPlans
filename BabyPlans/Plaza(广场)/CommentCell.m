//
//  CommentCell.m
//  BabyPlans
//
//  Created by apple on 16/4/12.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "CommentCell.h"



@interface CommentCell ()

@property (nonatomic,strong) UIImageView * iconView;
@property (nonatomic,strong) UILabel * nameLbl;
@property (nonatomic,strong) UILabel * dateLbl;
@property (nonatomic,strong) UIButton * voiceBtn;
@property (nonatomic,strong) UILabel * contentLbl;
@property (nonatomic,strong) UIView * divLine;

@property (nonatomic,strong) CommentModel * model;

@end

@implementation CommentCell
+ (instancetype)cellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
    
    static NSString * ident = @"PlazaMainCell";
    CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:ident];
    
    
    if (cell == nil) {
        cell = [[CommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ident];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    
    return cell;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        //头像
        UIImageView * imageView = [[UIImageView alloc] init];
        
        self.iconView = imageView;
        [self addSubview:imageView];
        
        //昵称
        UILabel * nameLbl = [[UILabel alloc] init];
        nameLbl.textColor = ColorI(0x5b5b5b);
        nameLbl.font = FONT_ADAPTED_NUM(kNameFont);
        
        self.nameLbl = nameLbl;
        
        [self addSubview:nameLbl];
        
        //时间
        UILabel * dateLbl = [[UILabel alloc] init];
        dateLbl.font = FONT_ADAPTED_NUM(kDateFont);
        dateLbl.textColor = ColorI(0x8b8b8b);
        
        self.dateLbl = dateLbl;
        [self addSubview:dateLbl];
        
        //内容
        UILabel * contentLbl = [[UILabel alloc] init];
        contentLbl.font = FONT_ADAPTED_NUM(kContentFont);
        contentLbl.textColor = ColorI(0x3b3b3b);
        contentLbl.textAlignment = NSTextAlignmentLeft;
        contentLbl.numberOfLines = 0;
        
        self.contentLbl = contentLbl;
        [self addSubview:contentLbl];
        
        //声音
        UIButton * voiceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        voiceBtn.backgroundColor = [UIColor orangeColor];
        [voiceBtn setTitleColor:ColorI(0x5b5b5b) forState:UIControlStateNormal];
        voiceBtn.titleLabel.font = FONT_ADAPTED_NUM(15);
        [voiceBtn addTarget:self action:@selector(playVoice:) forControlEvents:UIControlEventTouchUpInside];
        
        self.voiceBtn = voiceBtn;
        [self addSubview:voiceBtn];
        
        //分割线
        UIView * lineV = [[UIView alloc] init];
        lineV.backgroundColor = ColorI(0xdddddd);
        self.divLine = lineV;
        
        [self addSubview:lineV];
        
    }
    return self;
}
- (void)playVoice:(UIButton *)button{

    if ([self.delegate respondsToSelector:@selector(playVoiceWithModel:)]) {
        [self.delegate playVoiceWithModel:self.dataFrame.model];
    }
}
- (void)setDataFrame:(CommentFrame *)dataFrame{
    
    _dataFrame = dataFrame;
    self.model = dataFrame.model;
}
- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    self.iconView.frame = self.dataFrame.iconF;
    [_iconView sd_setImageWithURL:[NSURL URLWithString:self.model.user.icon] placeholderImage:[UIImage imageNamed:@"DefaultImage"]];
    _iconView.layer.cornerRadius = _iconView.height/2;
    _iconView.clipsToBounds = YES;
    
    self.nameLbl.frame = self.dataFrame.nameF;
    self.nameLbl.text = (_model.user.nickName) ? _model.user.nickName : _model.user.name;;
    
    self.dateLbl.text = self.model.createTime;
    self.dateLbl.frame = self.dataFrame.dateF;
    
    
    if (self.model.voice) {
        self.contentLbl.hidden = YES;
        self.voiceBtn.hidden = NO;
        self.voiceBtn.frame = self.dataFrame.voiceF;
        [self.voiceBtn setTitle:[NSString stringWithFormat:@"%@ s",self.model.voiceLen] forState:UIControlStateNormal];
        self.voiceBtn.layer.cornerRadius = _dataFrame.voiceF.size.height/2;
        self.voiceBtn.clipsToBounds = YES;
    }else{
        self.voiceBtn.hidden = YES;
        self.contentLbl.hidden = NO;
        self.contentLbl.text = self.model.content;
        self.contentLbl.frame = self.dataFrame.contentF;

    }
    
    
    self.divLine.frame = self.dataFrame.divLineF;
}


@end
