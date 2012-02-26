#TLTransition
[AFKpageFlipper](https://github.com/mtabini/AFKPageFlipper) and [HMGLTransitions](https://github.com/Split82/HMGLTransitions) are both provide very good UIView transitions. However AFKpageFlipper only supports flip animation, and HMGLTransitions are based on OpenGL ES, which is difficult for most people to follow (like me). So the TLTransition is here.


##Usage
Using TLTransition is very simple, you will need to perform these steps:

- Include TLTransitionManager and TLTransition classes.
- Include the TLTransition subclass you want to use.
- Import the Quartz Core framework into your project.

And now you can use TLTransitionManager to provide transitions on UIView instance like this:

	TLTransitionManager *manager = [TLTransitionManager sharedManager];
	TLTransition *transition = [[][TLRevealTransition alloc] init] autorelease];
	manager.transition = transition;
	
	[manager createTransitionOnView: The Current View];
	UIView *nextView = The Next View;
	[manager createEndContentWithView:nextView];
	[manager setProgress:1.0 duration:1.0];
	

##Delegate
There are two delegate methods you can use:

	- (void)transitionWillTerminate:(TLTransitionManager *)transitionManager
	
which is called when the CALayer will remove from the current view.

	- (void)transitionDidTerminated:(TLTransitionManager *)transitionManager
	
which is called when the CALayer is removed from the current view


**please check the sample code to get more information.**