//
//  TLCubeTransition.m
//  TLTransition
//
//  Created by Tim Lai on 2012/2/20.

// This code is distributed under the terms and conditions of the MIT license. 

// Copyright (c) 2012 Tim Lai
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.


#import "TLCubeTransition.h"
#define radians(degrees) degrees * M_PI / 180

@implementation TLCubeTransition

- (void)prepareFrom:(UIImage *)currentImage to:(UIImage *)newImage {
    if (transformLayer) {
        [transformLayer removeFromSuperlayer];
    }
    
    transformLayer = [CATransformLayer layer];
    transformLayer.frame = self.rootLayer.bounds;
    CATransform3D transform = CATransform3DIdentity; 
    transform.m34 = 1.0 / -800;
    transformLayer.transform = transform;
    [self.rootLayer addSublayer:transformLayer];
    

    CALayer *layer1 = [CALayer layer];
    layer1.frame = self.rootLayer.bounds;
    layer1.contents = (id)[currentImage CGImage];
    [transformLayer addSublayer:layer1];
    
    CATransform3D t = CATransform3DMakeTranslation(0, 0, 0);
    t = CATransform3DRotate(t, radians(90), 0, 1, 0);
    t = CATransform3DTranslate(t, self.rootLayer.bounds.size.width/2.0, 0, self.rootLayer.bounds.size.width/2.0);
    
    CALayer *layer2 = [CALayer layer];
    layer2.frame = self.rootLayer.bounds;
    layer2.contents = (id)[newImage CGImage];
    layer2.transform = t;
    [transformLayer addSublayer:layer2];  
    
    self.rootLayer.backgroundColor = [UIColor blackColor].CGColor;
    
}

- (void)renderToProgress:(float)progress {
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    CATransform3D transform = CATransform3DIdentity;    
    
    transform = CATransform3DTranslate(transform,-self.rootLayer.bounds.size.width/2.0*progress, 0, -self.rootLayer.bounds.size.width*2.0*progress);
    transform = CATransform3DRotate(transform, radians(-90.0*progress), 0, 1.0, 0);

    transformLayer.transform = transform;
}

@end
