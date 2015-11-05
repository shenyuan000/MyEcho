//
//  AppDelegate.m
//  MyEcho
//
//  Created by iceAndFire on 15/10/11.
//  Copyright © 2015年 free. All rights reserved.
//

#import "AppDelegate.h"
#import <AVFoundation/AVFoundation.h>
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //防止锁屏
//    [[UIApplication sharedApplication]setIdleTimerDisabled:YES];
    //抽屉
    [self initDrawer];
    return YES;
}

- (void)initDrawer {
    UIStoryboard* mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    
    drawerController = [[MMDrawerController alloc] initWithCenterViewController:[mainStoryboard instantiateViewControllerWithIdentifier:@"首页"] leftDrawerViewController:[mainStoryboard instantiateViewControllerWithIdentifier:@"左视图"] rightDrawerViewController:[mainStoryboard instantiateViewControllerWithIdentifier:@"右视图"]];
    
    
    [drawerController setDrawerVisualStateBlock:[MMDrawerVisualState swingingDoorVisualStateBlock]];
    [drawerController setMaximumLeftDrawerWidth:[UIScreen mainScreen].bounds.size.width*5/6];
    [drawerController setMaximumRightDrawerWidth:[UIScreen mainScreen].bounds.size.width*5/6];
    [drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    
    
    self.window.rootViewController = drawerController;
}

- (void)applicationWillResignActive:(UIApplication *)application {
}

- (void)applicationDidEnterBackground:(UIApplication *)application {

    //开始接受远程事件
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];
    
    //显示图片
    if ([PlayerHelper sharePlayerHelper].isPlay) {
        [[EchoViewController shareEchoViewController] configNowPlayingInfoCenter];
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    
    
    //结束接受远程事件
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    [self resignFirstResponder];

}

- (void)applicationWillTerminate:(UIApplication *)application {
}




//重写父类方法 处理点击事件
- (void)remoteControlReceivedWithEvent:(UIEvent *)event
{
    if (event.type == UIEventTypeRemoteControl) {
        
        switch (event.subtype) {
            case UIEventSubtypeRemoteControlStop:{
                NSLog(@"停止事件");
            }
                break;
            case UIEventSubtypeRemoteControlTogglePlayPause:{
                //线控播放
                NSLog(@"UIEventSubtypeRemoteControlTogglePlayPause");
                if ([PlayerHelper sharePlayerHelper].isPlay) {
                    [[EchoViewController shareEchoViewController] pauseMusic];
                }else{
                    [[EchoViewController shareEchoViewController] playMusic];
                }
            }
                break;
                
            case UIEventSubtypeRemoteControlPreviousTrack:{
                //上一曲 以及耳机点击三次
                NSLog(@"上一曲");
                [[EchoViewController shareEchoViewController] PreviousMusic];
            }
                break;
                
            case UIEventSubtypeRemoteControlNextTrack:{
                //下一曲 以及耳机点击二次
                NSLog(@"下一曲");
                [[EchoViewController shareEchoViewController] nextMusic];
            }
                break;
                
            case UIEventSubtypeRemoteControlPlay:{
                NSLog(@"UIEventSubtypeRemoteControlPlay");
                [[EchoViewController shareEchoViewController] playMusic];
            }
                break;
                
            case UIEventSubtypeRemoteControlPause:{
                //后台暂停
                NSLog(@"UIEventSubtypeRemoteControlPause");
                [[EchoViewController shareEchoViewController] pauseMusic];
            }
                break;
            case UIEventSubtypeRemoteControlBeginSeekingBackward:{
                NSLog(@"快退开始");
            }
            break;
            case UIEventSubtypeRemoteControlEndSeekingBackward:{
                NSLog(@"快退结束");
            }
                break;
            case UIEventSubtypeRemoteControlBeginSeekingForward:{
                NSLog(@"快进开始");
            }
                break;
            case UIEventSubtypeRemoteControlEndSeekingForward:{
                NSLog(@"快进结束");
            }
                break;
                
            default:
                break;
        }
    }
}
@end
