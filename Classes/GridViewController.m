//
//  GridViewController.m
//  GridView
//
//  Created by midhun on 08/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GridViewController.h"
#import "ImagePreviewController.h"

int cellAllocationCount = 0;
@implementation GridViewController


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	imageList_ = [[NSMutableArray alloc] init];
	for (int i=0; i<18; i++) {
		[imageList_ addObject:[UIImage imageNamed:[NSString stringWithFormat:@"img%d.jpg",i+1]]];
	}
	
	gridView_ = [[GridView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height)];
	gridView_.gridDelegate = self;
	[self.view addSubview:gridView_];
	[gridView_ reloadGrid];
	
	self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
}



// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return NO;
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[gridView_ release];
	[imageList_ release];
    [super dealloc];
}

#pragma mark -
#pragma mark GridView Delegate Methods

/** Required methods **/
- (NSInteger)numberOfRowsInGridView:(GridView*)gridView {
	return 10000;//40000 cells
}
- (NSInteger)numberOfColumnsInGridView:(GridView*)gridView {
	return 4;
}
- (GridCell *)gridView:(GridView*)gridView cellForGridAtGridIndex:(GridIndex)index {
	
	static NSString * cellIdentifier = @"CellIdentifier";
	
	GridCell * cell = [gridView dequeueReusableGridCellWithIdentifier:cellIdentifier];
	if (cell==nil) {
		cell = [[[GridCell alloc] initWithStyle:UITableViewCellStyleDefault reuseGridIdentifier:cellIdentifier] autorelease];
		NSLog(@"Cell allocation count = %d",cellAllocationCount+1);
		cellAllocationCount++;
	}
	
	/** customize cell **/
	[cell.cellButton setFrame:CGRectMake(0.0, 0.0,180.0,300.0)];
	[cell.cellButton setBackgroundImage:[self imageForGridIndex:index] forState:UIControlStateNormal];
	
	return cell;
}

/** Optional methods **/

- (CGFloat)heightForCellInGridView:(GridView*)gridView {
	return 300.0;
}
- (CGFloat)widthForCellInGridView:(GridView*)gridView {
	return 180.0;
}
- (CGFloat)horizontalSpacingForGrid:(GridView*)gridView {
	return 9.0;
}
- (CGFloat)verticalSpacingForGrid:(GridView*)gridView {
	return 9.0;
}
- (void)gridView:(GridView*)gridView cellDidSelectedAtGridIndex:(GridIndex)index {
	ImagePreviewController * previewController = [[ImagePreviewController alloc] init];
	previewController.previewImage = [self imageForGridIndex:index];
	[self presentModalViewController:previewController animated:YES];
	[previewController release];
}

- (UIImage *)imageForGridIndex:(GridIndex)index {
	
	NSInteger arrayIndex = index.row * [self numberOfColumnsInGridView:gridView_]+index.column;	
	return [imageList_ objectAtIndex:arrayIndex%18];	
}
@end
