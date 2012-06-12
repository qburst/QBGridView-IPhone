//
//  GridView.m
//  Gridview
//
//  Created by midhun on 09/07/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GridView.h"


@implementation GridView

@synthesize gridDelegate = _gridDelegate;
@synthesize grid = _grid;

- (id)init {
	
	if (self = [super init]) {
		[self initGrid];
	}
	
	return self;
}
/*
 Initialization function with frame
 */
- (id)initWithFrame:(CGRect)frame {
	
	if ((self = [super initWithFrame:frame])) {
		[self initGrid];
			[_grid reloadGridForSize:self.frame.size withOffset:CGPointZero];
    }
    return self;
}
/*
 To set the frame of the grid view.
 */
- (void)setFrame:(CGRect) frame {
	
	[super setFrame:frame];
	
	[_grid reloadGridForSize:self.frame.size withOffset:CGPointZero];	
}
/*
 To Initialize the grid.
 */

- (void)initGrid {
	
	_grid = [[Grid alloc] init];
	_grid.delegate = self;
	_grid.scaleFactor = 1.0;
	[self addSubview:_grid];
	self.contentSize = _grid.frame.size;
	self.delegate = self;
	self.minimumZoomScale = 1.0;
	self.maximumZoomScale = 1.0;
	_zoomScale = 1.0;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

- (void)dealloc {
    [super dealloc];
}

#pragma mark Functions

/*
 To zoom out the cell at a perticular index.
 */
- (void)zoomOutToCellAtGridIndex:(GridIndex)index animated:(BOOL)animated {
	
	CGRect zoomRect ;
	CGPoint point = [_grid pointInsideGridForIndex:index];
	
	
	_zoomScale = 1.0;
	_grid.scaleFactor = 1.0;
	_zooming = YES;
	
	zoomRect.origin.x = point.x+(_grid.cellWidth/2)-(self.frame.size.width/(2*_zoomScale));
	zoomRect.origin.y = point.y+(_grid.cellHeight/2)-(self.frame.size.height/(2*_zoomScale));
	zoomRect.size.width = self.frame.size.width/_zoomScale;
	zoomRect.size.height = self.frame.size.height/_zoomScale;
	
	[self zoomToRect:zoomRect animated:animated];
	
	self.contentSize = _grid.frame.size;
	
	self.minimumZoomScale = 1.0;
	self.maximumZoomScale = 1.0;
	
	
}

/*
 to zoom in the cell at a perticular index.
 */
- (void)zoomInToCellAtGridIndex:(GridIndex)index animated:(BOOL)animated {
	
	CGPoint point = [_grid pointInsideGridForIndex:index];	
	
	CGRect zoomRect ;
	
	
	self.minimumZoomScale = 1.0;
	self.maximumZoomScale = 30.0;
	
	_zooming = YES;
	_zoomScale = 3.5;
	_grid.scaleFactor = 3.5;
	
	zoomRect.origin.x = point.x+(_grid.cellWidth/2)-(self.frame.size.width/(2*_zoomScale));
	zoomRect.origin.y = point.y+(_grid.cellHeight/2)-(self.frame.size.height/(2*_zoomScale));
	zoomRect.size.width = self.frame.size.width/_zoomScale;
	zoomRect.size.height = self.frame.size.height/_zoomScale;
	[self zoomToRect:zoomRect animated:animated];
	
	
}
/*
 To get the minimum no of rows of the grid view.
 */
- (NSInteger)minimumNumberOfRows {
	return _grid.minRows;
}
/*
 To get the minimum no of colomns of the grid view.
 */
- (NSInteger)minimumNumberOfColumns {
	return _grid.minCols;
}

/*
 To scroll the grid view to the perticular grid index.
 */
- (void)scrollToCellAtGridIndex:(GridIndex)index animated:(BOOL)animated {
	
	CGPoint point = [_grid pointInsideGridForIndex:index];
	
	if (_zoomScale == 1.0) {
		if (point.x+(_grid.cellWidth) < self.frame.size.width ) {
			
			
			if (index.column > 0) {
				
				CGFloat horizontalSpacing = [self horizontalSpacingForGrid];
				CGFloat cols = [self numberOfColumnsInGridView];
				
				CGFloat remainingWidth = (cols-index.column-1)*(horizontalSpacing+_grid.cellWidth)+horizontalSpacing+_grid.cellWidth/2;
				
				if (remainingWidth > self.frame.size.width) {
					if (point.x > self.frame.size.width/2) {
						point.x = point.x - (self.frame.size.width /2) + (_grid.cellWidth / 2);
					} else {
						point.x = 0;
					}
					
				}
				else {
					point.x = 0;
				}
				
				
			} else {
				point.x = 0;
			}
			
			
		} else {
			point.x = point.x - (self.frame.size.width / 2) + (_grid.cellWidth / 2);
			
		}
		
		if ((self.contentSize.width - point.x) < self.frame.size.width ) {
			point.x = (self.contentSize.width - self.frame.size.width);
		} 
		
		
		
		
		if (point.y+(_grid.cellHeight) < self.frame.size.height) {
			
			if (index.column > 0) {
				
				CGFloat verticalSapcing = [self verticalSpacingForGrid];
				CGFloat rows = [self numberOfRowsInGridView];
				
				CGFloat remainingHeight = (rows-index.row-1)*(verticalSapcing+_grid.cellHeight)+verticalSapcing+_grid.cellHeight/2;
				
				if (remainingHeight > self.frame.size.height) {
					if (point.y > self.frame.size.height/2) {
						point.y = point.y - (self.frame.size.height / 2) + (_grid.cellHeight / 2);
					} else {
						point.y = 0;
					}
					
				}
				else {
					point.y = 0;
				}
				
				
			} else {
				point.y = 0;
			}
			
		} else {
			point.y = point.y - (self.frame.size.height / 2) + (_grid.cellHeight / 2);
		}
		
		if ((self.contentSize.height - point.y) < self.frame.size.height) {
			point.y = (self.contentSize.height - self.frame.size.height);
		} 
	} else {
		
		point.x = (point.x+(_grid.cellWidth/2)-(self.frame.size.width/(2*_zoomScale)))*_zoomScale;
		point.y = (point.y+(_grid.cellHeight/2)-(self.frame.size.height/(2*_zoomScale)))*_zoomScale;
		
	}	
	
	[self setContentOffset:point animated:animated];
	
}

/*
 To reload the grid view.
 */
- (void)reloadGrid {
	[_grid removeFromSuperview];
	if (_zoomScale!=1.0) {
		GridIndex index;
		index.row = 0;
		index.column = 0;
		[self zoomOutToCellAtGridIndex:index animated:NO];		
	}
	_lastContentOffset = CGPointMake(-1, -1);
	[_grid removeAllSubviews];
		//[self setContentOffset:CGPointMake(0.0, 0.0) animated:NO];
	[_grid reloadGridForSize:self.frame.size withOffset:self.contentOffset];
	[self addSubview:_grid];
	self.contentSize = _grid.frame.size;
}

/*
 To reuse the grid cell.
 */
- (GridCell *)dequeueReusableGridCellWithIdentifier:(NSString *)reuseIdentifier {
	GridCell * cell = (GridCell *)[[GridCache sharedCache] dequeueReusableViewWithIdentifier:reuseIdentifier];
	return cell;
}


#pragma mark delegate Functions
/*
 To get the number of rows used in the grid view from the delegate method.
 if didn't returns 0.
 */
- (NSInteger)numberOfRowsInGridView {
	if (self.gridDelegate!=nil) {
		return [self.gridDelegate numberOfRowsInGridView:self];
	} 
	return 0;
	
	
	
}

/*
 To get the number of columns used in the grid view from the delegate method.
 if didn't returns 0.
 */
- (NSInteger)numberOfColumnsInGridView {
	if (self.gridDelegate!=nil) {
		return [self.gridDelegate numberOfColumnsInGridView:self];
	} 
	return 0;
	
}
/*
 To get the number of Height of  the grid view from the delegate method.
 if didn't returns 100.
 */

- (CGFloat)heightForCellInGridView {
	if (self.gridDelegate!=nil) {
		if ( [self.gridDelegate respondsToSelector:@selector(heightForCellInGridView:)] )
			return	[self.gridDelegate heightForCellInGridView:self];
	} 		return 100.0;
	
	
}
/*
 To get the number of Width of  the grid view from the delegate method.
 if didn't,returns 100.
 */
- (CGFloat)widthForCellInGridView{
	if (self.gridDelegate!=nil) {
		if ( [self.gridDelegate respondsToSelector:@selector(widthForCellInGridView:)] )
			return	[self.gridDelegate widthForCellInGridView:self];
	}
	return 100.0;
}
/*
 To get the number of Horizontal spacing for  the grid view from the delegate method.
 if didn't,returns 5.
 */
- (CGFloat)horizontalSpacingForGrid {
	if (self.gridDelegate!=nil) {
		if ( [self.gridDelegate respondsToSelector:@selector(horizontalSpacingForGrid:)] )
			return [self.gridDelegate horizontalSpacingForGrid:self];
	} 
	return 5.0;
	
}
/*
 To get the number of Vertical spacing for  the grid view from the delegate method.
 if didn't,returns 5.
 */
- (CGFloat)verticalSpacingForGrid {
	if (self.gridDelegate!=nil) {
		if ( [self.gridDelegate respondsToSelector:@selector(verticalSpacingForGrid:)] )
			return	[self.gridDelegate verticalSpacingForGrid:self];
	} 
	return 5.0;
	
}
/*
 calls when we select a cell at a perticular index.
 calls the delegate method cellDidSelectedAtGridIndex:
 */
- (void)cellDidSelectedAtGridIndex:(GridIndex)index{
	if (self.gridDelegate!=nil) {
		if ( [self.gridDelegate respondsToSelector:@selector(gridView:cellDidSelectedAtGridIndex:)] )
			[self.gridDelegate gridView:self cellDidSelectedAtGridIndex:index];
	}	
}
/*
 to update a cell with a perticular image.
 */

- (void)updateCellAtGridIndex:(GridIndex)index withImage:(UIImage *)cellImage {
	
	GridCell * cell = (GridCell *)[_grid cellWithGridIndex:index];
	if (cell!=nil) {
		[cell.cellButton setImage:cellImage forState:UIControlStateNormal];
	}
	
}

/*
 To get the cell at a perticular index.
 */
- (GridCell *)cellForGridAtGridIndex:(GridIndex)index {
	if (self.gridDelegate!=nil) {
		return [self.gridDelegate gridView:self cellForGridAtGridIndex:index];
	} 
	return nil;	
}
/*
 Calls when the grid view scrolls. Its a grid view delegate method.
 */

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

 	if (!_zooming) {
		CGPoint effectiveOffset = CGPointMake(self.contentOffset.x/_zoomScale, self.contentOffset.y/_zoomScale);
		if ((_lastContentOffset.x==-1&&_lastContentOffset.y==-1)||abs((int)(effectiveOffset.x-_lastContentOffset.x))>=_grid.cellWidth||abs((int)(effectiveOffset.y-_lastContentOffset.y))>=_grid.cellHeight) {
			_lastContentOffset = effectiveOffset;
			[_grid reloadGridForSize:self.frame.size withOffset:effectiveOffset];
			CGRect effectiveGridFrame = CGRectMake(0.0, 0.0, _grid.frame.size.width*_zoomScale, _grid.frame.size.height*_zoomScale);
			_grid.frame = effectiveGridFrame;
			
		}
		
	} 
}
/*
 Calls after the grid view Zooming ends. Its a grid view delegate method.
 */
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale {
	_zooming = NO;
	//	_autoScrolling = YES;
	CGPoint effectiveOffset = CGPointMake(self.contentOffset.x/_zoomScale, self.contentOffset.y/_zoomScale);
	[_grid reloadGridForSize:self.frame.size withOffset:effectiveOffset];
	CGRect effectiveGridFrame = CGRectMake(0.0, 0.0, _grid.frame.size.width*_zoomScale, _grid.frame.size.height*_zoomScale);
	_grid.frame = effectiveGridFrame;
}
/*
 Calls after the grid view scrolling ends. Its a grid view delegate method.
 */
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
	if (self.gridDelegate!=nil) {
		if ( [self.gridDelegate respondsToSelector:@selector(gridViewDidEndDecelerating)] )
			[self.gridDelegate gridViewDidEndDecelerating];
	} 
}
//Updated changes --------
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
	
	if (self.gridDelegate!=nil) {
		if ( [self.gridDelegate respondsToSelector:@selector(gridViewWillBeginDecelerating)] )
			[self.gridDelegate gridViewWillBeginDecelerating];
	} 
}// called on finger up as we are moving
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
	
}
//--------
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
	return _grid;
}

@end
