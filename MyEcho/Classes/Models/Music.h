//
//  Music.h
//  MyEcho
//
//  Created by iceAndFire on 15/10/11.
//  Copyright © 2015年 free. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Music : NSObject

@property (nonatomic, copy) NSString *channel_id;
@property (nonatomic, copy) NSString *commend_time;
@property (nonatomic, copy) NSString *comment_count;
@property (nonatomic, copy) NSString *ID;//id
@property (nonatomic, copy) NSString *is_hot;
@property (nonatomic, copy) NSString *length;
@property (nonatomic, copy) NSString *like_count;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *pic;
@property (nonatomic, copy) NSString *pic_100;
@property (nonatomic, copy) NSString *pic_1080;
@property (nonatomic, copy) NSString *pic_200;
@property (nonatomic, copy) NSString *pic_500;
@property (nonatomic, copy) NSString *pic_640;
@property (nonatomic, copy) NSString *pic_750;
@property (nonatomic, copy) NSString *share_count;
@property (nonatomic, copy) NSString *source;//音频地址
@property (nonatomic, copy) NSString *status_mask;


//@property (nonatomic, copy) NSString *status_mask_array;
//@property (nonatomic, copy) NSString *user;
@property (nonatomic, copy) NSString *user_id;

@end
