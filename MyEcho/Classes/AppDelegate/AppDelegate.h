//
//  AppDelegate.h
//  MyEcho
//
//  Created by iceAndFire on 15/10/11.
//  Copyright © 2015年 free. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MMDrawerController;
@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    @private
    MMDrawerController *drawerController;
}
@property (strong, nonatomic) UIWindow *window;


@end 

