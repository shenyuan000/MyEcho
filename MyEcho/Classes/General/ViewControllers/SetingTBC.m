//
//  SetingTBC.m
//  MyEcho
//
//  Created by iceAndFire on 15/11/1.
//  Copyright © 2015年 free. All rights reserved.
//

#import "SetingTBC.h"
#import "FileService.h"


@interface SetingTBC ()

@end

@implementation SetingTBC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
    
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"setingCell"];
    self.tableView.tableFooterView = [[UIView alloc] init];
}

- (void)cancel:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"setingCell" forIndexPath:indexPath];
    
//    cell.backgroundColor = [UIColor randomColor];
    
    
    
    switch (indexPath.row) {
        case 0:
        {
            cell.textLabel.text = @"V 1.0";
            cell.textLabel.textColor = [UIColor grayColor];
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
        }
            break;
            
        default:
        {
            NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
            NSLog(@"%@",cachePath);
            cell.textLabel.text = [NSString stringWithFormat:@"%@  %lu 个文件 %luM", @"清理缓冲", [[SDImageCache sharedImageCache] getDiskCount], (unsigned long)[[SDImageCache sharedImageCache] getSize]/(1024*1024)];
            
            
        }
            break;
    }
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 300;
    }
    return 80;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 1:
        {
            [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
                NSLog(@"清理完成");
                [self.tableView reloadData];
            }];
//            [tableView deselectRowAtIndexPath:indexPath animated:YES];
        }
            break;
            
        default:
            break;
    }
}
@end
