//
//  FileService.h
//  MyEcho
//
//  Created by iceAndFire on 15/11/1.
//  Copyright © 2015年 free. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileService : NSObject
+(float)fileSizeAtPath:(NSString *)path;

+(float)folderSizeAtPath:(NSString *)path;

+(void)clearCache:(NSString *)path;



@end


