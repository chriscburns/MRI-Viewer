//
//  MRIViewerViewController.h
//  MRIViewer
//
//  Created by Chris Burns on 11-06-09.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MRIViewerViewController : UIViewController <UIScrollViewDelegate> {
	
	IBOutlet UIScrollView *scroll; 
	
	IBOutlet UIButton *button; 
	
	
	UIImageView *v1; 
	UIImageView *v2; 
	
	int counter; 
}


- (IBAction) buttonPressed; 
- (void) registerAllListeners;
	

@property(nonatomic,retain) IBOutlet UIScrollView *scroll;


@end

