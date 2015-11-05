//
//  User.m
//  MyEcho
//
//  Created by iceAndFire on 15/10/17.
//  Copyright © 2015年 free. All rights reserved.
//

#import "User.h"

@implementation User

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"] == YES) {
        self.ID = value;
    }
}

@end
