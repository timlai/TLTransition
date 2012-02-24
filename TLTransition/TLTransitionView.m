//
//  TLTransitionView.m
//  TLTransition
//
//  Created by Tim Lai on 2012/2/16.

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

#import "TLTransitionView.h"

#pragma mark - UIView helpers
@interface UIView(Extended) 

- (UIImage *) imageByRenderingView;

@end


@implementation UIView(Extended)

- (UIImage *) imageByRenderingView {
    CGFloat oldAlpha = self.alpha;
    self.alpha = 1;
    UIGraphicsBeginImageContext(self.bounds.size);
	[self.layer renderInContext:UIGraphicsGetCurrentContext()];
	UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
    self.alpha = oldAlpha;
	return resultingImage;
}
@end

@interface TLTransitionView(PrivateMethods)
- (void)transitionDidTransit;
- (void)configTransition;
@end

@implementation TLTransitionView
@synthesize transition = transition_;
@synthesize progress = progress_;
@synthesize delegate = delegate_;

#pragma mark - Private Methods
- (void)transitionDidTransit {
    
    if ([delegate_ shouldFinishTransition:self]) {

        [transition_.rootLayer removeFromSuperlayer];
        
        if ([delegate_ respondsToSelector:@selector(transitionDidFinished:)]) {
            [delegate_ transitionDidFinished:self];
        }
    }
}

- (void)configTransition {
    if (!transitionIsReady) {
        transition_.rootLayer.frame = self.bounds;

        [transition_ initTransition];
        
        UIView *v = [self.subviews lastObject];
        [v.layer addSublayer:transition_.rootLayer];
        
        transitionIsReady = YES;
    }
}

#pragma mark - Public Methods
- (void)setTransition:(TLTransition *)transition {
    if (transition_) {
        [transition_.rootLayer removeFromSuperlayer];
        [transition_ release];
    }
    
    transition_ = [transition retain];

    transitionIsReady = NO;
}

- (void)setProgress:(float)progress {   
    [self configTransition];
    progress_ = progress;
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    [transition_ drawContentAtProgress:progress];
    [CATransaction commit];
}

- (void)setProgress:(float)progress duration:(float)duration {
    [self configTransition];
    
    [CATransaction flush];
    [CATransaction begin];
    [CATransaction setAnimationDuration:duration];
    
    progress_ = progress;
    [transition_ drawContentAtProgress:progress];
    
    [CATransaction commit];

    [self performSelector:@selector(transitionDidTransit) withObject:nil afterDelay:duration];
}

- (void)createBeginContentWithView:(UIView *)view {
    if (transition_) {
        view.frame = self.bounds;
        transition_.beginImage = [view imageByRenderingView];
        transitionIsReady = NO;
    }
}

- (void)createEndContentWithView:(UIView *)view {
    if (transition_) {
        view.frame = self.bounds;
        transition_.endImage = [view imageByRenderingView];
        transitionIsReady = NO;
    }
}

- (void)dealloc {
    [transition_ release];
    [super dealloc];
}

@end
