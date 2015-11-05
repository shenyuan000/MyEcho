//
//  Banner.m
//  MyEcho
//
//  Created by iceAndFire on 15/10/26.
//  Copyright © 2015年 free. All rights reserved.
//

#import "Banner.h"

@implementation Banner

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        self.ID = value;
    }
}

@end
