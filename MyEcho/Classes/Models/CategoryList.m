//
//  CategoryList.m
//  MyEcho
//
//  Created by iceAndFire on 15/10/22.
//  Copyright © 2015年 free. All rights reserved.
//

#import "CategoryList.h"

@implementation CategoryList

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        self.ID = value;
    }
}


@end
