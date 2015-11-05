//
//  Comments.h
//  MyEcho
//
//  Created by iceAndFire on 15/10/22.
//  Copyright © 2015年 free. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Comments : NSObject
//http://echosystem.kibey.com/bullet/get?type=1&rand=1&page=1&limit=5&sound_id=897172 这个链接是请求5个评论的地址

@property (nonatomic, strong) User *user;

@property (nonatomic, copy) NSString *create_time;//
@property (nonatomic, copy) NSString *like;//
@property (nonatomic, copy) NSString *end_time;//
@property (nonatomic, copy) NSString *source;//
@property (nonatomic, copy) NSString *type;//
@property (nonatomic, copy) NSString *content;//
@property (nonatomic, copy) NSString *start_time;//
@property (nonatomic, copy) NSString *backup_id;//
@property (nonatomic, copy) NSString *original_content;//
@property (nonatomic, copy) NSString *sound_id;//
@property (nonatomic, copy) NSString *user_id;//
@property (nonatomic, copy) NSString *is_like;//
@property (nonatomic, copy) NSString *ID;//id
@property (nonatomic, copy) NSString *status;//


@end
