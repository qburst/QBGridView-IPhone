//
//  GridViewAppDelegate.h
//  GridView
//
//  Created by midhun on 08/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GridViewController;

@interface GridViewAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    GridViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) GridViewController *viewController;

@end

