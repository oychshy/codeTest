//
//  MainPageTableViewCell.m
//  DSComic
//
//  Created by xhkj on 2021/9/22.
//  Copyright © 2021 oych. All rights reserved.
//
#define itemViewTag 3000
#import "MainPageTableViewCell.h"

@interface MainPageTableViewCell (){
    UILabel *titleLabel;
    UIButton *RightButton;
    MainPageItem *getModel;
    NSInteger rowIndex;
}
@end

@implementation MainPageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self configUI];
    }
    return self;
}

-(void)configUI{
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(YWIDTH_SCALE(20), 0, FUll_VIEW_WIDTH, YWIDTH_SCALE(80))];
    [self addSubview:titleLabel];
    
    RightButton = [[UIButton alloc] initWithFrame:CGRectMake(FUll_VIEW_WIDTH-YWIDTH_SCALE(60), YHEIGHT_SCALE(20), YWIDTH_SCALE(40), YWIDTH_SCALE(40))];
    [RightButton addTarget:self action:@selector(RightButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [RightButton setHidden:YES];
    [self addSubview:RightButton];
}

-(void)setCellWithModel:(MainPageItem*)model Row:(NSInteger)row{
    
//    NSLog(@"OY===category_id:%ld,title:%@",model.category_id,model.title);

    rowIndex = row;
    getModel = model;
    [titleLabel setText:model.title];
    
    if (model.category_id==49||model.category_id==49) {
        [RightButton setHidden:NO];
        [RightButton setImage:[UIImage imageNamed:@"right_arrow"] forState:UIControlStateNormal];
    }else if (model.category_id==50||model.category_id== 52||model.category_id == 54) {
        [RightButton setHidden:NO];
        [RightButton setImage:[UIImage imageNamed:@"refresh"] forState:UIControlStateNormal];
    }else{
        [RightButton setHidden:YES];
    }
    
    NSArray *getDatainfos = [[NSArray alloc] initWithArray:model.data];
    CGFloat CellHeight = 0;
    
    if (getDatainfos.count%3!=0) {
        CGFloat SetHeight = YHEIGHT_SCALE(100);
        for (int i=0; i<getDatainfos.count; i++) {
            NSDictionary *getDic = getDatainfos[i];
            
            NSInteger row = i/2;
            NSInteger col = i%2;
            
            CGFloat SetWidth = (FUll_VIEW_WIDTH-YWIDTH_SCALE(100))/2;

            UIView *ItemView = [[UIView alloc] initWithFrame:CGRectMake(YWIDTH_SCALE(20)+col*(SetWidth+YWIDTH_SCALE(60)), titleLabel.height+row*(SetHeight+YHEIGHT_SCALE(40)), SetWidth, SetHeight)];
            ItemView.tag = itemViewTag+i;
            ItemView.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(itemViewAction:)];
            [ItemView addGestureRecognizer:tap];
            [self addSubview:ItemView];
            
            UIImageView *coverImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ItemView.width, YHEIGHT_SCALE(160))];
            coverImageView.contentMode = UIViewContentModeScaleAspectFill;
            coverImageView.cornerRadius = 10;
            coverImageView.clipsToBounds = YES;
            [coverImageView setBackgroundColor:[UIColor colorWithHexString:@"F6F6F6"]];
            [coverImageView sd_setImageWithURL:[NSURL URLWithString:getDic[@"cover"]] placeholderImage:nil];
            [ItemView addSubview:coverImageView];
            
            UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, coverImageView.y+coverImageView.height+YHEIGHT_SCALE(10), coverImageView.width, YHEIGHT_SCALE(40))];
            nameLabel.textAlignment = NSTextAlignmentLeft;
            [nameLabel setFont:[UIFont systemFontOfSize:YFONTSIZEFROM_PX(28)]];
            [nameLabel setText:getDic[@"title"]];
            [ItemView addSubview:nameLabel];
            
            ItemView.height = nameLabel.y+nameLabel.height;
            SetHeight = ItemView.height;
            
            CellHeight = ItemView.y+ItemView.height+YHEIGHT_SCALE(20);
        }
    }else{
        CGFloat SetHeight = YHEIGHT_SCALE(100);
        for (int i=0; i<getDatainfos.count; i++) {
            NSDictionary *getDic = getDatainfos[i];
            
            NSInteger row = i/3;
            NSInteger col = i%3;
            
            CGFloat SetWidth = (FUll_VIEW_WIDTH-YWIDTH_SCALE(120))/3;
            
            UIView *ItemView = [[UIView alloc] initWithFrame:CGRectMake(YWIDTH_SCALE(20)+col*(SetWidth+YWIDTH_SCALE(40)), titleLabel.height+row*(SetHeight+YHEIGHT_SCALE(40)), SetWidth, SetHeight)];
            ItemView.tag = itemViewTag+i;
            ItemView.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(itemViewAction:)];
            [ItemView addGestureRecognizer:tap];
            [self addSubview:ItemView];
            
            UIImageView *coverImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ItemView.width, YHEIGHT_SCALE(240))];
            coverImageView.contentMode = UIViewContentModeScaleAspectFill;
            coverImageView.cornerRadius = 10;
            coverImageView.clipsToBounds = YES;
            [coverImageView setBackgroundColor:[UIColor colorWithHexString:@"F6F6F6"]];
            [coverImageView sd_setImageWithURL:[NSURL URLWithString:getDic[@"cover"]] placeholderImage:nil];
            [ItemView addSubview:coverImageView];
            
            UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, coverImageView.y+coverImageView.height+YHEIGHT_SCALE(10), coverImageView.width, YHEIGHT_SCALE(40))];
            nameLabel.textAlignment = NSTextAlignmentLeft;
            [nameLabel setFont:[UIFont systemFontOfSize:YFONTSIZEFROM_PX(28)]];
            [nameLabel setText:getDic[@"title"]];
            [ItemView addSubview:nameLabel];
            
            NSString *sub_title = getDic[@"sub_title"];
            if (sub_title) {
                UILabel *subNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, nameLabel.y+nameLabel.height, nameLabel.width, YHEIGHT_SCALE(40))];
                subNameLabel.textAlignment = NSTextAlignmentLeft;
                [subNameLabel setFont:[UIFont systemFontOfSize:YFONTSIZEFROM_PX(24)]];
                [subNameLabel setTextColor:[UIColor lightGrayColor]];
                [subNameLabel setText:getDic[@"sub_title"]];
                [ItemView addSubview:subNameLabel];
                ItemView.height = subNameLabel.y+subNameLabel.height;
            }else{
                ItemView.height = nameLabel.y+nameLabel.height;
            }
            SetHeight = ItemView.height;
            
            CellHeight = ItemView.y+ItemView.height+YHEIGHT_SCALE(20);
        }
    }
    
    if (self.delegate&&[self.delegate respondsToSelector:@selector(postCellHeight:)]) {
        [self.delegate postCellHeight:CellHeight];
    }
    
}

-(void)RightButtonAction{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(postCategoryID:Row:)]) {
        [self.delegate postCategoryID:getModel.category_id Row:rowIndex];
    }
}

-(void)itemViewAction:(UITapGestureRecognizer *)tap{
    NSInteger index = tap.view.tag - itemViewTag;
    if (self.delegate&&[self.delegate respondsToSelector:@selector(SelectItem:index:)]) {
        [self.delegate SelectItem:getModel index:index];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
