//
//  ClassificationCell.h
//  MyEcho
//
//  Created by iceAndFire on 15/10/28.
//  Copyright © 2015年 free. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClassificationCell : UICollectionViewCell<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) NSMutableArray *categoryArray;

@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@property (weak, nonatomic) IBOutlet UICollectionView *CollectionView;

@end
