//
//  MyEchoPageViewController.m
//  MyEcho
//
//  Created by iceAndFire on 15/10/27.
//  Copyright © 2015年 free. All rights reserved.
//

#import "MyEchoPageViewController.h"
#import "MyEchoCollectionCell.h"

@interface MyEchoPageViewController ()
{
//    NSInteger _currentIndex;
}
@property (nonatomic, assign) BOOL isPush;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

- (IBAction)returnAction:(UIBarButtonItem *)sender;

//@property (nonatomic, strong) NSMutableArray *allDataArray;

@end

@implementation MyEchoPageViewController

//初始化数据
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        //初始化解析数据！
        [DataManager shareDataManager].currentIndex ++;
        NSLog(@"%ld",[DataManager shareDataManager].currentIndex);
        
        self.urlString = [DataManager shareDataManager].urlTypeString;
        
        NSData *data = nil;
        NSArray *array = nil;
        
        if ([self.urlString isEqualToString:HomePage_URL]) {
            data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[self.urlString stringByAppendingFormat:@"%ld",[DataManager shareDataManager].currentIndex]]];
            if (!data) {
                return self;
            }
            array = [[[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil] valueForKey:@"result"] valueForKey:@"data"];
        }
        else
        {
            data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[self.urlString stringByAppendingFormat:@"%ld&limit=20",[DataManager shareDataManager].currentIndex]]];
            if (!data) {
                return self;
            }
            array = [[[[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil] valueForKey:@"result"] valueForKey:@"data"] valueForKey:@"sounds"];
        }
        
        if (data == nil) {
            return self;
        }
        
        for (id obj in array) {
            Music *music = [Music new];
            [music setValuesForKeysWithDictionary:obj];
            [[DataManager shareDataManager].arrayData addObject:music];
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //register
    [self.collectionView registerNib:[UINib nibWithNibName:@"ShufflingCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"ShufflingCollectionCell"];
    //设置代理
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    //刷新
    [self refresh];
    
    [self setupLeftMenuButton];
}
- (void)viewWillAppear:(BOOL)animated
{
    self.isPush = YES;
    [self.collectionView reloadData];
}

//  添加导航栏左侧的按钮，点击后显示左侧menu
-(void)setupLeftMenuButton
{
    MMDrawerBarButtonItem * leftDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(leftDrawerButtonPress:)];
    [self.navigationItem setLeftBarButtonItem:leftDrawerButton animated:YES];
}

-(void)leftDrawerButtonPress:(id)sender
{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

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
//            [self.allDataArray addObject:music];
        }
        
//        NSLog(@"%ld",self.allDataArray.count);
        NSLog(@"%ld",[DataManager shareDataManager].arrayData.count);
        
        [self.collectionView.header endRefreshing];
        [self.collectionView.footer endRefreshing];
        [self.collectionView reloadData];
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

#pragma mark - 刷新事件
- (void) refresh
{
    //下拉刷新
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        _currentIndex = 0;
        [DataManager shareDataManager].currentIndex = 0;
        
        [DataManager shareDataManager].arrayData = nil;
        
        [self requestDataWithUrlString:self.urlString];
    }];
    
    //上拉刷新
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self requestDataWithUrlString:self.urlString];
    }];
    footer.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    footer.stateLabel.hidden = YES;
    
    self.collectionView.header = header;
    self.collectionView.footer = footer;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark - collection Delegate & DataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}
- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
//    return self.allDataArray.count;
    return [DataManager shareDataManager].arrayData.count;
}

/** 返回cell*/
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        static NSString *cellID = @"ShufflingCollectionCell";
        ShufflingCollectionCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
        return cell;
    }else {
        static NSString *cellID = @"cellID";
        MyEchoCollectionCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
        
//        在有动画的时候不加这一句会有一定概率奔溃，原因我猜是于动画有关系
//        if (self.allDataArray.count == 0) {
//            return cell;
//        }
        if ([DataManager shareDataManager].arrayData.count == 0) {
            return cell;
        }
        
        [cell.imageView removeFromSuperview];
        cell.imageView.frame = cell.bounds;
        
//        if (!self.allDataArray[indexPath.row]) {
//            
//            NSLog(@"function == %s line == %d",__FUNCTION__,__LINE__);
//            return cell;
//            
//        }
//        NSURL *url = [NSURL URLWithString:[self.allDataArray[indexPath.row] pic_500]];
        NSURL *url = [NSURL URLWithString:[[DataManager shareDataManager].arrayData[indexPath.row] pic_500]];
        
        [cell.imageView sd_setImageWithURL:url];
        [cell.contentView addSubview:cell.imageView];
        
        return cell;
    }
}
//* section Spacing */
- (CGFloat)sectionSpacingForCollectionView:(UICollectionView *)collectionView
{
    return 2.f;
}
- (CGFloat)minimumInteritemSpacingForCollectionView:(UICollectionView *)collectionView
{
    return 2.f;
}

- (CGFloat)minimumLineSpacingForCollectionView:(UICollectionView *)collectionView
{
    return 2.f;
}

- (UIEdgeInsets)insetsForCollectionView:(UICollectionView *)collectionView
{
    return UIEdgeInsetsMake(5.f, 0, 5.f, 0);
}


- (CGSize)collectionView:(UICollectionView *)collectionView sizeForLargeItemsInSection:(NSInteger)section
{
    if (section == 0) {
        CGSize size = [UIScreen mainScreen].bounds.size;
        return CGSizeMake(size.width, size.height/4);
    }
    return RACollectionViewTripletLayoutStyleSquare; //same as default !
}

- (UIEdgeInsets)autoScrollTrigerEdgeInsets:(UICollectionView *)collectionView
{
    return UIEdgeInsetsMake(50.f, 0, 50.f, 0);
}

- (UIEdgeInsets)autoScrollTrigerPadding:(UICollectionView *)collectionView
{
    return UIEdgeInsetsMake(64.f, 0, 0, 0);
}
///** 占位图*/
- (CGFloat)reorderingItemAlpha:(UICollectionView *)collectionview
{
    return .3f;
}
/** 能否拖拽 插入*/
- (BOOL)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath canMoveToIndexPath:(NSIndexPath *)toIndexPath
{
    if (toIndexPath.section == 0) {
        return NO;
    }
    return YES;
}
/** 能否拖拽*/
- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return NO;
    }
    return YES;
}
//* 点击事件 */
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    EchoViewController *echoTBC =[EchoViewController shareEchoViewController];
    echoTBC.index = indexPath.row;
    echoTBC.hidesBottomBarWhenPushed = YES;
    echoTBC.isLocal = NO;
    
    if( self.isPush == YES ) {
        self.isPush = NO;
        [self.navigationController pushViewController:echoTBC animated:YES];
    }
}

#pragma mark - Action
- (IBAction)returnAction:(UIBarButtonItem *)sender {
    
    EchoViewController *echoTBC =[EchoViewController shareEchoViewController];
    echoTBC.index = -1;
    [self.navigationController pushViewController:echoTBC animated:YES];
}

- (IBAction)switchAction:(UIButton *)sender {
    
    EchoTableViewController *echoTVC = [EchoTableViewController new];
    [self.navigationController pushViewController:echoTVC animated:YES];
}


#pragma mark - lazy
//- (NSMutableArray *)allDataArray
//{
//    if (!_allDataArray) {
//        _allDataArray = [NSMutableArray array];
//    }
//    return _allDataArray;
//}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
//    if (没有网络就别切换了) {
//        ..
//    }
    
    int offset = (self.collectionView.contentOffset.y+64) /([UIScreen mainScreen].bounds.size.height/2.655);
    offset = offset * 3 +1;
//    NSLog(@"%d",offset);
    UITableViewController *TVC = segue.destinationViewController;
    NSIndexPath *index = [NSIndexPath indexPathForRow:offset inSection:0];
    [UIView animateWithDuration:.5f
                     animations:^{
                         //设置偏移量
                         [TVC.tableView selectRowAtIndexPath:index animated:YES scrollPosition:UITableViewScrollPositionTop];
                     }
                     completion:^(BOOL finished) {
                     }];
}
@end
