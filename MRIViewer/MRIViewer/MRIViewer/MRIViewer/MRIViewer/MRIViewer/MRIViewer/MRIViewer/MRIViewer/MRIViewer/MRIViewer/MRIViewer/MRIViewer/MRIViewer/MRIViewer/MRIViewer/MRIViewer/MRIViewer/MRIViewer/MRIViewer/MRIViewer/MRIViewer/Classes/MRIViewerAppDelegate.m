//
//  MRIViewerAppDelegate.m
//  MRIViewer
//
//  Created by Chris Burns on 11-06-09.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MRIViewerAppDelegate.h"
#import "MRIViewerViewController.h"
#import "MethodSender.h" 
#import	"MethodReceiver.h" 
#import "NSString+UtilityCategory.h"

@implementation MRIViewerAppDelegate

@synthesize window;
@synthesize viewController;
@synthesize sender; 
@synthesize receiver; 

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
	
	//Send a request to server for a port number to setup socket connections 
	sender = [[MethodSender alloc] init];
	[sender registerDevice:self andSelector:@selector(setupMethodReceiver:)]; //target = self, action = setupMethodReceiver
	
	
    // Override point for customization after app launch. 
    [self.window addSubview:viewController.view];
    [self.window makeKeyAndVisible];

	return YES;
}



/* Setup Method Receiver -  Receives from the Server a valid port number that corresponds to a socket created 
 for it's use. A method receiver will then access this port and listen on it for new MethodCalls*/
- (void) setupMethodReceiver: (NSData*) portAsData {
	
	//[hud hide:YES]; 
	
	NSString *portAsString = [[[NSString alloc] initWithData:portAsData encoding:NSUTF8StringEncoding] deserializeString]; 
	
	//Instantiate the receiver object using the port returned from the server
	receiver = [[MethodReceiver alloc] initWithPort:[portAsString integerValue]];
	[receiver startReceiving]; //Begins receiving 
	
	//For the current view the returned port may have arrived after the view controller was loaded. Call it's "registerAsMethodResponder" method
	[viewController registerAllListeners];
	
	
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}


@end
