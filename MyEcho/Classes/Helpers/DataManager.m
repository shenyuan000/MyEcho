//
//  DataManager.m
//  MyEcho
//
//  Created by iceAndFire on 15/10/11.
//  Copyright © 2015年 free. All rights reserved.
//

#import "DataManager.h"

@interface DataManager ()

//存储channel 列表

@end

@implementation DataManager

//单例方法
+ (instancetype) shareDataManager
{
    static DataManager *dataManager = nil;
    static long once;
    dispatch_once(&once, ^{
        dataManager = [DataManager new];
    });
    return dataManager;
}
//重写init方法 初始化数据
- (instancetype)init
{
    self = [super init];
    self.urlTypeString = HomePage_URL;
//    [self initBanner];
    return self;
}
//初始化banner
- (void) initBanner
{
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:Banner_URL]];
    NSArray *array = [[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil] valueForKey:@"result"];
    for (id obj in array) {
        Banner *banner = [Banner new];
        [banner setValuesForKeysWithDictionary:obj];
        [self.bannerArray addObject:banner.pic];
    }
}

//清空数据
- (void) removeAllData
{
    self.arrayData = nil;
}
//重写getter方法返回外界数据
- (NSArray *)allData
{
    return [self.arrayData copy];
}
#pragma mark -- 懒加载
- (NSMutableArray *)arrayData
{
    if (!_arrayData) {
        _arrayData = [NSMutableArray array];
    }
    return _arrayData;
}
- (NSMutableArray *)bannerArray
{
    if (!_bannerArray) {
        _bannerArray = [NSMutableArray array];
    }
    return _bannerArray;
}
- (NSMutableArray *)localURLArray
{
    if (!_localURLArray) {
        _localURLArray = [NSMutableArray array];
    }
    return _localURLArray;
}
@end


