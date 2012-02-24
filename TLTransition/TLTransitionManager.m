//
//  TLTransitionManager.m
//  TLTransition
//
//  Created by Tim Lai on 2012/2/24.

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

#import "TLTransitionManager.h"

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

@interface TLTransitionManager()
- (void)transitionDidTransit;
- (void)configTransition;
@property (nonatomic, retain) UIView *transitionView;
@end

@implementation TLTransitionManager
@synthesize transition = transition_;
@synthesize progress = progress_;
@synthesize delegate = delegate_;
@synthesize transitionView = transitionView_;

- (void)transitionDidTransit {
    
    if ([delegate_ respondsToSelector:@selector(transitionWillTerminate:)]) 
        [delegate_  transitionWillTerminate:self];
    
    [transition_.rootLayer removeFromSuperlayer];
    
    if ([delegate_ respondsToSelector:@selector(transitionDidTerminated:)]) 
        [delegate_ transitionDidTerminated:self];
}

- (void)configTransition {
    if (!transitionIsReady) {
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        
        transition_.rootLayer.frame = transitionView_.bounds;        
        [transition_ initTransition];
        
        [transitionView_.layer addSublayer:transition_.rootLayer];
        
        [CATransaction commit];
        transitionIsReady = YES;
    }
}

#pragma mark - Singleton
static TLTransitionManager *sharedManager_ = nil;

+ (TLTransitionManager *)sharedManager {
	if (!sharedManager_) {
		sharedManager_ = [[TLTransitionManager alloc] init];
	}
	return sharedManager_;
}


#pragma mark - Public Methods
- (void)setTransition:(TLTransition *)transition {
    if (transition_) {
        [transition_.rootLayer removeFromSuperlayer];
        [transition_ release];
        transition_ = nil;
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

- (void)createTransitionOnView:(UIView *)view {
    if (transition_) {
        self.transitionView = view;
        transition_.beginImage = [view imageByRenderingView];
        transitionIsReady = NO;
    }
}

- (void)createEndContentWithView:(UIView *)view {
    if (transition_) {
        transition_.endImage = [view imageByRenderingView];
        transitionIsReady = NO;
    }
}

- (void)dealloc {
    [transition_ release];
    [transitionView_ release];
    [super dealloc];
}

@end
