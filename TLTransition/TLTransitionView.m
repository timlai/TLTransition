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
- (void)transitionFinishedWithProgress:(NSNumber *)progress;
@end

@implementation TLTransitionView
@synthesize transition = transition_;
@synthesize currentView = currentView_;
@synthesize nextView = nextView_;
@synthesize delegate = delegate_;

#pragma mark - Private Methods
- (void)transitionFinishedWithProgress:(NSNumber *)progress {
    [transition_.rootLayer removeFromSuperlayer];
    
    if ([progress floatValue]== 0.0) {
        currentView_.alpha = 1.0;
    }else {
        self.currentView = nextView_;
    }

    self.nextView = nil;

    
    if ([delegate_ respondsToSelector:@selector(transitionDidFinished:)]) {
        [delegate_ transitionDidFinished:self];
    }
}

#pragma mark - Public Methods
- (void)setTransition:(TLTransition *)transition {
    if (transition_) {
        [transition_.rootLayer removeFromSuperlayer];
        [transition_ release];
    }
    
    transition_ = [transition retain];
    transition_.rootLayer.frame = self.bounds;
    transitionIsReady = NO;
}

- (void)setCurrentView:(UIView *)currentView {
    if (currentView_) {
        [currentView_ removeFromSuperview];
        [currentView_ release];
    }
    
    currentView_ = [currentView retain];
    [self addSubview:currentView_];
    
    transitionIsReady = NO;
}


- (void)transitTo:(float)progress duration:(float)duration {
    if (self.currentView == nil || self.nextView == nil) 
        return;

    if (!transitionIsReady) {
        UIImage *currentImage = [currentView_ imageByRenderingView];
        UIImage *newImage = [nextView_ imageByRenderingView];
        
        currentView_.alpha = 0.0;
        
        [transition_ prepareFrom:currentImage to:newImage];
        [self.layer addSublayer:transition_.rootLayer];
        transitionIsReady = YES;
    }
    
    [transition_.rootLayer removeAllAnimations];
    
    if (duration > 0.0) {
        [CATransaction flush];
        [CATransaction begin];
        [CATransaction setAnimationDuration:duration];
    }
    
    [transition_ drawWithProgress:progress];
    
    [CATransaction commit];
    
    if (progress == 1.0 || progress == 0.0) {
        [self performSelector:@selector(transitionFinishedWithProgress:) withObject:[NSNumber numberWithFloat:progress] afterDelay:duration];
    }
}

- (void)dealloc {
    [transition_ release];
    [currentView_ release];
    [nextView_ release];
    [super dealloc];
}

@end
