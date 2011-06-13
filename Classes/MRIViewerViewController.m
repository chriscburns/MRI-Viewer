//
//  MRIViewerViewController.m
//  MRIViewer
//
//  Created by Chris Burns on 11-06-09.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MRIViewerViewController.h"
#import "MRIViewerAppDelegate.h"


@implementation MRIViewerViewController


@synthesize scroll; 










// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	
	
	//scroll = [[UIScrollView alloc] init]; 
	scroll.scrollEnabled = YES; 
	scroll.pagingEnabled = YES;
	scroll.directionalLockEnabled = YES;
	scroll.showsVerticalScrollIndicator = NO;
	scroll.showsHorizontalScrollIndicator = NO;
	scroll.delegate = self;
	scroll.backgroundColor = [UIColor blueColor];
	scroll.autoresizesSubviews = YES;
	
	scroll.maximumZoomScale = 3; 
	scroll.minimumZoomScale = 1; 
	
	v1 = [[UIImageView alloc] init]; 
	v1.frame = CGRectMake(0, 0, 768, 1024);
	v1.image = [UIImage imageNamed:@"ants.jpg"]; 
	
	[scroll addSubview:v1]; 
	
	v2 = [[UIImageView alloc] init]; 
	v2.frame = CGRectMake(768,0,768,1024);
	v2.image = [UIImage imageNamed:@"watch.jpg"]; 
	[scroll addSubview:v2]; 
	
	
	scroll.contentSize = CGSizeMake(2*768,1024);
	[self.view addSubview:scroll]; 

	
	
	counter = 2; 
	
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
	
	
	UIImageView *testImage = [[UIImageView alloc] init]; 
	testImage.frame = CGRectMake(counter *768, 0, 768, 1024);
	testImage.image = [UIImage imageNamed:@"watch.jpg"]; 
	
	
	[scroll addSubview:testImage]; 
	
	scroll.contentSize = CGSizeMake((counter +1) * 768, 1024); 
	
	
	[scroll setContentOffset:CGPointMake(counter*768, 0) animated:YES]; 
	
	counter++; 
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
