//
//  ImagePreviewController.h
//  GridView
//
//  Created by midhun on 08/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ImagePreviewController : UIViewController {
	UIImage		* previewImage_;
	UIImageView	* previewImageView_;

}

@property (nonatomic, retain)			UIImage		* previewImage;
@property (nonatomic, retain) IBOutlet	UIImageView	* previewImageView;

-(IBAction)backButtonPressed:(id)sender;

@end
