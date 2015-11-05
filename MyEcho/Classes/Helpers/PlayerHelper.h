//
//  PlayerHelper.h
//  HYMusic
//
//  Created by iceAndFire on 15/10/12.
//  Copyright © 2015年 lanou. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PlayerHelperDelegate;
@protocol PlayerHelperDelegate <NSObject>

- (void) playingWithTime:(NSTimeInterval)time;//给外界提供当前播放时间 do something
- (void) didStop;//告知外界播放结束 do something

@end


@interface PlayerHelper : NSObject

@property (nonatomic, assign) BOOL isPlay;//判断是否播放音乐
@property (nonatomic, assign) float soundValue;//音量
@property (nonatomic, assign) id<PlayerHelperDelegate> delegate;
#pragma mark - 创建单例方法
+ (instancetype) sharePlayerHelper;

//希望给其一个url 其就可以播放，这属于播放网络音乐 名字怎么起呢？
- (void)playInternetMusicWithURL:(NSString *)url;

//封装 play pause
- (void) play;
- (void) pause;

//播放指定时间
- (void) seekToTime:(double)time;

@end
