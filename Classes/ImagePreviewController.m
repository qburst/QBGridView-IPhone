    //
//  ImagePreviewController.m
//  GridView
//
//  Created by midhun on 08/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ImagePreviewController.h"


@implementation ImagePreviewController

@synthesize previewImage = previewImage_;
@synthesize previewImageView = previewImageView_;
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.

- (id) init {
	
	self = [super initWithNibName:@"ImagePreviewController" bundle:[NSBundle mainBundle]];
	if (self != nil) {
		
	}
	return self;
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	previewImageView_.image = previewImage_;
	self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return NO;
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[previewImage_ release];
	[previewImageView_ release];
    [super dealloc];
}

-(IBAction)backButtonPressed:(id)sender {
	[self dismissModalViewControllerAnimated:YES];
}

@end
