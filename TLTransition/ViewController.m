//
//  ViewController.m
//  TLTransition
//
//  Created by Tim Lai on 2012/2/16.
//  Copyright (c) 2012年 TiWiTech. All rights reserved.
//

#import "ViewController.h"

@interface ViewController(PrivateMethods)
- (UIView *)viewForPageIndex:(int)index;
@end

@implementation ViewController
@synthesize currentView;

#pragma mark - Private Methods
- (UIView *)viewForPageIndex:(int)index {

    NSString *filename = [NSString stringWithFormat:@"%d.jpeg",index%3+1];
    UIImageView *v = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:filename]] autorelease];
    
    return v;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    UITapGestureRecognizer *gr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
    [self.view addGestureRecognizer:gr];
    [gr release];
    
    [TLTransitionManager sharedManager].delegate = self;
    
    self.currentView = [self viewForPageIndex:pageIndex];
    currentView.frame = self.view.bounds;
    currentView.autoresizingMask = self.view.autoresizingMask;
    [self.view addSubview:currentView];
       
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.currentView = nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)dealloc {
    [currentView release];
    [super dealloc];
}

#pragma mark - Selectors
-(void)tapped:(UITapGestureRecognizer *) recognizer  {
    TLTransitionManager *manager = [TLTransitionManager sharedManager];
    
    if ([recognizer locationInView:self.view].x > self.view.bounds.size.width/2.0) {
        pageIndex++;
        manager.transition.directionType = TLDirectionLeft;
    }else {
        pageIndex--;
        manager.transition.directionType = TLDirectionRight;
    }
    
    [manager createTransitionOnView:currentView];
    
    UIView *nextView = [self viewForPageIndex:pageIndex];
    nextView.frame = self.view.bounds;
    [manager createEndContentWithView:nextView];
    [manager setProgress:1.0 duration:1.0];
}

#pragma mark - TLTransitionManager Delegate Methods
- (void)transitionWillTerminate:(TLTransitionManager *)transitionManager {
    [currentView removeFromSuperview];
    self.currentView = [self viewForPageIndex:pageIndex];
    currentView.frame = self.view.bounds;
    [self.view addSubview:currentView];

}

- (void)transitionDidTerminated:(TLTransitionManager *)transitionManager {
    NSLog(@"transition did finished");
}

@end
