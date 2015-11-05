//
//  UIColor+HYRandomColor.m
//  MyEcho
//
//  Created by iceAndFire on 15/10/21.
//  Copyright © 2015年 free. All rights reserved.
//

#import "UIColor+HYRandomColor.h"

@implementation UIColor (HYRandomColor)

+(UIColor*) randomColor{
    CGFloat hue = arc4random() % 256 / 256.0; //色调随机:0.0 ~ 1.0
    CGFloat saturation = (arc4random() % 128 / 256.0) + 0.5; //饱和随机:0.5 ~ 1.0
    CGFloat brightness = (arc4random() % 128 / 256.0) + 0.5; //亮度随机:0.5 ~ 1.0
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
}

@end
