//
//  ChannelEchoCell.m
//  MyEcho
//
//  Created by iceAndFire on 15/10/21.
//  Copyright © 2015年 free. All rights reserved.
//

#import "ChannelEchoCell.h"

@interface ChannelEchoCell ()

@end

@implementation ChannelEchoCell

-(void)awakeFromNib{
    [super awakeFromNib];
    
    //设置图片尺寸
    self.cellImageView.contentMode = UIViewContentModeScaleAspectFill;
}


@end
