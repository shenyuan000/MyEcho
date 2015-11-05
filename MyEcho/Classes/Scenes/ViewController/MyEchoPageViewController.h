//
//  MyEchoPageViewController.h
//  MyEcho
//
//  Created by iceAndFire on 15/10/27.
//  Copyright © 2015年 free. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RACollectionViewReorderableTripletLayout.h"

@interface MyEchoPageViewController : UIViewController<RACollectionViewDelegateReorderableTripletLayout, RACollectionViewReorderableTripletLayoutDataSource>

@property (nonatomic, copy) NSString *urlString;

@end
