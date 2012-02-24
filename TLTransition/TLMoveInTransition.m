//
//  TLMoveInTransition.m
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

#import "TLMoveInTransition.h"

@implementation TLMoveInTransition
- (void)initTransition {
    if (layer1) {
        [layer1 removeFromSuperlayer];
        [layer2 removeFromSuperlayer];
    }
    
    layer1 = [CALayer layer];
    layer2 = [CALayer layer];
    
    
    layer1.frame = self.rootLayer.bounds;
    layer1.contents = (id)[self.beginImage CGImage];
    
    layer2.frame = self.rootLayer.bounds;
    layer2.contents = (id)[self.endImage CGImage];
    layer2.shadowColor = [UIColor blackColor].CGColor;
    layer2.shadowRadius = 10.0;
    layer2.shadowOpacity = 0.75;
    
    float xPosition = 0.0;
    
    switch (self.directionType) {
        case TLDirectionLeft:
            xPosition = self.rootLayer.frame.size.width*1.5;
            layer2.shadowOffset = CGSizeMake(-5.0, 0.0);
            break;
        case TLDirectionRight:
            xPosition = -self.rootLayer.frame.size.width/2.0;
            layer2.shadowOffset = CGSizeMake(5.0, 0.0);

            break;
        default:
            break;
    }
    layer2.position = CGPointMake(xPosition, self.rootLayer.frame.size.height/2.0);
    
    [self.rootLayer addSublayer:layer1];
    [self.rootLayer addSublayer:layer2];
}

- (void)drawContentAtProgress:(float)progress {
    float distance = self.rootLayer.frame.size.width;
    float xPosition = 0.0;
    
    switch (self.directionType) {
        case TLDirectionLeft:
            xPosition = distance*1.5 - distance*progress;
            break;
        case TLDirectionRight:
            xPosition = -distance*0.5 + distance*progress;
            break;
        default:
            break;
    }
    layer2.position = CGPointMake(xPosition, self.rootLayer.frame.size.height/2.0);
}

@end
