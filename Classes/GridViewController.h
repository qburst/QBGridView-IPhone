//
//  GridViewController.h
//  GridView
//
//  Created by midhun on 08/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GridView.h"

@interface GridViewController : UIViewController <GridViewDelegate> {
	GridView			* gridView_;
	NSMutableArray		* imageList_;
}

- (UIImage *)imageForGridIndex:(GridIndex)index;

@end

