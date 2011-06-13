//
//  MRIViewerAppDelegate.h
//  MRIViewer
//
//  Created by Chris Burns on 11-06-09.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MethodSender;
@class MethodReceiver;
@class MRIViewerViewController;

@interface MRIViewerAppDelegate : NSObject <UIApplicationDelegate> {

	MethodSender *sender; 
	MethodReceiver *receiver; 
	
	
    UIWindow *window;
    MRIViewerViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet MRIViewerViewController *viewController;


@property (nonatomic, assign) MethodSender *sender; 
@property (nonatomic, assign) MethodReceiver *receiver; 



@end

