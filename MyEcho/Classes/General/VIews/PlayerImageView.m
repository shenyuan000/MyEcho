//
//  PlayerImageView.m
//  MyEcho
//
//  Created by iceAndFire on 15/10/18.
//  Copyright © 2015年 free. All rights reserved.
//

#import "PlayerImageView.h"
@interface PlayerHelper()

@end

@implementation PlayerImageView

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    if ([PlayerHelper sharePlayerHelper].isPlay) {
        [[EchoViewController shareEchoViewController] pauseMusic];
    }
}

//一个方法...
- (void)paly:(UIButton *)sender
{
    if ([PlayerHelper sharePlayerHelper].isPlay == NO) {
        [[EchoViewController shareEchoViewController] playMusic];
    }
}

#pragma mark - 懒加载
-(UIButton *)playerButton
{
    if (!_playerButton) {
        _playerButton = [UIButton buttonWithType:UIButtonTypeSystem];
        
        _playerButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2-32, [UIScreen mainScreen].bounds.size.width/2-32, 64, 64);
        
        _playerButton.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        [_playerButton setTintColor:[UIColor greenColor]];
        _playerButton.layer.cornerRadius = self.playerButton.frame.size.width / 2;
        _playerButton.layer.masksToBounds = YES;
        _playerButton.hidden = YES;
        
        [_playerButton setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
        [_playerButton addTarget:self action:@selector(paly:) forControlEvents:UIControlEventTouchUpInside];
        
        
        [self addSubview:_playerButton];
        [self sendSubviewToBack:_playerButton];
        
    }
    return _playerButton;
}


@end
