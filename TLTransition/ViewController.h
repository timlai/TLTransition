//
//  ViewController.h
//  TLTransition
//
//  Created by Tim Lai on 2012/2/16.
//  Copyright (c) 2012年 TiWiTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TLTransitionView.h"
#import "TLFadeTransition.h"

@interface ViewController : UIViewController<TLTransitionViewDelegate> {
    int pageIndex;
}
@property (retain, nonatomic) IBOutlet TLTransitionView *tlView;
@end
