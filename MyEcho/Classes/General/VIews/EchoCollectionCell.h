//
//  EchoCollectionCell.h
//  MyEcho
//
//  Created by iceAndFire on 15/10/26.
//  Copyright © 2015年 free. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Music;
@interface EchoCollectionCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *songImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

//cell的model
@property (nonatomic, strong) Music *music;

@end
