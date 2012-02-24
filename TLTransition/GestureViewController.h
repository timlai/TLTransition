//
//  GestureViewController.h
//  TLTransition
//
//  Created by Tim Lai on 2012/2/20.
//  Copyright (c) 2012年 TiWiTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TLTransitionManager.h"

@interface GestureViewController : UIViewController<TLTransitionManagerDelegate> {
    int pageIndex;
}
@property (retain, nonatomic) UIView *currentView;
@end
