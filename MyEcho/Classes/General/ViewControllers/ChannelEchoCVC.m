//
//  ChannelEchoCVC.m
//  MyEcho
//
//  Created by iceAndFire on 15/10/21.
//  Copyright © 2015年 free. All rights reserved.
//

#import "ChannelEchoCVC.h"
#import "ClassificationCell.h"
#import "MyEchoPageViewController.h"
#import "SetingTBC.h"

@interface ChannelEchoCVC ()<UICollectionViewDelegateFlowLayout>
{
    NSInteger _currentIndex;
}
//存 频道 数据
@property (nonatomic, strong) NSMutableArray *dataArray;
//存请求链接
@property (nonatomic, strong) NSString *urlTypeString;


@property (nonatomic, strong) UIButton *buttonHot;
@property (nonatomic, strong) UIButton *buttonNew;

//设置按钮
- (IBAction)setingAction:(UIBarButtonItem *)sender;

@end

@implementation ChannelEchoCVC

static NSString * const reuseIdentifier = @"ChannelEchoCell";
static NSString * const shufflingCellIdentifier = @"ShufflingCollectionCell";

static NSString * const classificationIdentifier = @"ClassificationCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //添加所有视图
    [self addAllViews];
    //刷新
    [self refresh];
    //默认hot
    self.urlTypeString = HOT;
    //请求
    [self requstDataWithUrlstr:self.urlTypeString];
}

- (void) addAllViews
{
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 108, screenSize.width, 44)];
    
    UIButton *newButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [newButton setTitle:@"最新" forState:UIControlStateNormal];
    [newButton setTitleColor:[UIColor grayColor]forState:UIControlStateNormal];
    newButton.frame = CGRectMake(10, view.frame.size.height-44, 50, 44);
    [newButton addTarget:self action:@selector(requestTypeAction:) forControlEvents:UIControlEventTouchUpInside];
    self.buttonNew = newButton;
    [view addSubview:newButton];
    
    UIButton *hotButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [hotButton setTitle:@"最热" forState:UIControlStateNormal];
    [hotButton setTitleColor:[UIColor redColor]forState:UIControlStateNormal];
    hotButton.frame = CGRectMake(110, view.frame.size.height-44, 50, 44);
    [hotButton addTarget:self action:@selector(requestTypeAction:) forControlEvents:UIControlEventTouchUpInside];
    self.buttonHot = hotButton;
    [view addSubview:hotButton];
    
    [self.collectionView addSubview:view];
}
- (void) requestTypeAction:(UIButton *) sender
{
    [self.buttonHot setTitleColor:[UIColor grayColor]forState:UIControlStateNormal];
    [self.buttonNew setTitleColor:[UIColor grayColor]forState:UIControlStateNormal];
    
    if ([sender.titleLabel.text isEqualToString:@"最新"]) {
        [sender setTitleColor:[UIColor redColor]forState:UIControlStateNormal];
        self.urlTypeString = NEW;
        
    }
    else if ([sender.titleLabel.text isEqualToString:@"最热"])
    {
        [sender setTitleColor:[UIColor redColor]forState:UIControlStateNormal];
        self.urlTypeString = HOT;
    }
    _currentIndex = 0;
    [self.dataArray removeAllObjects];
    [self requstDataWithUrlstr:self.urlTypeString];
}

#pragma mark - 刷新事件
- (void) refresh
{
    //上拉刷新
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self requstDataWithUrlstr:self.urlTypeString];
    }];
    footer.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    footer.stateLabel.hidden = YES;
    self.collectionView.footer = footer;
    
}

- (void) requstDataWithUrlstr:(NSString *)urlString
{
 
    NSString *url = [Channel_URL stringByAppendingFormat:@"%ld%@",++_currentIndex,urlString];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSArray *array = [[responseObject valueForKey:@"result"] valueForKey:@"data"];
        
        for (id obj in array) {
            Channel *channel = [Channel new];
            [channel setValuesForKeysWithDictionary:obj];
            [self.dataArray addObject:channel];
        }
        
        //刷新页面
        [self.collectionView reloadData];
        //结束刷新
        [self.collectionView.header endRefreshing];
        [self.collectionView.footer endRefreshing];
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark <UICollectionViewDataSource>

//返回组数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}
//返回组中个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    switch (section) {
        case 0:
        {
            return 1;
        }
            break;
            
        default:
        {
            return self.dataArray.count;
        }
            break;
    }
}
//返回cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    switch (indexPath.section) {
        case 0:
        {
            ClassificationCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:classificationIdentifier forIndexPath:indexPath];
            
            return cell;
        }
            break;
        default:
        {
            ChannelEchoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
            Channel *channal = self.dataArray[indexPath.row];
            cell.cellLabel.text = channal.name;
            [cell.cellImageView sd_setImageWithURL:[NSURL URLWithString:channal.pic_500]];
            
            return cell;
        }
            break;
    }
}
#pragma UICollectionViewDelegateFlowLayout

//item的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    switch (indexPath.section) {
        case 0:
        {
            CGFloat width = [UIScreen mainScreen].bounds.size.width*5/6;
            return CGSizeMake(width, 120);
        }
            break;
            
        default:
        {
            CGFloat width = [UIScreen mainScreen].bounds.size.width*5/6-20;
            return CGSizeMake(width, 100);
        }
            break;
    }
}
//上左下右
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    switch (section) {
        case 0:
        {
            return UIEdgeInsetsMake(0, 0, 0, 0);
        }
            break;
            
        default:
        {
            return UIEdgeInsetsMake(44, 0, 0, 0);
        }
            break;
    }
}

//最小间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    switch (section) {
        case 0:
        {
            return 0;
        }
            break;
            
        default:
        {
            return 0;
        }
            break;
    }
}
//最小间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    switch (section) {
        case 0:
        {
            return 0;
        }
            break;
            
        default:
        {
            return 10;
        }
            break; 
    }
}

//点击事件
- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    Channel *channel = self.dataArray[indexPath.row];
    //给dataManager 传值 让下一个控制器获得
    NSString *url = [NSString stringWithFormat:@"http://echosystem.kibey.com/channel/info?list_order=%@&id=%@&page=",@"hot",channel.ID];
    if (![url isEqualToString:[DataManager shareDataManager].urlTypeString]) {
        [DataManager shareDataManager].urlTypeString = url;
        [DataManager shareDataManager].arrayData = nil;
        [DataManager shareDataManager].currentIndex = 0;
    }
    
    
    //获取控制器
    
    [self.mm_drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
        
        MyEchoPageViewController *myEchoPageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"首页"];
        
        self.mm_drawerController.centerViewController = myEchoPageViewController;
        
    }];
}



- (IBAction)setingAction:(UIBarButtonItem *)sender {
    
    SetingTBC *setingTBC = [SetingTBC new];
    UINavigationController *setingNC = [[UINavigationController alloc] initWithRootViewController:setingTBC];
    
    [self showDetailViewController:setingNC sender:nil];
    [EchoViewController shareEchoViewController].index = -1;
}


#pragma mark - lazy
- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}



@end
