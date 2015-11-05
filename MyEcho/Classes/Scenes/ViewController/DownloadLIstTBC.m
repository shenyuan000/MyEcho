//
//  DownloadLIstTBC.m
//  MyEcho
//
//  Created by iceAndFire on 15/10/30.
//  Copyright © 2015年 free. All rights reserved.
//

#import "DownloadLIstTBC.h"

@interface DownloadLIstTBC ()
{
    NSInteger _currentCount;
}

@property (nonatomic, strong) NSMutableArray *musicNameArray;




@end

@implementation DownloadLIstTBC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"tableViewCell"];
    
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    self.musicNameArray = nil;
    [DataManager shareDataManager].localURLArray = nil;
    //douctments 路径
    NSString *documentPath  = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    //需要创建文件管理器的实例
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //枚举目录
    NSDirectoryEnumerator *dirEnum = [fileManager enumeratorAtPath:[documentPath stringByAppendingString:@"/MusicData"]];
    NSString *path;
    NSString *filePath;
    while ((path = [dirEnum nextObject]) != nil)
    {
        //防止读取隐藏文件
        if ([[path substringToIndex:1] isEqualToString:@"."] == NO) {
            
            if ([[path substringFromIndex:path.length-3] isEqualToString:@"txt"] == YES) {
                
                filePath = [NSString stringWithFormat:@"%@/MusicData/%@", documentPath,path];
                NSDictionary *resultDict = [NSDictionary dictionaryWithContentsOfFile:filePath];
                Sound *sound = [Sound objectWithKeyValues:resultDict];
                
                sound.source = [documentPath stringByAppendingFormat:@"/MusicData/%@.mp3",sound.name];
                sound.pic_640 = [documentPath stringByAppendingFormat:@"/MusicData/%@.jpg",sound.name];
                
                [[DataManager shareDataManager].localURLArray addObject:sound];
            }
        }
    }
    [self.tableView reloadData];
}
#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [DataManager shareDataManager].localURLArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"tableViewCell" forIndexPath:indexPath];
    
    Sound *sound = [DataManager shareDataManager].localURLArray[indexPath.row];
    cell.textLabel.text = sound.name;
    
    return cell;
}

//点击事件
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    [EchoViewController shareEchoViewController].isLocal = YES;
    [EchoViewController shareEchoViewController].index = indexPath.row;
    
    //获取控制器
    [self.mm_drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
        
        self.mm_drawerController.centerViewController = [EchoViewController shareEchoViewController];
        [[EchoViewController shareEchoViewController] viewWillAppear:YES];
        
    }];
}




- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        
        
        NSString *name = [[DataManager shareDataManager].localURLArray[indexPath.row] name];
        NSLog(@"%@",name);
        
        //同步缓冲数据
        [[DataManager shareDataManager].localURLArray removeObjectAtIndex:indexPath.row];
        //同步本地数据
        
        
        
        
        //douctments 路径
        NSString *documentPath  = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        //需要创建文件管理器的实例
        NSFileManager *fileManager = [NSFileManager defaultManager];
        //枚举目录
        NSDirectoryEnumerator *dirEnum = [fileManager enumeratorAtPath:[documentPath stringByAppendingString:@"/MusicData"]];
        NSString *path;
        while ((path = [dirEnum nextObject]) != nil)
        {
            if ([[path substringWithRange:NSMakeRange(0, path.length-4)] isEqualToString:name] == YES) {
                NSLog(@"%@",path);
                
                [fileManager removeItemAtPath:[NSString stringWithFormat:@"%@/MusicData/%@",documentPath,path] error:nil];
            }
        }
        
        //同步画面
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}

#pragma mark - lazy
- (NSMutableArray *)musicNameArray
{
    if (!_musicNameArray) {
        _musicNameArray = [NSMutableArray array];
    }
    return _musicNameArray;
}
@end
