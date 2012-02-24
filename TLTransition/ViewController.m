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
    
    self.tlView = [[[TLTransitionView alloc] initWithFrame:self.view.bounds] autorelease];
    [self.view addSubview:tlView];
       
}

- (void)viewDidUnload
{
    [self setTlView:nil];
    [super viewDidUnload];
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
    tlView.delegate = self;
    self.currentView= [self viewForPageIndex:pageIndex];
    currentView.frame = tlView.bounds;
    [tlView addSubview:currentView]; 
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
    [tlView release];
    [currentView release];
    [super dealloc];
}

#pragma mark - Selectors
-(void)tapped:(UITapGestureRecognizer *) recognizer  {
    if ([recognizer locationInView:tlView].x > tlView.bounds.size.width/2.0) {
        pageIndex++;
        tlView.transition.directionType = TLDirectionLeft;
    }else {
        pageIndex--;
        tlView.transition.directionType = TLDirectionRight;
    }
    
    
    [tlView createBeginContentWithView:tlView];
    [tlView createEndContentWithView:[self viewForPageIndex:pageIndex]];
    [tlView setProgress:1.0 duration:1.0];
}

#pragma mark - TLTransitionView Delegate Methods
- (BOOL)shouldFinishTransition:(TLTransitionView *)transitionView {
    [currentView removeFromSuperview];
    self.currentView = [self viewForPageIndex:pageIndex];
    currentView.frame = tlView.bounds;
    [tlView addSubview:currentView];
    
    return YES;
}

- (void)transitionDidFinished:(TLTransitionView *)transitionView {
    NSLog(@"transition did finished");
    
}
@end
