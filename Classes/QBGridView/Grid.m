//
//  Grid.m
//  Gridview
//
//  Created by midhun on 09/07/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "Grid.h"

@implementation GridCell

@synthesize delegate	= _delegate;
@synthesize index		= _index;
@synthesize reuseGridIdentifier;
@synthesize cellButton = _cellButton;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        // Initialization code
		
    }
	
    return self;
}
/*
 Grid cell initialization function.
 */
- (id)initWithStyle:(UITableViewCellStyle)style reuseGridIdentifier:(NSString *)reuseIdentifier {
    if ((self = [self initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        // Initialization code
		self.reuseGridIdentifier = [[NSString alloc] initWithString:reuseIdentifier];
		
		_cellButton = [[UIButton alloc] initWithFrame:self.frame];
		_cellButton.frame = CGRectMake(0.0,0.0,202.0,242.0);
		_cellButton.titleLabel.numberOfLines = 2;
		_cellButton.titleLabel.lineBreakMode = UILineBreakModeWordWrap;
		_cellButton.titleLabel.textAlignment = UITextAlignmentCenter;
		[_cellButton addTarget:self action:@selector(cellDidSelected) forControlEvents:UIControlEventTouchDown];

		
				
		self.selectionStyle = UITableViewCellSelectionStyleNone;
		
		[self addSubview:_cellButton];				
				
    }
	
    return self;
}
/*
 calls when we select a cell.
 */
- (void)cellDidSelected {
	
	[self.delegate cellDidSelectedAtIndex:_index];
	
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	
    [super setSelected:selected animated:animated];
		
    // Configure the view for the selected state
}
/*
 If moved to the new cell save the previous cell.
 */
- (void)didMoveToWindow {
	self.window ?
	[[GridCache sharedCache] removeReusableView:(UIView<ReusableView> *)self] :
	[[GridCache sharedCache] enqueueReusableView:(UIView<ReusableView> *)self];
}

- (void)dealloc {
    [super dealloc];
	[reuseGridIdentifier release];
	[_cellButton release];		
	
}


@end

@implementation Grid

@synthesize delegate = _delegate;
@synthesize cellWidth = _cellWidth;
@synthesize cellHeight = _cellHeight;
@synthesize minRows = _minRows;
@synthesize minCols = _minCols;
@synthesize scaleFactor = _scaleFactor;


- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
		_scaleFactor = 1.0;
    }
    return self;
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

/*
 To get the point inside the grid cell.
 */
- (CGPoint) pointInsideGridForIndex:(GridIndex)index {
	CGPoint point;
	
	point.x = ( (index.column + 1) * _horizontalSpacing ) + (index.column * _cellWidth);
	point.y = ( (index.row + 1) * _verticalSpacing ) + (index.row * _cellHeight);
	return point;
}

/*
 To find the minimum grid index.
 */
- (GridIndex) findMinimumGridIndexForSize:(CGSize)size withOffset:(CGPoint)offset {
	
	//Implemented for faster calculation
	GridIndex minimumIndex ;
	minimumIndex.row = 0;
	minimumIndex.column = 0;
	if(CGPointEqualToPoint(offset, CGPointZero))
		return minimumIndex;
	else {
		
		minimumIndex.row = offset.y/(_cellHeight+_verticalSpacing);
		minimumIndex.column = offset.x/(_cellWidth+_horizontalSpacing);
		
	}
	
	if (minimumIndex.row<0) {
		minimumIndex.row =0;
	}
	if (minimumIndex.column<0) {
		minimumIndex.column = 0;
	}
	return minimumIndex;
	
}
/*
 To find the maximum grid index.
 */
- (GridIndex) findMaximumGridIndexForSize:(CGSize)size withOffset:(CGPoint)offset withMinimumIndex:(GridIndex)minimumIndex {
	

	
	//Implemented for faster calculation
	GridIndex maximumIndex;
	maximumIndex = minimumIndex;
	
	if(CGSizeEqualToSize(size,CGSizeZero))
		return maximumIndex;
	else {
		
		maximumIndex.row += (int)size.height/(_cellHeight+_verticalSpacing);
		maximumIndex.column += (int)size.width/(_cellWidth+_horizontalSpacing);
		
	}
	
	if (maximumIndex.row>_rows-1) {
		maximumIndex.row = _rows-1;
	}
	if (maximumIndex.column>_cols-1) {
		maximumIndex.column = _cols-1;
	}
	return maximumIndex;
	
	
	
}
/*
 To remove the cell with minimum index.
 */
- (void) removeCellWithMinimumIndex:(GridIndex)minimumIndex maximumIndex:(GridIndex)maximumIndex {
	
	for (GridCell * oldCell in self.subviews) {		
		if (oldCell.index.row < minimumIndex.row || oldCell.index.column < minimumIndex.column) {
			[oldCell removeFromSuperview];
		} else if (oldCell.index.row > maximumIndex.row || oldCell.index.column > maximumIndex.column) {
			[oldCell removeFromSuperview];
		} 	
	}
	
}

/*
 To check if the cell with index is exist or not.
 */
- (BOOL)findCellWithIndexInGrid:(GridIndex)index {
	
	BOOL cellFound = NO;
	
	for (GridCell * oldCell in self.subviews) {
		if (oldCell.index.row == index.row && oldCell.index.column == index.column) {
			cellFound = YES;
			break;
		}
	}
	
	return cellFound;
}

/*
 To get the cell with Grid index.
 */
- (GridCell *)cellWithGridIndex:(GridIndex)index {
	
	GridCell * cell = nil;
	
	for (GridCell * oldCell in self.subviews) {
		if (oldCell.index.row == index.row && oldCell.index.column == index.column) {
			cell = oldCell;
			break;
		}
	}
	
	return cell;
}

/*
 To remove all the subviews.
 */
- (void) removeAllSubviews {
	
	for (GridCell * cell in self.subviews) {
		[cell removeFromSuperview];
		//[[GridCache sharedCache] enqueueReusableView:cell];
	}
}

/*
 To load the content of the cell.
 */
- (void) loadContentForSize:(CGSize)size withOffset:(CGPoint)offset {
	
	_isLoading = YES;
	GridIndex minimumIndex = [self findMinimumGridIndexForSize:size withOffset:offset];
	GridIndex maximumIndex = [self findMaximumGridIndexForSize:size withOffset:offset withMinimumIndex:minimumIndex];
	
	if (abs(maximumIndex.row - minimumIndex.row) >= _rows-1) {
		
		if (2*size.height < ((_cellHeight+_verticalSpacing)*_rows-_cellHeight)) {
			return;
		}		
		
	}
	
	if (abs(maximumIndex.column - minimumIndex.column) >= _cols-1) {
		
		if (2*size.width < ((_cellWidth+_horizontalSpacing)*_cols-_cellWidth)) {
			return;
		}	
	}
	
	if (maximumIndex.row!=_rows-1) {
		maximumIndex.row +=1;
	}
	
	if (maximumIndex.column!=_cols-1) {
		maximumIndex.column +=1;
	}
	
	if (minimumIndex.row!=0) {
		minimumIndex.row -= 1;
	}
	
	if (minimumIndex.column!=0) {
		minimumIndex.column -= 1;
	}
	
	_minRows = maximumIndex.row-minimumIndex.row;
	_minCols = maximumIndex.column-minimumIndex.column;
	
	[self removeCellWithMinimumIndex:minimumIndex maximumIndex:maximumIndex];
	 
	for (int row = minimumIndex.row ; row <= maximumIndex.row; row++) {	
		for (int col = minimumIndex.column ; col <= maximumIndex.column; col++) {
			GridIndex index;
			index.row = row;
			index.column = col;
			if ([self findCellWithIndexInGrid:index] == NO) {
				
				GridCell * cell = [self.delegate  cellForGridAtGridIndex:index] ;
				
				if (cell!= nil) {
					cell.index = index;
					cell.delegate = self;
					[self addCellToGrid:[cell retain] atGridIndex:index];
					[cell release];
					
				}
			}
		}
	}
	
	_isLoading = NO;
	
}
/*
 To reload the grid.
 */
- (void) reloadGridForSize:(CGSize)size withOffset:(CGPoint)offset{
	
	if (self.delegate==nil) {
		return;
	}
	
	_rows = [self.delegate numberOfRowsInGridView];
	_cols = [self.delegate numberOfColumnsInGridView];
	
	
	if ( _rows == 0 && _cols == 0 )
		return; 
	
	
	if ( [self.delegate respondsToSelector:@selector(horizontalSpacingForGrid)] ) 
		_horizontalSpacing = [self.delegate horizontalSpacingForGrid];
	
	if ( [self.delegate respondsToSelector:@selector(verticalSpacingForGrid)] )
		_verticalSpacing = [self.delegate verticalSpacingForGrid];
	
	
	if ( [self.delegate respondsToSelector:@selector(widthForCellInGridView)] )
		_cellWidth = [self.delegate widthForCellInGridView];
	
	if ( [self.delegate respondsToSelector:@selector(heightForCellInGridView)] )
		_cellHeight = [self.delegate heightForCellInGridView];
	
	
	if (_horizontalSpacing == 0) { // Default value
		_horizontalSpacing = 5;
	}
	
	if (_verticalSpacing == 0) { // Default value
		_verticalSpacing = 5;
	}
	
	if (_cellWidth == 0 ) {  // Default value
		_cellWidth = 100;
	}
	
	if (_cellHeight == 0) {  // Default value
		_cellHeight = 100;
	}
	
		self.frame = CGRectMake(0.0,0.0,(_cols + 1) * _horizontalSpacing + ( _cols * _cellWidth ), (_rows + 1) * _verticalSpacing + ( _rows * _cellHeight ));

			[self loadContentForSize:size withOffset:offset];
		
	
	
}
/*
 To load the content.
 */
- (void)loadContent:(NSString *)frameString {
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	CGRect loadingGridFrame = CGRectFromString(frameString);
	
	CGPoint offset = loadingGridFrame.origin;
	CGSize size = loadingGridFrame.size;
	
	_isLoading = YES;
	GridIndex minimumIndex = [self findMinimumGridIndexForSize:size withOffset:offset];
	GridIndex maximumIndex = [self findMaximumGridIndexForSize:size withOffset:offset withMinimumIndex:minimumIndex];
	
	if (abs(maximumIndex.row - minimumIndex.row) >= _rows-1) {
		
		if (2*size.height < ((_cellHeight+_verticalSpacing)*_rows-_cellHeight)) {
			return;
		}		
		
	}
	
	if (abs(maximumIndex.column - minimumIndex.column) >= _cols-1) {
		
		if (2*size.width < ((_cellWidth+_horizontalSpacing)*_cols-_cellWidth)) {
			return;
		}	
	}
	
	if (maximumIndex.row!=_rows-1) {
		maximumIndex.row +=1;
	}
	
	if (maximumIndex.column!=_cols-1) {
		maximumIndex.column +=1;
	}
	
	if (minimumIndex.row!=0) {
		minimumIndex.row -= 1;
	}
	
	if (minimumIndex.column!=0) {
		minimumIndex.column -= 1;
	}
	
	_minRows = maximumIndex.row-minimumIndex.row;
	_minCols = maximumIndex.column-minimumIndex.column;
	[self performSelectorOnMainThread:@selector(removeCellsInMainThread:) withObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:minimumIndex.row],@"min_row",[NSNumber numberWithInt:minimumIndex.column ],@"min_col",[NSNumber numberWithInt:maximumIndex.row],@"max_row",[NSNumber numberWithInt:maximumIndex.column ],@"max_col",nil] waitUntilDone:NO];
	//[self removeCellWithMinimumIndex:minimumIndex maximumIndex:maximumIndex];
	
	for (int row = minimumIndex.row ; row <= maximumIndex.row; row++) {	
		for (int col = minimumIndex.column ; col <= maximumIndex.column; col++) {
			GridIndex index;
			index.row = row;
			index.column = col;
			if ([self findCellWithIndexInGrid:index] == NO) {
				[self performSelectorOnMainThread:@selector(addCellToGridInMainThread:) withObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:index.row],@"row",[NSNumber numberWithInt:index.column ],@"column",nil] waitUntilDone:NO];
			}
		}
	}
	
	_isLoading = NO;
	
	[pool release];
}

- (void) removeCellsInMainThread:(NSDictionary *)rangeDict {
	
	GridIndex minimumIndex, maximumIndex;
	minimumIndex.row = [[rangeDict objectForKey:@"min_row"] intValue];
	minimumIndex.column = [[rangeDict objectForKey:@"min_col"] intValue];
	maximumIndex.row = [[rangeDict objectForKey:@"max_row"] intValue];
	maximumIndex.column = [[rangeDict objectForKey:@"max_col"] intValue];
	
	[self removeCellWithMinimumIndex:minimumIndex maximumIndex:maximumIndex];
}

- (void) addCellToGridInMainThread:(NSDictionary *)gridIndexDict {
	
	GridIndex index;
	index.row = [[gridIndexDict objectForKey:@"row"] intValue];
	index.column = [[gridIndexDict objectForKey:@"column"] intValue];
	
	GridCell * cell = [self.delegate  cellForGridAtGridIndex:index] ;
	
	if (cell!= nil) {
		cell.index = index;
		cell.delegate = self;
		[self addCellToGrid:[cell retain] atGridIndex:index];
		[cell release];
		
	}
}

- (void) addCellToGrid:(GridCell *)cell atGridIndex:(GridIndex)index {
	
	CGRect cellFrame;
	
	cellFrame.origin.x = ( (index.column + 1) * _horizontalSpacing ) + (index.column * _cellWidth);
	cellFrame.origin.y = ( (index.row + 1) * _verticalSpacing ) + (index.row * _cellHeight);
	cellFrame.size.width = _cellWidth;
	cellFrame.size.height = _cellHeight;
	
		
	[cell setFrame:cellFrame];
	[self addSubview:cell];

	
}

#pragma mark GridCell delegate Functions

- (void)cellDidSelectedAtIndex:(GridIndex)index {
	if ( [self.delegate respondsToSelector:@selector(cellDidSelectedAtGridIndex:)] )
		[self.delegate cellDidSelectedAtGridIndex:index];
}


@end


