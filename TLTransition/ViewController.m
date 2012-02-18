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

#pragma mark - Private Methods
- (UIView *)viewForPageIndex:(int)index {
    NSArray *colors = [NSArray arrayWithObjects:[UIColor blueColor],[UIColor greenColor],[UIColor redColor], nil];
    
    UIView *v = [[[UIView alloc] initWithFrame:self.view.bounds] autorelease];
    v.backgroundColor = [colors objectAtIndex:index%3];
    
    UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, v.bounds.size.width, 100)] autorelease];
    label.text = [NSString stringWithFormat:@"Page %d",index];
    label.center = CGPointMake(v.frame.size.width/2.0, v.frame.size.height/2.0);
    label.textAlignment = UITextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:16];
    
    [v addSubview:label];
    
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
    tlView.currentView = [self viewForPageIndex:pageIndex]; 
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
    [super dealloc];
}

#pragma mark - Selectors
-(void)tapped:(id)sender {
    pageIndex++;
    
    tlView.nextView = [self viewForPageIndex:pageIndex];
    
    [tlView transitTo:1.0 duration:1.0];
}

#pragma mark - TLTransitionView Delegate Methods
- (void)transitionDidFinished:(TLTransitionView *)transitionView {
    NSLog(@"transition did finished");
}
@end
