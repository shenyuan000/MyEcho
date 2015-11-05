//
//  MyEchoCollectionCell.m
//  MyEcho
//
//  Created by iceAndFire on 15/10/26.
//  Copyright © 2015年 free. All rights reserved.
//

#import "MyEchoCollectionCell.h"

@implementation MyEchoCollectionCell

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return self;
}

- (void)setBounds:(CGRect)bounds
{
    [super setBounds:bounds];
    self.imageView.frame = bounds;
}

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    if (highlighted) {
        _imageView.alpha = .7f;
    }else {
        _imageView.alpha = 1.f;
    }
}

@end
