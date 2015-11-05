//
//  ProgressBar.h
//  MyEcho
//
//  Created by iceAndFire on 15/10/18.
//  Copyright © 2015年 free. All rights reserved.
//

//用来触发点击进度条 播放指定位置的歌曲

#import <UIKit/UIKit.h>
#define Block
typedef void (^Result) ();

@interface ProgressBar : UIView

//block 属性
@property (nonatomic,strong) Result result;

//x 坐标
@property (nonatomic, assign) double xpoint;


@end
