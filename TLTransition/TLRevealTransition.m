//
//  TLRevealTransition.m
//  TLTransition
//
//  Created by Tim Lai on 2012/2/17.

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


#import "TLRevealTransition.h"

@implementation TLRevealTransition

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
    layer2.opacity = 0.0;
    
    [self.rootLayer addSublayer:layer2];
    [self.rootLayer addSublayer:layer1];   
    
}

- (void)drawContentAtProgress:(float)progress {
    layer1.opacity = 1.0 - progress;
    layer2.opacity = progress;      
}

@end
