//
//  Grid.h
//  Gridview
//
//  Created by midhun on 09/07/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GridCache.h"

typedef struct {
	NSInteger row;
	NSInteger column;
} GridIndex;

@protocol GridDelegate;
@protocol GridCellDelegate;

@interface GridCell : UITableViewCell<ReusableView> {
	id			_delegate;
	GridIndex	_index;
	NSString	*reuseGridIdentifier;
	UIButton	*_cellButton;
		
}

@property (nonatomic, assign)	NSObject <GridCellDelegate> * delegate;
@property						GridIndex					index;
@property (nonatomic, retain)   UIButton					*cellButton;


- (id)initWithStyle:(UITableViewCellStyle)style reuseGridIdentifier:(NSString *)reuseIdentifier;
- (void)cellDidSelected;

@end

@protocol GridCellDelegate <NSObject>

@optional
- (void)cellDidSelectedAtIndex:(GridIndex)index;

@end

@interface Grid : UIView <GridCellDelegate>{
	
	id			_delegate;
	
	NSInteger	_rows;
	NSInteger	_cols;
	NSInteger	_horizontalSpacing; // defaults to 5
	NSInteger	_verticalSpacing; // defaults to 5
	NSInteger	_cellWidth; // defaults to 100
	NSInteger	_cellHeight; // defaults to 100
	NSInteger	_minRows;
	NSInteger	_minCols;
	CGFloat		_scaleFactor;
	BOOL		_isLoading;

}

@property (nonatomic, assign)	NSObject <GridDelegate> * delegate;
@property						NSInteger cellWidth;
@property						NSInteger cellHeight;
@property						NSInteger minRows;
@property						NSInteger minCols;
@property						CGFloat scaleFactor;

- (void) reloadGridForSize:(CGSize)size withOffset:(CGPoint)offset;
- (void) addCellToGrid:(GridCell *)cell atGridIndex:(GridIndex)index;
- (CGPoint) pointInsideGridForIndex:(GridIndex)index;
- (void) loadContentForSize:(CGSize)size  withOffset:(CGPoint)offset;
- (BOOL) findCellWithIndexInGrid:(GridIndex)index;
- (void) removeCellWithMinimumIndex:(GridIndex)minimumIndex maximumIndex:(GridIndex)maximumIndex;
- (GridIndex) findMaximumGridIndexForSize:(CGSize)size withOffset:(CGPoint)offset withMinimumIndex:(GridIndex)minimumIndex;
- (GridIndex) findMinimumGridIndexForSize:(CGSize)size withOffset:(CGPoint)offset;
- (GridCell *)cellWithGridIndex:(GridIndex)index;
- (void)removeAllSubviews;



@end

@protocol GridDelegate <NSObject>

- (NSInteger)numberOfRowsInGridView;
- (NSInteger)numberOfColumnsInGridView;
- (GridCell *)cellForGridAtGridIndex:(GridIndex)index;

@optional

- (CGFloat)heightForCellInGridView;
- (CGFloat)widthForCellInGridView;
- (CGFloat)horizontalSpacingForGrid;
- (CGFloat)verticalSpacingForGrid;
- (void)cellDidSelectedAtGridIndex:(GridIndex)index;
- (void)cellDidDoubleTappedAtGridIndex:(GridIndex)index;

@end


