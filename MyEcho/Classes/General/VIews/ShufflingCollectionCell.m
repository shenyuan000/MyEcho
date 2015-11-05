//
//  ShufflingCollectionCell.m
//  MyEcho
//
//  Created by iceAndFire on 15/10/24.
//  Copyright © 2015年 free. All rights reserved.
//

#import "ShufflingCollectionCell.h"

@interface ShufflingCollectionCell ()

@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (nonatomic, strong) NSMutableArray *allUrls;
@property (nonatomic, strong) NSMutableArray *allArrayBanner;
@end

@implementation ShufflingCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self shuffing];
}

-(void)setImgArray:(NSArray *)imgArray
{
    SDCycleScrollView *customScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, self.frame.size.height) imageURLStringsGroup:_allUrls];
    
    customScrollView.autoScrollTimeInterval = 4.0;
    customScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    customScrollView.dotColor = [UIColor whiteColor]; // 自定义分页控件小圆标颜色
    customScrollView.autoScroll = YES;
    customScrollView.infiniteLoop = YES;
    customScrollView.imageURLStringsGroup = imgArray;
    [self.bottomView addSubview:customScrollView];
    self.cycleScrollView = customScrollView;
}




- (void) shuffing
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager GET:[Banner_URL stringByAppendingString:@""] parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        
        NSArray *array = [responseObject valueForKey:@"result"];
        for (id obj in array) {
            Banner *banner = [Banner new];
            [banner setValuesForKeysWithDictionary:obj];
            [self.allArrayBanner addObject:banner];
            [self.allUrls addObject:banner.pic];
            
            SDCycleScrollView *customScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, self.frame.size.height) imageURLStringsGroup:_allUrls];
            
            customScrollView.autoScrollTimeInterval = 4.0;
            customScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
            customScrollView.dotColor = [UIColor whiteColor]; // 自定义分页控件小圆标颜色
            customScrollView.autoScroll = YES;
            customScrollView.infiniteLoop = YES;
            customScrollView.imageURLStringsGroup = _allUrls;
            [self.bottomView addSubview:customScrollView];
            self.cycleScrollView = customScrollView;
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

//lazy
-(NSMutableArray *)allUrls
{
    if (!_allUrls) {
        _allUrls = [NSMutableArray array];
    }
    return _allUrls;
}
-(NSMutableArray *)allArrayBanner
{
    if (!_allArrayBanner) {
        _allArrayBanner = [NSMutableArray array];
    }
    return _allArrayBanner;
}
@end
