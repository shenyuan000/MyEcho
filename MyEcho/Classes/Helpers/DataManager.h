//
//  DataManager.h
//  MyEcho
//
//  Created by iceAndFire on 15/10/11.
//  Copyright © 2015年 free. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface DataManager : NSObject
/**
 *dataManager 用来存放公共的数据，数据请求只在各自的页面操作
 *dataManager 不做任何请求数据操作 他的数据 来自外界，作为公共数据
 */
#pragma mark - 声明属性
//供给外界的数据
@property (nonatomic, strong) NSArray *allData;
//全局参数
@property (nonatomic, copy) NSString *urlTypeString;
//全局存储数据
@property (nonatomic, strong) NSMutableArray *arrayData;
@property (nonatomic, strong) NSMutableArray *bannerArray;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, strong) NSMutableArray *localURLArray;

#pragma mark - 单例方法
+ (instancetype) shareDataManager;
//清空数据
- (void) removeAllData;

@end
