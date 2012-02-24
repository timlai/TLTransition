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
@synthesize tlView;
@synthesize currentView;
#pragma mark - Private Methods
- (UIView *)viewForPageIndex:(int)index {
    
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
    [tlView addGestureRecognizer:gr];
}

- (void)viewDidUnload
{
    [self setTlView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    tlView.delegate = self;
    tlView.delegate = self;
    self.currentView= [self viewForPageIndex:pageIndex];
    currentView.frame = tlView.bounds;
    [tlView addSubview:currentView];     
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [tlView release];
    [currentView release];
    [super dealloc];
}


- (void) panned:(UIPanGestureRecognizer *) recognizer {
    	    
	float translation = [recognizer translationInView:tlView].x;
    
    float progress = 0.0;
    if ((translation) > 0) {
        progress = translation / tlView.bounds.size.width;
    }else {
        progress = -translation / tlView.bounds.size.width;
    }
        
	switch (recognizer.state) {
		case UIGestureRecognizerStateBegan:
            if (translation > 0) {
                pageIndex--;
                tlView.transition.directionType = TLDirectionRight;
                
            }else {
                pageIndex++;
                tlView.transition.directionType = TLDirectionLeft;
            }            

            [tlView createBeginContentWithView:tlView];
            [tlView createEndContentWithView:[self viewForPageIndex:pageIndex]];
			break;
			
			
		case UIGestureRecognizerStateChanged:
			[tlView setProgress:progress];
			break;
			
			
		case UIGestureRecognizerStateFailed:
            if (tlView.progress > 0.5) {
                [tlView setProgress:1.0 duration:0.5];
            }else {
                [tlView setProgress:0.0 duration:0.5];
            }
			break;
			
		case UIGestureRecognizerStateRecognized:
			if (fabs((translation + [recognizer velocityInView:self.view].x / 4) / self.view.bounds.size.width) > 0.5) {
				[tlView setProgress:1.0 duration:0.5];
			} else {
				[tlView setProgress:0.0 duration:0.5];
			}
            
			break;
		default:
			break;
	}
}

#pragma mark - TLTransitionView Delegate Methods
- (void)transitionDidFinished:(TLTransitionView *)transitionView {
    NSLog(@"transition did finished");
}

- (BOOL)shouldFinishTransition:(TLTransitionView *)transitionView {
    if (transitionView.progress == 0.0) {
        pageIndex = transitionView.transition.directionType == TLDirectionLeft?pageIndex-1:pageIndex+1;
    }else {
        [currentView removeFromSuperview];
        self.currentView = [self viewForPageIndex:pageIndex];
        currentView.frame = tlView.bounds;
        [tlView addSubview:currentView];

    }
    
    NSLog(@"pageindex = %d",pageIndex);
        
    return YES;
}
@end
