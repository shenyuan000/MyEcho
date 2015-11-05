//
//  Sound.h
//  MyEcho
//
//  Created by iceAndFire on 15/10/17.
//  Copyright © 2015年 free. All rights reserved.
//

#import <Foundation/Foundation.h>
@class User;
@class Channel;

@interface Sound : NSObject

@property (nonatomic, strong) User *user;
@property (nonatomic, strong) Channel *channel;


@property (nonatomic, copy) NSString *comment_count;// 评论次数
@property (nonatomic, copy) NSString *is_liquefying;//
@property (nonatomic, copy) NSString *exchange_count;// 与下边的共享次数一样
@property (nonatomic, copy) NSString *crosstalk_id;//
@property (nonatomic, copy) NSString *pic;//
@property (nonatomic, copy) NSString *source;//
@property (nonatomic, copy) NSString *source2;//
@property (nonatomic, copy) NSString *type;//
@property (nonatomic, copy) NSString *h5_clickbtn_count;//
@property (nonatomic, copy) NSString *is_like;//
@property (nonatomic, copy) NSString *is_hot;//
@property (nonatomic, copy) NSString *list_order;//
@property (nonatomic, copy) NSString *ID;//id
@property (nonatomic, copy) NSString *tag;//
@property (nonatomic, copy) NSString *info;//音乐内容
@property (nonatomic, copy) NSString *commend_time;//评论时间
@property (nonatomic, copy) NSString *like_count;// 喜欢次数
@property (nonatomic, copy) NSString *ad;//
@property (nonatomic, copy) NSString *create_time;//
@property (nonatomic, copy) NSString *check_visition;//
@property (nonatomic, copy) NSString *web_source;//
@property (nonatomic, copy) NSString *desp;//
@property (nonatomic, copy) NSString *ad_id;//
@property (nonatomic, copy) NSString *user_id;//
@property (nonatomic, copy) NSString *name;//标题
@property (nonatomic, copy) NSString *pic_100;//
@property (nonatomic, copy) NSString *channel_id;//
@property (nonatomic, copy) NSString *status;//
@property (nonatomic, copy) NSString *pic_500;//
@property (nonatomic, copy) NSString *status_mask;//
@property (nonatomic, copy) NSString *hot_time;//
@property (nonatomic, copy) NSString *update_time;//
@property (nonatomic, copy) NSString *update_user_id;//
@property (nonatomic, assign) NSInteger is_xm;//
@property (nonatomic, copy) NSString *pic_750;//
@property (nonatomic, copy) NSString *hls_status;//
@property (nonatomic, copy) NSString *hls_key;//
@property (nonatomic, copy) NSString *pic_1080;//
@property (nonatomic, copy) NSString *original;//
@property (nonatomic, copy) NSString *length;//
@property (nonatomic, copy) NSString *hot_status;//
@property (nonatomic, copy) NSString *check_status;//
@property (nonatomic, copy) NSString *download_count;// 下载次数
@property (nonatomic, copy) NSString *share_count;// 共享次数
@property (nonatomic, copy) NSString *backup_id;//
@property (nonatomic, copy) NSString *relay_count;//
@property (nonatomic, copy) NSString *pic_200;//
@property (nonatomic, copy) NSString *pic_640;//
@property (nonatomic, copy) NSString *view_count;//
@property (nonatomic, copy) NSString *download_level;//
@end


