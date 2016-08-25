//
//  LeftContainerView.h
//  VRVedio
//
//  Created by Linyou-IOS-1 on 16/8/25.
//  Copyright © 2016年 TGSDK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@interface LeftContainerView : UIView
@property(nonatomic,strong)CAScrollLayer *scrollLayer;
@property(nonatomic,strong)AVPlayerLayer *playLayer;
@property(nonatomic,strong)CATransformLayer *transformLayer;
-(instancetype)initWithFrame:(CGRect)frame;
@end
