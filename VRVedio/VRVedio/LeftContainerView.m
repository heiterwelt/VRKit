//
//  LeftContainerView.m
//  VRVedio
//
//  Created by Linyou-IOS-1 on 16/8/25.
//  Copyright © 2016年 TGSDK. All rights reserved.
//

#import "LeftContainerView.h"

@implementation LeftContainerView

-(instancetype)initWithFrame:(CGRect)frame;
{
    self=[super initWithFrame:frame];
    if (self) {
        self.scrollLayer = [CAScrollLayer layer];
        [self.layer addSublayer:self.scrollLayer];
        self.transformLayer = [CATransformLayer layer];
        [self.scrollLayer addSublayer:self.transformLayer];
        self.playLayer=[AVPlayerLayer layer];
        [self.transformLayer addSublayer:self.playLayer];
    }
    return self;
}


//-(void)drawRect:(CGRect)rect{
//    
//}
//
//-(void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx{
//    
//}

@end
