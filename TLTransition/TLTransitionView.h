//
//  TLTransitionView.h
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

#import <UIKit/UIKit.h>
#import "TLTransition.h"
#import <QuartzCore/QuartzCore.h>

@protocol TLTransitionViewDelegate;

@interface TLTransitionView : UIView {
    BOOL transitionIsReady;
}

- (void)setProgress:(float)progress duration:(float)duration;
- (void)createBeginContentWithView:(UIView *)view;
- (void)createEndContentWithView:(UIView *)view;
@property (nonatomic, retain) TLTransition *transition;
@property (nonatomic, assign) float progress;
@property (nonatomic, assign) id<TLTransitionViewDelegate> delegate;

@end

@protocol TLTransitionViewDelegate <NSObject>
@required
- (BOOL)shouldFinishTransition:(TLTransitionView *)transitionView;

@optional
- (void)transitionDidFinished:(TLTransitionView *)transitionView;
@end