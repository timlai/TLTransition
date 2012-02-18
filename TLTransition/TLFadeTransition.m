//
//  TLFadeTransition.m
//  TLTransition
//
//  Created by 賴 彥廷 on 2012/2/17.
//  Copyright (c) 2012年 中央大學. All rights reserved.
//

#import "TLFadeTransition.h"

@interface TLFadeTransition()
@property (nonatomic, retain) CALayer *layer1;
@property (nonatomic, retain) CALayer *layer2;
@end

@implementation TLFadeTransition
@synthesize layer1;
@synthesize layer2;

- (void)prepareFrom:(UIImage *)currentImage to:(UIImage *)newImage {
    self.layer1 = [CALayer layer];
    self.layer2 = [CALayer layer];
    
    
    layer1.frame = self.rootLayer.bounds;
    layer1.contents = (id)[currentImage CGImage];
    
    layer2.frame = self.rootLayer.bounds;
    layer2.contents = (id)[newImage CGImage];
    layer2.opacity = 0.0;
    
    [self.rootLayer addSublayer:layer2];
    [self.rootLayer addSublayer:layer1];
}

- (void)drawWithProgress:(float)progress {
    layer1.opacity = 1.0 - progress;
    layer2.opacity = progress;
}

- (void)dealloc {
    [layer1 release];
    [layer2 release];
    [super dealloc];
}
@end
