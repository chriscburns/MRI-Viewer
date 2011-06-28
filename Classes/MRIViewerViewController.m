//
//  MRIViewerViewController.m
//  MRIViewer
//
//  Created by Chris Burns on 11-06-09.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MRIViewerViewController.h"
#import "MRIViewerAppDelegate.h"
#import <QuartzCore/QuartzCore.h>

@implementation MRIViewerViewController


@synthesize scroll; 




#define IMG_WIDTH 768
#define IMG_HEIGHT 624





// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	
	
	//scroll = [[UIScrollView alloc] init]; 
	scroll.scrollEnabled = YES; 
	scroll.pagingEnabled = YES;
	scroll.directionalLockEnabled = YES;
	scroll.showsVerticalScrollIndicator = NO;
	scroll.showsHorizontalScrollIndicator = NO;
	scroll.delegate = self;
	scroll.backgroundColor = [UIColor blackColor];
	scroll.autoresizesSubviews = YES;
	
	scroll.maximumZoomScale = 3; 
	scroll.minimumZoomScale = 1; 
	
	/*
	v1 = [[UIImageView alloc] init]; 
	v1.frame = CGRectMake(0, 0, 768, 1024);
	v1.image = [UIImage imageNamed:@"ants.jpg"]; 
	
	[scroll addSubview:v1]; 
	
	v2 = [[UIImageView alloc] init]; 
	v2.frame = CGRectMake(768,0,768,1024);
	v2.image = [UIImage imageNamed:@"watch.jpg"]; 
	[scroll addSubview:v2]; 
	
	*/
	
	//scroll.contentSize = CGSizeMake(2*768,1024);
	[self.view addSubview:scroll]; 

	
	
	counter = 0; 
	
	[super viewDidLoad];
	
	
	
}


- (void) registerAllListeners {
	
	MRIViewerAppDelegate *delegate = (MRIViewerAppDelegate *) [[UIApplication sharedApplication] delegate];
	
	//Register to listen for method calls 
	[[[delegate receiver] methodResponders] addObject:self]; //Add self to the list of method responders
	
	//Register to listen for received data (as in requested files)
	[[[delegate sender] dataReceivedListeners] addObject:self]; //Add self to the list of file received listeners
	
}







- (IBAction) buttonPressed {
	
	
	MRIViewerAppDelegate *delegate = (MRIViewerAppDelegate *) [[UIApplication sharedApplication] delegate];
	
	[delegate.sender receiveData:@"mripicture.png"]; 
	
}







- (void) onDataReceived:(NSArray *) fileDataAndName {
	
	//Received Data 
	NSLog(@"Image Received: %@", [fileDataAndName objectAtIndex:0]);
	
	
	[self loadImageIntoScroll:[UIImage imageWithData:[fileDataAndName objectAtIndex:1]]]; 
	
	
	
}


- (void) loadImageIntoScroll: (UIImage *) mriImage {
	
	
	
	UIImageView *testImage = [[UIImageView alloc] init]; 
	testImage.frame = CGRectMake(counter * IMG_WIDTH, 0, IMG_WIDTH, IMG_HEIGHT);
	testImage.image = mriImage; 	
	
	[scroll addSubview:testImage]; 
	
	scroll.contentSize = CGSizeMake((counter +1) * IMG_WIDTH, IMG_HEIGHT); 
	
	
	[scroll setContentOffset:CGPointMake(counter*IMG_WIDTH, 0) animated:YES]; 
	
	counter++; 

	
}


//Used to determine that the scroll view's associated patient and date should change
- (void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {

	
	patientLabel.text = @"Jack Black"; 
	
	//Set the current time .... 
	NSDate *now = [NSDate date];
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setTimeStyle:NSDateFormatterShortStyle];
	dateLabel.text = [formatter stringFromDate:now]; 


}



// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
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
    [super dealloc];
}

@end
