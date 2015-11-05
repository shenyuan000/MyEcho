//
//  ProgressBar.m
//  MyEcho
//
//  Created by iceAndFire on 15/10/18.
//  Copyright © 2015年 free. All rights reserved.
//

#import "ProgressBar.h"

@implementation ProgressBar

//返回当前 x 坐标


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if ([PlayerHelper sharePlayerHelper].isPlay == NO) {
        return;
    }
    UITouch *touch = [touches anyObject];
    CGPoint currentPoint = [touch locationInView:self.window];
    
    self.xpoint = currentPoint.x;
    
    // 这里可以用 block 来实现回调执行方法
    self.result();
    
    NSLog(@"%lf",self.xpoint);

}

@end
