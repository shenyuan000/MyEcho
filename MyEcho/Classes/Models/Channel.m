//
//  Channel.m
//  MyEcho
//
//  Created by iceAndFire on 15/10/11.
//  Copyright © 2015年 free. All rights reserved.
//

#import "Channel.h"

@implementation Channel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        self.ID = value;
    }
}

@end
