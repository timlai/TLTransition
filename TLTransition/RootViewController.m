//
//  RootViewController.m
//  TLTransition
//
//  Created by Tim Lai on 2012/2/18.
//  Copyright (c) 2012年 TiWiTech. All rights reserved.
//

#import "RootViewController.h"
#import "ViewController.h"
#import "GestureViewController.h"

#import "TLRevealTransition.h"
#import "TLFlipTransition.h"
#import "TLMoveInTransition.h"
#import "TLCubeTransition.h"

@implementation RootViewController
@synthesize examples;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)dealloc {
    [examples release];
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    NSArray *section1 = [NSArray arrayWithObjects:@"Reveal",@"Flip",@"MoveIn",@"Cube", nil];
    NSArray *section2 = [NSArray arrayWithObjects:@"Drag to Flip",@"Drag to move in", nil];
    self.examples = [NSArray arrayWithObjects:section1,section2, nil];
}

- (void)viewDidUnload
{
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
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[examples objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    // Configure the cell...
    NSArray *titles = [examples objectAtIndex:indexPath.section];
    cell.textLabel.text = [titles objectAtIndex:indexPath.row];
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.section == 0) {
        ViewController *vc = [[[ViewController alloc] initWithNibName:@"ViewController" bundle:nil] autorelease];
        [self.navigationController pushViewController:vc animated:YES];
        
        TLTransition *transition = nil;
        
        switch (indexPath.row) {
            case 0:
                transition = [[[TLRevealTransition alloc] init] autorelease];
                break;
                
            case 1:
                transition = [[[TLFlipTransition alloc] init] autorelease];
                [(TLFlipTransition *)transition setFlipDirection:TLFlipDirectionRight];
                break;
                
            case 2:
                transition = [[[TLMoveInTransition alloc] init] autorelease];
                break;
            
            case 3:
                transition = [[[TLCubeTransition alloc] init] autorelease];
                break;
                
            default:
                break;
        }
        
        vc.tlView.transition = transition;
    
    }else if (indexPath.section == 1) {
        GestureViewController *vc = [[[GestureViewController alloc] initWithNibName:@"GestureViewController" bundle:nil] autorelease];
        [self.navigationController pushViewController:vc animated:YES];
        
        TLTransition *transition = nil;
        
        switch (indexPath.row) {
            case 0:
                transition = [[[TLFlipTransition alloc] init] autorelease];
                [(TLFlipTransition *)transition setFlipDirection:TLFlipDirectionLeft];
                break;
                
            case 1:
                transition = [[[TLMoveInTransition alloc] init] autorelease];
                break;
            
            default:
                break;
        }
        
        vc.tlView.transition = transition;
    }
}

@end
