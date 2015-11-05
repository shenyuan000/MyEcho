//
//  ClassificationCell.m
//  MyEcho
//
//  Created by iceAndFire on 15/10/28.
//  Copyright © 2015年 free. All rights reserved.
//

#import "ClassificationCell.h"
#import "ClassificationSubCell.h"

@interface ChannelEchoCell ()

@end

@implementation ClassificationCell

static NSString * const reuseIdentifier = @"ClassificationSubCell";

- (void)awakeFromNib
{
    [super awakeFromNib];

    self.CollectionView.delegate = self;
    self.CollectionView.dataSource = self;
    
    [self requstData];
    
    
}

- (void) requstData
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"JSON_CategoryInfo" ofType:@"txt"];
//    NSLog(@"%@",path);
    NSData *data = [NSData dataWithContentsOfFile:path];
    
    NSMutableArray *responseObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    NSArray *array = [[responseObject valueForKey:@"result"] valueForKey:@"data"];
    
    
    for (id obj in array) {
        CategoryList *categoryList = [CategoryList new];
        [categoryList setValuesForKeysWithDictionary:obj];
        [self.categoryArray addObject:categoryList];
    }
}

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.categoryArray.count;
}

- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ClassificationSubCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    CategoryList *categoryList = self.categoryArray[indexPath.row];
    
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:categoryList.ico_url]];
    cell.nameLabel.text = categoryList.name;
    
    return cell;
}


#pragma mark - lazy
- (NSMutableArray *)categoryArray
{
    if (!_categoryArray) {
        _categoryArray = [NSMutableArray array];
    }
    return _categoryArray;
}
@end
