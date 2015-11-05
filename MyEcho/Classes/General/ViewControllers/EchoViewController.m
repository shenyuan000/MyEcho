//
//  EchoViewController.m
//  MyEcho
//
//  Created by iceAndFire on 15/10/16.
//  Copyright © 2015年 free. All rights reserved.
//

#import "EchoViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
@interface EchoViewController () <PlayerHelperDelegate, NSURLSessionDataDelegate>
{
    //当前model
    Sound *_currentSound;
    //当前下标
    NSInteger _currentIndex;

    //init parameter
    double _playtimerOffset;
    double _timeChangeFlage;
    double _currentTime;
    
}
#pragma mark - 下载的属性
@property (nonatomic, strong) NSURLSessionDownloadTask *downloadTask;
@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) NSData *data;
@property (nonatomic, assign) BOOL isPuase;

#pragma mark - 声明私有属性

@property (nonatomic, strong) NSMutableArray *currentCommentArray;

@property (weak, nonatomic) IBOutlet UIScrollView *bottomScrollView;

#pragma mark -- user上传者信息
@property (weak, nonatomic) IBOutlet UIImageView *userImgView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userFollowed_countLabel;

- (IBAction)followedAction:(UIButton *)sender;

#pragma mark -- player播放器信息
@property (weak, nonatomic) IBOutlet PlayerImageView *playerImgView;//图片
@property (weak, nonatomic) IBOutlet ProgressBar *progressBarView;//进度条
@property (weak, nonatomic) IBOutlet UILabel *currentTimeLabel;//进度条时间
@property (weak, nonatomic) IBOutlet UILabel *currentName;//进度条标题
@property (weak, nonatomic) IBOutlet UILabel *exchange_countLabel;//收听次数
@property (weak, nonatomic) IBOutlet UIView *timerScrollView;//计时进度条(随音乐动的)
@property (weak, nonatomic) IBOutlet UIView *secondTimerScrollView;


#pragma mark -- 三个选项
//开启弹幕 下载图片 定时关闭
- (IBAction)playerBulletAction:(UIButton *)sender;
- (IBAction)echoImageAction:(id)sender;
- (IBAction)TimerCloseAction:(UIButton *)sender;

#pragma mark -- 操作

#pragma mark -- 所属频道
@property (weak, nonatomic) IBOutlet UIImageView *channelImageView;
@property (weak, nonatomic) IBOutlet UILabel *channelTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *channelIntroduceLabel;
#pragma mark - 进度条
@property (weak, nonatomic) IBOutlet UIView *progressViewbar;



#pragma mark -- 介绍
@property (weak, nonatomic) IBOutlet UILabel *introduceAuthorLabel;
@property (weak, nonatomic) IBOutlet UILabel *introduceTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *introduceContentLabel;
@property (weak, nonatomic) IBOutlet UILabel *introduceOriginalLabel;

#pragma mark --commentsView
@property (weak, nonatomic) IBOutlet UIView *commentsView;

#pragma mark -- View操作
@property (weak, nonatomic) IBOutlet UIView *optionView;


@end

@implementation EchoViewController

#pragma mark - 单例方法
+ (instancetype) shareEchoViewController
{
    static EchoViewController *echo = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        echo = [EchoViewController new];
    });
    return echo;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _currentIndex = -1;
    //播放器代理
    [PlayerHelper sharePlayerHelper].delegate = self;
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        if (self.isLocal == NO) {
            [self lodingComments];
        }
    }];
    footer.stateLabel.hidden = YES;
    self.bottomScrollView.footer = footer;
    
    //初始化session对象
    self.session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    //处理暂停下载
    self.isPuase = NO;
    
    //开始接受远程事件
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];
    
    //监听后台
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAudioSessionEvent:) name:AVAudioSessionInterruptionNotification object:nil];
    
}
- (void)onAudioSessionEvent:(id)sender
{
    NSLog(@"%@",sender);
    //音频中断后暂停音乐
    [self pauseMusic];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
//    [self.downloadTask suspend];
//    self.downloadTask = nil;
    
    self.bottomScrollView.contentOffset = CGPointMake(0, 0);
    
    if (self.index == -1) {
        return;
    }
    _currentIndex = self.index;
    [self prepareForPlaying];
}

//播放音乐
- (void) prepareForPlaying
{

    _currentTime = 0.0;
    //如果点击了本地音乐，那么播放器就走本地播放数据，如果点击 网络数据就走网络数据
    if (self.isLocal == YES) {
        [self lodingLocalmusic];
        return;
    }
    //初始化选项
    [self initWithOptionViews];
    //加载Sound Info and playMusic
    [self lodingSound];
    //加载评论
    [self lodingComments];
}
//加载本地音乐
- (void) lodingLocalmusic
{
    //传来的只有下标，记得处理上一曲下一曲
    //持久化音乐文件
//    [self initParameterOffset];
    
    _currentSound = [DataManager shareDataManager].localURLArray[_currentIndex];
    NSLog(@"\n\n~~~~~~~~~~~~~~~~~~~~~~~~~~~%@",_currentSound.name);
    NSLog(@"%@",_currentSound.source);
    
    //显示信息
    [self showSongInfo];
    //初始化参数
    [self initParameterOffset];
    //评论
    [self showComments];
    //播放音乐
    [[PlayerHelper sharePlayerHelper] playInternetMusicWithURL:_currentSound.source];
    
    //显示锁屏信息
    [self configNowPlayingInfoCenter];
    
    if (self.playerImgView.playerButton.hidden == NO && [PlayerHelper sharePlayerHelper].isPlay) {
        self.playerImgView.playerButton.hidden = YES;
    }
    
}

//加载Sound Info and playMusic
- (void) lodingSound
{

    NSLog(@"function == %s line == %d",__FUNCTION__,__LINE__);
    NSString *soundId = [[DataManager shareDataManager].allData[_currentIndex] ID];
    NSString *url = [Sound_URL stringByAppendingFormat:@"%@",soundId];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        Sound *sound = [Sound new];
        [sound setValuesForKeysWithDictionary:[responseObject valueForKey:@"result"]];
        User *user = [User new];
        [user setValuesForKeysWithDictionary:[[responseObject valueForKey:@"result"] valueForKey:@"user"]];
        sound.user = user;
        Channel *channel = [Channel new];
        [channel setValuesForKeysWithDictionary:[[responseObject valueForKey:@"result"] valueForKey:@"channel"]];
        sound.channel = channel;
        _currentSound = sound;
        //显示评论总数
        /** 7个集合，0.评论数 1~5 内容 6.button */
        //评论数
        UILabel *commentCountLabel = [[self.commentsView subviews][0] subviews][0];
        
        commentCountLabel.text = [@"   评论数 (" stringByAppendingFormat:@"%@)", _currentSound.comment_count];
        
        //锁屏信息
        [self configNowPlayingInfoCenter];
        
        
        //显示信息
        [self showSongInfo];
        //初始化参数
        [self initParameterOffset];
        //播放音乐
        [[PlayerHelper sharePlayerHelper] playInternetMusicWithURL:_currentSound.source];
        if (self.playerImgView.playerButton.hidden == NO && [PlayerHelper sharePlayerHelper].isPlay) {
            self.playerImgView.playerButton.hidden = YES;
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}





//展示信息
- (void)showSongInfo
{
    //user上传者信息
    [self.userImgView sd_setImageWithURL:[NSURL URLWithString:_currentSound.user.avatar]];
    self.userNameLabel.text = _currentSound.user.name;
    self.userFollowed_countLabel.text = _currentSound.user.followed_count;
    
    //播放器信息
    if (self.isLocal == YES) {
        self.playerImgView.image = [UIImage imageWithContentsOfFile:_currentSound.pic_640];
        [self configNowPlayingInfoCenter];
    }
    else
    {
        [self.playerImgView sd_setImageWithURL:[NSURL URLWithString:_currentSound.pic_640]];
        [self.playerImgView sd_setImageWithURL:[NSURL URLWithString:_currentSound.pic_640] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [self configNowPlayingInfoCenter];
        }];
    }
    
    self.playerImgView.contentMode = UIViewContentModeScaleAspectFit;
    
    self.currentName.text = _currentSound.name;
    self.exchange_countLabel.text = _currentSound.view_count;
    
    //所属频道
    [self.channelImageView sd_setImageWithURL:[NSURL URLWithString:_currentSound.channel.pic_100]];
    self.channelTitleLabel.text = _currentSound.channel.name;
    self.channelIntroduceLabel.text = _currentSound.channel.info;
    
    //介绍
    self.introduceAuthorLabel.text = _currentSound.user.name;
    self.introduceTitleLabel.text = _currentSound.name;
    self.introduceContentLabel.text = _currentSound.info;
}
- (void) lodingComments
{
    //从一个公用的数组中获取数据，来请求sound，与外界的接口是 index datamanager中的allData
    
    NSString *soundId = [[DataManager shareDataManager].allData[_currentIndex] ID];
    
    NSString *urlWithComments = [Comments_URL stringByAppendingFormat:@"%@",soundId];
    
    AFHTTPRequestOperationManager *manager_2 = [AFHTTPRequestOperationManager manager];
    [manager_2 GET:urlWithComments parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        self.currentCommentArray = nil;
        NSArray *array =[[responseObject valueForKey:@"result"] valueForKey:@"data"];
        for (id obj in array) {
            Comments *comments = [Comments new];
            [comments setValuesForKeysWithDictionary:obj];
            
            User *user = [User new];
            [user setValuesForKeysWithDictionary:[obj valueForKey:@"user"]];
            comments.user = user;
            
            [self.currentCommentArray addObject:comments];
            
        }
        [self showComments];
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}
- (void) showComments
{
    if (self.currentCommentArray.count == 0) {
        return;
    }
    /** 7个集合，0.评论数 1~5 内容 6.button */
    NSArray *superViews = [self.commentsView subviews];
    
    for (int i=1; i<=self.currentCommentArray.count; i++)
    {
        /**0.img 1.name 2.time 3.content 4.endtime 5.text 6.button  */
        NSArray *subViews = [superViews[i] subviews];
        Comments *comments = [Comments new];
        comments = self.currentCommentArray[i-1];
        
//        NSLog(@"%ld",subViews.count);
        
        //头像
        [subViews[0] sd_setImageWithURL:[NSURL URLWithString:comments.user.avatar_50]];
        
        //名字c
        UILabel *nameLabel = subViews[1];
        if (nameLabel.text != nil) {
            nameLabel.text = comments.user.name;
        }
        
        
        //createTime; Integer
        UILabel *createTimeLabel = subViews[2];
        if (createTimeLabel.text != nil) {
            if ([comments.create_time isKindOfClass:[NSString class]]) {
                createTimeLabel.text = comments.create_time;
            }
            else{
                NSLog(@"类型不匹配");
            }
            
        }
        
        
        //内容
        UILabel *contentLabel = subViews[3];
        if (contentLabel.text != nil) {
            contentLabel.text = comments.content;
        }
        
        
        //endTime Integer
            UILabel *endTimeLabel = subViews[4];
        if (endTimeLabel.text != nil) {
            if ([comments.end_time isKindOfClass:[NSString class]]) {
                 endTimeLabel.text = [comments.end_time stringByAppendingString:@"秒"];
            }
            else{
                NSLog(@"类型不匹配");
            }
           
        }
        
        //like Integer
        UIButton *likeButton = subViews[6];
        if (likeButton.titleLabel != nil) {
            if ([comments.like isKindOfClass:[NSString class]]) {
                [likeButton setTitle:[@" " stringByAppendingString: comments.like] forState:UIControlStateNormal];
            }
            else{
                NSLog(@"类型不匹配");
            }
            
            
        }
        
    }
    [self.bottomScrollView.footer endRefreshing];
    
}

//初始化option视图
- (void)initWithOptionViews
{
    NSArray *subViewsArray = [self.optionView subviews];
    
    if (subViewsArray[0] != nil) {
        UIButton *commentsButton = subViewsArray[0];
    }
    
    
//    if (subViewsArray[1] != nil) {
//        UIButton *likeButton = subViewsArray[1];
//        
//        UITapGestureRecognizer *addcaidan = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addcaidan)];
//        addcaidan.numberOfTapsRequired = 10;
//        [likeButton addGestureRecognizer:addcaidan];
//        
//    }
    
    
    if (subViewsArray[2] != nil) {
        UIButton *downloadButton = subViewsArray[2];
        [downloadButton addTarget:self action:@selector(starDownload:) forControlEvents:UIControlEventTouchUpInside];
        [downloadButton setImage:[UIImage imageNamed:@"下载"] forState:UIControlStateNormal];
    }
    
    
    UIButton *shareButton;
    
    UILabel *commentsLabel;
    UILabel *likeLabel;
    if (subViewsArray[6] != nil) {
        UILabel *downloadLabel = subViewsArray[6];
    }
    
    UILabel *shareLabel;
    
    NSLog(@"%ld",subViewsArray.count);
}
//#pragma mark - 彩蛋
//- (void) addcaidan{
//    
//    NSArray *subViewsArray = [self.optionView subviews];
//    UIButton *downloadButton = subViewsArray[2];
//    [downloadButton addTarget:self action:@selector(starDownload:) forControlEvents:UIControlEventTouchUpInside];
//    [downloadButton setImage:[UIImage imageNamed:@"下载"] forState:UIControlStateNormal];
//}


#pragma mark - 下载
- (void)starDownload:(UIButton *)sender
{
    if (self.isLocal == YES) {
        NSLog(@"本地模式,失败下载");
        [self.downloadTask cancel];
        self.downloadTask = nil;
        return;
    }
    [sender setImage:[UIImage imageNamed:@"下载中"] forState:UIControlStateNormal];
    
    if (self.downloadTask){
        if (self.isPuase == YES) {
            self.isPuase = NO;
            
            NSLog(@"继续下载");
            NSLog(@"%lu",self.data.length);
            //继续下载
            [sender setImage:[UIImage imageNamed:@"下载中"] forState:UIControlStateNormal];
            self.downloadTask = [self.session downloadTaskWithResumeData:self.data];
            [self.downloadTask resume];
            return;
        }
        NSLog(@"暂停下载");
        [sender setImage:[UIImage imageNamed:@"下载"] forState:UIControlStateNormal];
        self.isPuase = YES;
        __weak typeof(self) vc = self;
        [self.downloadTask cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
            NSLog(@"%lu",resumeData.length);
            vc.data = resumeData;
        }];
        return;
    }
    else
    {
        
        
        NSLog(@"开始下载");
        NSString *micUrl = _currentSound.source;
        self.downloadTask = [self.session downloadTaskWithURL:[NSURL URLWithString:micUrl]];
    }
    //开始任务
    [self.downloadTask resume];
}
#pragma mark - 完成下载实现音乐播放
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location
{
    NSLog(@"已下载");
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"下载完成" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:okAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
    [self storedInTheLocal:location];
    self.downloadTask = nil;
}

- (void)storedInTheLocal:(NSURL *)location
{
    NSFileManager * manager=[NSFileManager defaultManager];
    //Document目录
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    //获取复杂对象
    Sound *sound = [DataManager shareDataManager].allData[_currentIndex];
    //创建的目录
    NSString *musicPath = [path stringByAppendingFormat:@"/MusicData"];
    //创建一个文件夹
    [manager createDirectoryAtPath:musicPath withIntermediateDirectories:YES attributes:nil error:nil];
    
    //目标url
    NSURL *url=[NSURL fileURLWithPath:[musicPath stringByAppendingFormat:@"/%@.mp3",sound.name]];
    //转换成字典
    NSDictionary *currentDict = _currentSound.keyValues;
    //字典存入文件
    [currentDict writeToFile:[musicPath stringByAppendingFormat:@"/%@.txt",sound.name] atomically:YES];
    
    
    NSData *data = UIImageJPEGRepresentation(self.playerImgView.image, 1);
    [data writeToFile:[musicPath stringByAppendingFormat:@"/%@.jpg",sound.name] atomically:YES];
    
    
    //从location移动到url
    [manager moveItemAtURL:location toURL:url error:nil];
}
#pragma mark - 监听下载 进度条等等 进度条放在这里~~~
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite{
    
    if (self.isLocal == YES) {
        NSLog(@"本地模式,失败下载");
        [self.downloadTask cancel];
        self.downloadTask = nil;
        return;
    }
    
    
    double downloadProgress = totalBytesWritten / (double)totalBytesExpectedToWrite;
    
    
    CGRect progressBarViewFrame = self.progressViewbar.frame;
    progressBarViewFrame.size.width = (double)[UIScreen mainScreen].bounds.size.width * downloadProgress;
    NSLog(@"👻%@",NSStringFromCGRect(self.progressViewbar.frame));
    self.progressViewbar.frame = progressBarViewFrame;
    
//    NSLog(@"%f", downloadProgress);
    
}


#pragma mark - 实现playerHelper 协议方法
//给外界提供当前播放时间 1秒更新一次 do something
- (void) playingWithTime:(NSTimeInterval)time
{
    _currentTime = time;
    [self changeProgress];
    
    NSLog(@"_currentTime %f",_currentTime);
          
          
    //卡住了进度条不因该变化
    if (time == _timeChangeFlage) {
        return;
    }
    //播放进度条 增加宽
    self.timerScrollView.frame = CGRectMake(self.timerScrollView.frame.origin.x, self.timerScrollView.frame.origin.y, time * _playtimerOffset, self.timerScrollView.frame.size.height);
    //进度条后边的视图 改变水平位置
    self.secondTimerScrollView.frame = CGRectMake(time * _playtimerOffset, self.secondTimerScrollView.frame.origin.y, self.secondTimerScrollView.frame.size.width, self.secondTimerScrollView.frame.size.height);
    //显示进度条时间
    self.currentTimeLabel.text = [self timeFormatted:(int)time];
}
//结束的方法 用来播放下一曲歌
- (void) didStop
{
    [self nextMusic];
}

- (void)playMusic
{
    [[PlayerHelper sharePlayerHelper] play];
    self.playerImgView.playerButton.hidden = YES;
}
- (void)pauseMusic
{
    [[PlayerHelper sharePlayerHelper] pause];
    self.playerImgView.playerButton.hidden = NO;
}


#pragma mark - 设置锁屏播放器信息
-(void)configNowPlayingInfoCenter{
//    NSLog(@"👻👻👻👻👻👻👻👻👻👻👻👻👻👻👻👻👻👻function == %s line == %d",__FUNCTION__,__LINE__);
    if (NSClassFromString(@"MPNowPlayingInfoCenter")) {
        //要一个字典存放要显示的信息
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        
        //歌曲名称
        [dict setObject:_currentSound.name forKey:MPMediaItemPropertyTitle];
        //演唱者
        [dict setObject:_currentSound.user.name forKey:MPMediaItemPropertyArtist];
        //专辑名
        [dict setObject:_currentSound.channel.name forKey:MPMediaItemPropertyAlbumTitle];
        //专辑缩略图
        if (self.playerImgView.image != nil){
            UIImage *image = self.playerImgView.image;
            MPMediaItemArtwork *artwork = [[MPMediaItemArtwork alloc] initWithImage:image];
            [dict setObject:artwork forKey:MPMediaItemPropertyArtwork];
        }
        //音乐剩余时长
        [dict setObject:[NSNumber numberWithDouble:[_currentSound.length doubleValue]] forKey:MPMediaItemPropertyPlaybackDuration];
//        音乐当前播放时间 在计时器中修改
        [dict setObject:[NSNumber numberWithDouble:_currentTime] forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime];
        //设置锁屏状态下屏幕显示播放音乐信息
        [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:dict];
    }
}


//计时器修改进度
- (void)changeProgress{

    //当前播放时间
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[[MPNowPlayingInfoCenter defaultCenter] nowPlayingInfo]];
    
    [dict setObject:[NSNumber numberWithDouble:_currentTime] forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime]; //音乐当前已经过时间
    [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:dict];

}








//下一曲
- (void) nextMusic
{
    _currentIndex++;
    
    if (self.isLocal == NO) {
        if (_currentIndex >= [DataManager shareDataManager].allData.count) {
            _currentIndex = 0;
        }
    }else{
        if (_currentIndex >= [DataManager shareDataManager].localURLArray.count) {
            _currentIndex = 0;
        }
    }
    
    [self prepareForPlaying];
}
//上一曲
- (void) PreviousMusic
{
    _currentIndex --;
    
    if (self.isLocal == NO) {
        if (_currentIndex < 0) {
            _currentIndex = [DataManager shareDataManager].allData.count-1;
        }
    }else{
        if (_currentIndex < 0) {
            _currentIndex = [DataManager shareDataManager].localURLArray.count-1;
        }
    }
    [self prepareForPlaying];
}

#pragma mark - 本身的方法
//初始化一些参数
- (void) initParameterOffset
{
//    NSLog(@"初始化参数");
    //时间改变标识
    _timeChangeFlage = 0;
    //获取偏移量
    double totalTime = [_currentSound.length doubleValue];
    double width = [UIScreen mainScreen].bounds.size.width;
    _playtimerOffset = width / totalTime;
    
    //进度条 block 合适的回调的位置
    self.progressBarView.result = ^()
    {
        [[PlayerHelper sharePlayerHelper] seekToTime: self.progressBarView.xpoint / _playtimerOffset];
        
        //下面三条代码 为了使点击进度条播放歌曲同步， 与playerhelper代理方法 一样
        //播放进度条 增加宽
        self.timerScrollView.frame = CGRectMake(self.timerScrollView.frame.origin.x, self.timerScrollView.frame.origin.y, self.progressBarView.xpoint, self.timerScrollView.frame.size.height);
        //进度条后边的视图 改变水平位置
        self.secondTimerScrollView.frame = CGRectMake(self.progressBarView.xpoint, self.secondTimerScrollView.frame.origin.y, self.secondTimerScrollView.frame.size.width, self.secondTimerScrollView.frame.size.height);
        //显示进度条时间
        self.currentTimeLabel.text = [self timeFormatted:(int)self.progressBarView.xpoint / _playtimerOffset];
    };
    
    //恢复初始位置
    CGRect timerScrollViewframe = self.timerScrollView.frame;
    timerScrollViewframe.size.width = 0;
    CGRect secondTimerScrollViewframe = self.secondTimerScrollView.frame;
    secondTimerScrollViewframe.origin.x = 0;
    
    self.timerScrollView.frame = timerScrollViewframe;
    self.secondTimerScrollView.frame = secondTimerScrollViewframe;
    
    self.currentTimeLabel.text = @"00:00";

}
//秒数转 时 分 这类方法应该考虑封装一个工具类
#pragma mark - 秒数转 时 分
- (NSString *)timeFormatted:(int)totalSeconds
{
    
    int seconds = totalSeconds % 60;
    int minutes = totalSeconds / 60;
//    int minutes = (totalSeconds / 60) % 60;
//    int hours = totalSeconds / 3600;
    
    return [NSString stringWithFormat:@"%02d:%02d",minutes, seconds];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)followedAction:(UIButton *)sender {
}
- (IBAction)playerBulletAction:(UIButton *)sender {
}
- (IBAction)echoImageAction:(id)sender {
}
- (IBAction)TimerCloseAction:(UIButton *)sender {
}



#pragma mark - 懒加载
- (NSMutableArray *)currentCommentArray
{
    if (!_currentCommentArray) {
        _currentCommentArray = [NSMutableArray new];
    }
    return _currentCommentArray;
}

@end
