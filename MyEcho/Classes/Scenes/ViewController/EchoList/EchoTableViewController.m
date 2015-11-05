//
//  EchoTableViewController.m
//  MyEcho
//
//  Created by iceAndFire on 15/10/11.
//  Copyright © 2015年 free. All rights reserved.
//

#import "EchoTableViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface EchoTableViewController ()

@property (nonatomic, strong) AVAudioPlayer *player;

//property Item
@property (weak, nonatomic) IBOutlet UIBarButtonItem *rightItem;
- (IBAction)rightItem:(UIBarButtonItem *)sender;
- (IBAction)switchAction:(UIButton *)sender;

@end

@implementation EchoTableViewController

+ (instancetype) shareEchoTableViewController
{
    static EchoTableViewController *echoVC = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        echoVC = [EchoTableViewController new];
    });
    return echoVC;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"ReferralsCell" bundle:nil] forCellReuseIdentifier:@"ReferralsCell"];
    //自适应
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 100;
    
    [self setupLeftMenuButton];
    [self refresh];
}
//  添加导航栏左侧的按钮，点击后显示左侧menu
-(void)setupLeftMenuButton{
    MMDrawerBarButtonItem * leftDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(leftDrawerButtonPress:)];
    [self.navigationItem setLeftBarButtonItem:leftDrawerButton animated:YES];
}
-(void)leftDrawerButtonPress:(id)sender{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}
//请求数据
- (void) requestDataWithUrlString:(NSString *)string
{
    [DataManager shareDataManager].currentIndex ++;
    NSString *url = nil;
    if ([string isEqualToString:HomePage_URL]) {
        url = [string stringByAppendingFormat:@"%ld",[DataManager shareDataManager].currentIndex];
    }
    else{
        url = [string stringByAppendingFormat:@"%ld&limit=20",[DataManager shareDataManager].currentIndex];
    }
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        //这里解析方式不同！！要统一需要判断
        NSArray *array = nil;
        if ([string isEqualToString:HomePage_URL]) {
            array = [[responseObject valueForKey:@"result"] valueForKey:@"data"];
        }
        else{
            array = [[[responseObject valueForKey:@"result"] valueForKey:@"data"] valueForKey:@"sounds"];
        }
        for (id obj in array) {
            Music *music = [Music new];
            [music setValuesForKeysWithDictionary:obj];
            [[DataManager shareDataManager].arrayData addObject:music];
        }
        
        NSLog(@"%ld",[DataManager shareDataManager].arrayData.count);
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
    
}

#pragma mark - 刷新事件
- (void) refresh
{
    NSLog(@"刷新");
    //下拉刷新
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{

        [DataManager shareDataManager].arrayData = nil;
        [DataManager shareDataManager].currentIndex = 0;
        [self requestDataWithUrlString:[DataManager shareDataManager].urlTypeString];
    }];
    //上拉刷新
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self requestDataWithUrlString:[DataManager shareDataManager].urlTypeString];
    }];
    footer.stateLabel.hidden = YES;
    self.tableView.header = header;
    self.tableView.footer = footer;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [DataManager shareDataManager].allData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ReferralsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReferralsCell" forIndexPath:indexPath];
    
    //在有动画的时候不加这一句会有一定概率奔溃，原因我猜是于动画有关系
    if ([DataManager shareDataManager].allData.count == 0) {
        return cell;
    }
    Music *music = [DataManager shareDataManager].allData[indexPath.row];
    cell.imgView.contentMode = UIViewContentModeScaleAspectFit;
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:music.pic_640]];
    cell.nameLabel.text = music.name;
    
    return cell;
}
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    EchoViewController *echoTBC =[EchoViewController shareEchoViewController];
    echoTBC.index = indexPath.row;
    echoTBC.hidesBottomBarWhenPushed = YES;
    echoTBC.isLocal = NO;
    [self.navigationController pushViewController:echoTBC animated:YES];
    
    //点击一边播放音乐，一边展示列表，所以这个播放页面是一个单例类，在某一个地方请求数据，当数据请求完毕加载出页面
    //下载歌曲与遍历
    /*
//    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];//douctments 路径
//    NSString *filePath = [NSString stringWithFormat:@"%@/%@.mp3", path , music.name];//音乐路径名称
//    
//    NSString * musicName = [NSString stringWithFormat:@"%@.mp3", music.name];//音乐名称
//    
//    NSFileManager *fm;
//    NSDirectoryEnumerator *dirEnum;
//    //需要创建文件管理器的实例
//    fm = [NSFileManager defaultManager];
//    //枚举目录
//    dirEnum = [fm enumeratorAtPath:path];
//    pullList
//    
//    while ((path = [dirEnum nextObject]) != nil) {
////        NSLog(@"%@",path);// path是歌曲名称
//        if ([musicName isEqual:path] == YES) {
//            
//            NSLog(@"发现本地文件");
//            AVAudioPlayer *play = [AVAudioPlayer new];
//            self.player = play;
//            //播放本地音乐
            NSString *docDirPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
            NSString *filePath = [NSString stringWithFormat:@"%@/%@.mp3", docDirPath , music.name];
            NSURL *fileURL = [NSURL fileURLWithPath:filePath];
//            self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:nil];
//            [self.player play];
//            
//            return;
//            
//        }
//    }
    

    
    
//    NSData * audioData = [NSData dataWithContentsOfURL:[NSURL URLWithString:music.source]]; //获取data
    //将数据保存到本地指定位置
//    [audioData writeToFile:filePath atomically:YES];//写入文件
    
//    AVAudioPlayer *play = [AVAudioPlayer new];
//    self.player = play;
//    //播放本地音乐
//    NSURL *fileURL = [NSURL fileURLWithPath:filePath];
//    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:nil];
//    [self.player play];
    */
    /*
    [[PlayerHelper sharePlayerHelper] playInternetMusicWithURL:music.source];
    [[PlayerHelper sharePlayerHelper] play];
    

    
    ReferralsCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    
    if (self.timer != nil) {
        [self.timer invalidate];
    }
    //变圆
    CABasicAnimation *ba = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
    ba.fromValue = @0;
    NSNumber *num = [NSNumber numberWithFloat:cell.imgView.frame.size.width/2];
    ba.toValue = num;
    ba.duration = 3;
    [cell.imgView.layer addAnimation:ba forKey:@"123"];
    
    [UIView animateWithDuration:3 animations:^{
        cell.imgView.layer.cornerRadius = cell.imgView.frame.size.width/2;
        cell.imgView.transform = CGAffineTransformScale(cell.imgView.transform, 0.6, 0.6);
    }];
    
    
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(action:) userInfo:cell repeats:YES];*/
}

//- (void) action:(id)sender
//{
//     ReferralsCell *cell = [sender userInfo];
//    
//    [UIView animateWithDuration:1 animations:^{
//        
//        cell.imgView.transform = CGAffineTransformRotate(cell.imgView.transform, M_PI /10);
//        [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:cell.imgView cache:NO];
//        
//    }];
//}

- (IBAction)rightItem:(UIBarButtonItem *)sender {
    
    EchoViewController *echoTBC =[EchoViewController shareEchoViewController];
    echoTBC.index = -1;
    [self.navigationController pushViewController:echoTBC animated:YES];
}

- (IBAction)switchAction:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:NO];
}
@end
