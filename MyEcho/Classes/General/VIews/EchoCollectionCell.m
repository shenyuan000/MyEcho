//
//  EchoCollectionCell.m
//  MyEcho
//
//  Created by iceAndFire on 15/10/26.
//  Copyright © 2015年 free. All rights reserved.
//

#import "EchoCollectionCell.h"

@implementation EchoCollectionCell

-(void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)setMusic:(Music *)music
{
    [self.songImageView sd_setImageWithURL:[NSURL URLWithString:music.pic_200]];
    
    self.nameLabel.text = music.name;
}

@end
