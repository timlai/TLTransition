//
//  GestureViewController.m
//  TLTransition
//
//  Created by Tim Lai on 2012/2/20.
//  Copyright (c) 2012年 TiWiTech. All rights reserved.
//

#import "GestureViewController.h"

@interface GestureViewController(PrivateMethods)
- (UIView *)viewForPageIndex:(int)index;
@end

@implementation GestureViewController
@synthesize currentView;

#pragma mark - Private Methods
- (UIView *)viewForPageIndex:(int)index {
    if (index <0) {
        UIView *v = [[[UIView alloc] initWithFrame:self.view.bounds] autorelease];
        v.backgroundColor = [UIColor blackColor];
        return v;
    }
    NSString *filename = [NSString stringWithFormat:@"%d.jpeg",index%3+1];
    UIImageView *v = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:filename]] autorelease];
    
    return v;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIPanGestureRecognizer *gr = [[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panned:)] autorelease];
    [self.view addGestureRecognizer:gr];
    
    [TLTransitionManager sharedManager].delegate = self;
    
    self.currentView= [self viewForPageIndex:pageIndex];
    currentView.frame = self.view.bounds;
    currentView.autoresizingMask = self.view.autoresizingMask;
    [self.view addSubview:currentView];   
}

- (void)viewDidUnload
{
    self.currentView = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [currentView release];
    [super dealloc];
}


- (void) panned:(UIPanGestureRecognizer *) recognizer {
    	    
	float translation = [recognizer translationInView:self.view].x;
    
    float progress = 0.0;
    progress = translation / self.view.bounds.size.width;

    if ([TLTransitionManager sharedManager].transition.directionType == TLDirectionLeft) {
		progress = MIN(progress, 0);
	} else {
		progress = MAX(progress, 0);
	}
    progress = fabsf(progress);
        
    TLTransitionManager *manager = [TLTransitionManager sharedManager];
    
	switch (recognizer.state) {
		case UIGestureRecognizerStateBegan:
            if (translation > 0) {
                pageIndex--;
                manager.transition.directionType = TLDirectionRight;
                
            }else {
                pageIndex++;
                manager.transition.directionType = TLDirectionLeft;
            }            

            [manager createTransitionOnView:currentView];
            UIView *nextView = [self viewForPageIndex:pageIndex];
            nextView.frame = self.view.bounds;
            [manager createEndContentWithView:nextView];
			break;
			
			
		case UIGestureRecognizerStateChanged:
			[manager setProgress:progress];
			break;
			
			
		case UIGestureRecognizerStateFailed:
            if (manager.progress > 0.5) {
                [manager setProgress:1.0 duration:0.5];
            }else {
                [manager setProgress:0.0 duration:0.5];
            }
			break;
			
		case UIGestureRecognizerStateRecognized:
			if (fabs((translation + [recognizer velocityInView:self.view].x / 4) / self.view.bounds.size.width) > 0.5 && pageIndex>=0) {
				[manager setProgress:1.0 duration:0.5];
			} else {
				[manager setProgress:0.0 duration:0.5];
			}
            
			break;
		default:
			break;
	}
}

#pragma mark - TLTransitionManager Delegate Methods
- (void)transitionDidTerminated:(TLTransitionManager *)transitionManager {
    NSLog(@"transition did finished");
}

- (void)transitionWillTerminate:(TLTransitionManager *)transitionManager {
    if (transitionManager.progress == 0.0) {
        pageIndex = transitionManager.transition.directionType == TLDirectionLeft?pageIndex-1:pageIndex+1;
    }else {
        [currentView removeFromSuperview];
        self.currentView = [self viewForPageIndex:pageIndex];
        currentView.frame = self.view.bounds;
        [self.view addSubview:currentView];
        
    }
    
    NSLog(@"pageindex = %d",pageIndex);
}

@end
