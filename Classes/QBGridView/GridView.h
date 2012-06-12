//
//  GridView.h
//  Gridview
//
//  Created by midhun on 09/07/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Grid.h"

@protocol GridViewDelegate;

@interface GridView : UIScrollView <UIScrollViewDelegate,GridDelegate> {
	id		_gridDelegate;
	Grid	*_grid;
	CGFloat _zoomScale;
	BOOL	_zooming;
	CGPoint _lastContentOffset;
	//BOOL	_autoScrolling;
}

@property (nonatomic, assign)IBOutlet NSObject <GridViewDelegate> * gridDelegate;
@property (nonatomic, readonly) Grid * grid;

- (void)initGrid;
- (void)scrollToCellAtGridIndex:(GridIndex)index animated:(BOOL)animated;
- (void)reloadGrid;
- (GridCell *)dequeueReusableGridCellWithIdentifier:(NSString *)reuseIdentifier;
- (void)zoomInToCellAtGridIndex:(GridIndex)index animated:(BOOL)animated;
- (void)zoomOutToCellAtGridIndex:(GridIndex)index animated:(BOOL)animated;
- (NSInteger)minimumNumberOfRows;
- (NSInteger)minimumNumberOfColumns;

@end


@protocol GridViewDelegate <NSObject>

- (NSInteger)numberOfRowsInGridView:(GridView*)gridView;
- (NSInteger)numberOfColumnsInGridView:(GridView*)gridView;
- (GridCell *)gridView:(GridView*)gridView cellForGridAtGridIndex:(GridIndex)index;

@optional

- (CGFloat)heightForCellInGridView:(GridView*)gridView;
- (CGFloat)widthForCellInGridView:(GridView*)gridView;
- (CGFloat)horizontalSpacingForGrid:(GridView*)gridView;
- (CGFloat)verticalSpacingForGrid:(GridView*)gridView;
- (void)gridView:(GridView*)gridView cellDidSelectedAtGridIndex:(GridIndex)index;
- (void)gridViewWillBeginDecelerating;   // called on finger up as we are moving
- (void)gridViewDidEndDecelerating;

@end
