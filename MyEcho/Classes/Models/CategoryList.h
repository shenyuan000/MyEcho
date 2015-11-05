//
//  CategoryList.h
//  MyEcho
//
//  Created by iceAndFire on 15/10/22.
//  Copyright © 2015年 free. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CategoryList : NSObject

@property (nonatomic, strong) NSString *fid;
@property (nonatomic, strong) NSString *ico_url;
@property (nonatomic, strong) NSString *updated_at;
@property (nonatomic, strong) NSMutableArray *children;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *en_name;
@property (nonatomic, strong) NSString *created_at;
@property (nonatomic, strong) NSString *ID;//id

@end
