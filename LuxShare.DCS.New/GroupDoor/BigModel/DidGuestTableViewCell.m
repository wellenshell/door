//
//  DidGuestTableViewCell.m
//  Luxshare.DCS
//
//  Created by George Tsai on 16/7/15.
//  Copyright © 2016年 DCS. All rights reserved.
//

#import "DidGuestTableViewCell.h"
#import "Header.h"
@implementation DidGuestTableViewCell

- (void)awakeFromNib {
    // Initialization code
}


-(id)initWithCell{
    if (self == [super init]) {
        
        
        
        _labCompanyName = [[UILabel alloc]init];
        _labCompanyName.font = [UIFont systemFontOfSize:[UIFONT fontWithDevice:15]];
        _labCompanyName.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_labCompanyName];
        
        _labCompanyName.sd_layout
        .leftSpaceToView(self,10)
        .topSpaceToView(self,SCREENWIDTH*0.01)
        .rightSpaceToView(self,0)
        .heightIs(30);
        

        
        _labName = [[UILabel alloc]init];
        _labName.font = [UIFont systemFontOfSize:[UIFONT fontWithDevice:15]];
        _labName.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_labName];
        
        _labName.sd_layout
        .leftSpaceToView(self,10)
        .topSpaceToView(_labCompanyName,SCREENWIDTH*0.01)
        .rightSpaceToView(self,0)
        .heightIs(30);

        
        _labItems = [[UILabel alloc]init];
        _labItems.numberOfLines = 0;
        _labItems.font = [UIFont systemFontOfSize:[UIFONT fontWithDevice:15]];
        _labItems.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_labItems];
        _labItems.sd_layout
        .leftSpaceToView(self,10)
        .topSpaceToView(_labName,SCREENWIDTH*0.01)
        .rightSpaceToView(self,0)
        .heightIs(30);

        _labReceptionName = [[UILabel alloc]init];
        _labReceptionName.numberOfLines = 0;
        _labReceptionName.font = [UIFont systemFontOfSize:[UIFONT fontWithDevice:15]];
        _labReceptionName.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_labReceptionName];
        _labReceptionName.sd_layout
        .leftSpaceToView(self,10)
        .topSpaceToView(_labItems,SCREENWIDTH*0.01)
        .widthIs(10)
        .heightIs(30);

        _labTime = [[UILabel alloc]init];
        _labTime.numberOfLines = 0;
        _labTime.font = [UIFont systemFontOfSize:[UIFONT fontWithDevice:15]];
        _labTime.textAlignment = NSTextAlignmentRight;
        [self addSubview:_labTime];
        _labTime.sd_layout
        .rightSpaceToView(self,10)
        .topSpaceToView(_labItems,SCREENWIDTH*0.01)
        .leftSpaceToView(_labReceptionName,1)
        .heightIs(30);

        
    }
    return self;
}

-(CGSize)getString:(NSString*)str{
    CGSize size = [str sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:[UIFONT fontWithDevice:15]],NSFontAttributeName, nil]];
    return size;
}








- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
