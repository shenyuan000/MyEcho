//
//  EchoViewController.h
//  MyEcho
//
//  Created by iceAndFire on 15/10/16.
//  Copyright © 2015年 free. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EchoViewController : UIViewController


//保存点击下标
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) BOOL isLocal;
#pragma mark - 单例方法
+ (instancetype) shareEchoViewController;

//播放音乐
- (void) prepareForPlaying;

//下一曲
- (void) nextMusic;

//上一曲
- (void) PreviousMusic;
//播放
- (void)playMusic;
//暂停
- (void)pauseMusic;

-(void)configNowPlayingInfoCenter;
@end
