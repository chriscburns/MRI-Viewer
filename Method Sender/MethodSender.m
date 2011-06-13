//
//  API.m
//  iPhoneWrapperTest
//
//  Created by Chris Burns on 10-06-07.
//  Copyright 2010 University of Calgary. All rights reserved.
//

#import "MethodSender.h"


@implementation MethodSender


//@synthesize deviceID; 
@synthesize connections;
@synthesize dataReceivedListeners; 



// (TODO) All these methods need to be adding their connection objects to the set ... ugh. 
// (TODO) Add pragma marks to detail proper breakdown of functions

#pragma mark -
#pragma mark Constructor & Class Methods

- (id) init 
{
	
	if (self = [super init]) 
	{
		connections = [[NSMutableSet alloc] init];
		operationQueue = [[NSOperationQueue alloc] init];
		dataReceivedListeners = [[NSMutableArray alloc] init];

	}
	
	
	return self;
	
	
}

- (void ) dealloc 
{
	[operationQueue release];
	[connections release];
	[dataReceivedListeners release]; 
	[super dealloc];
	
}

/* Testing Methods */

- (void) testString {
	
	NSLog(@"Test String activated"); 
	
	Connection *connect = [[Connection alloc] init];
	
	[connect sendWithMethod:@"iphonetest" usingVerb:@"GET" andParameters:nil];
	
}


- (void) onTestStringReturn:(NSData *)data {
	
	
	
	
	
}






#pragma mark -
#pragma mark Register Device Methods





/* registerDevice will send out a request to register the device. Since the only information
 required (the UUID) is already included we do not need any parameters
 */
- (void) registerDevice: (id) target andSelector: (SEL) selector
{


	//Because the port number is required we route the target and action we originally recieve 
	Connection *con = [[Connection alloc]	initWithRetrieveTarget:target 
											andRetrieveAction:selector];
	
	
		
	[con sendWithMethod:@"register" usingVerb:@"POST" andParameters:nil];
	
	
	[connections addObject:con];
	
	
	
}

/* 
- (void) onRegisterDeviceReturn: (NSData *) data {
	
	
	
	NSLog(@" %@ ", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
	
	
	
	
}
 */



/* deregisterDevice will send out a request to deregister the device. Since the only information
 required (the UUID) is already included we do not need any parameters
 */
- (void) deregisterDevice 
{
	/*Since we do not need a return no onDataRetrieved targets or actions are needed*/
	Connection *con = [[Connection alloc] initWithRetrieveTarget:nil andRetrieveAction:nil];
	
	
	[con sendWithMethod:@"deregister" usingVerb:@"POST" andParameters:nil];
	
	
	[connections addObject:con];
	

}



#pragma mark -
#pragma mark File Transfer Methods




/* sendJPEG - This is a convenience method that converts a JPEG image to an NSData, created the DataUploadOperation and then schedules it in the 
 * operation queue automatically. */
- (void) sendJPEG:(UIImage *)image withName:(NSString *) name {
	

	//Create a DataUploadOperation and set all the required values
	DataUploadOperation *op = [[DataUploadOperation alloc] init]; 
	
	op.name= name; 
	op.type = @"jpg"; 
	op.data = UIImageJPEGRepresentation(image, 1.0);
	
	
	//Schedule the operation using the 
	[operationQueue addOperation:op];
	
	
	
}

/* sendPNG- This is a convenience method that converts a PNG image to an NSData, created the DataUploadOperation and then schedules it in the 
 * operation queue automatically. */
- (void) sendPNG:(UIImage *)image withName:(NSString *) name {
	
	
	//Create a DataUploadOperation and set all the required values
	DataUploadOperation *op = [[DataUploadOperation alloc] init]; 
	
	op.name= name; 
	op.type = @"png"; 
	op.data = UIImagePNGRepresentation(image);
	
	
	//Schedule the operation using the 
	[operationQueue addOperation:op];
	
	
	
}

- (void) sendDataFromPath: (NSString *) path {
	
	
	//Parse values from path string 
	
	
	//Seperate out the name which is after the last "/" then divide the name + type based on the presence of the "." character
	NSArray *componentsOfName = [[[path componentsSeparatedByString:@"/"] lastObject] componentsSeparatedByString:@"."];
	
	NSString *name = [componentsOfName objectAtIndex:0];
	NSString *type = [componentsOfName lastObject]; 
	
	
	
	//Get data from path
	NSData *pathData = [NSData dataWithContentsOfFile:path];
	
	//Create the DataUploadOperation and set all the required parameters
	
	DataUploadOperation *op = [[DataUploadOperation alloc] init];
	
	op.name = name;
	op.type = type;
	op.data = pathData; 
	
	[operationQueue addOperation:op]; 
	
	
	
} 

/* receiveData - This method (which will often be called from the server) will request data or a file that is waiting for the particular iOS device. The data
 * is then sent back as an array of bytes or an NSData. When the download is complete the method onReceiveData is called. */
- (void) receiveData:(NSString *)filename {
	
	
	
	
	Connection *outgoing = [[Connection alloc] initWithRetrieveTarget:self andRetrieveAction:NSSelectorFromString(@"onReceiveDataReturn:")];
	
	outgoing.fileDownload = YES;
	outgoing.fileName = filename; 
	
	[outgoing sendWithMethod:@"download" usingVerb:@"GET" andParameters:[NSArray arrayWithObjects:filename, nil]];
	
	
	[connections addObject:outgoing]; 
	
	
	
}


/* onReceiveDataReturn - This method is a callback method for receiveData and is called once the data has been properly downloaded. Since many applications may 
 * need to be notified about data arriving from the server a set of listeners is notified everytime this method is called. */
- (void) onReceiveDataReturn:(NSArray *)fileDataAndName{
	
	
	NSLog(@"Received Data with name: %@ and size: %d",[fileDataAndName objectAtIndex:0],[[fileDataAndName objectAtIndex:1] length]);
	
	
	SEL dataReceivedCallbackSelector = NSSelectorFromString(@"onDataReceived:");
	int dataReceivedListenerCount = 0; 
	for (id potentialListener in dataReceivedListeners) {
		
		
		if ([potentialListener respondsToSelector:dataReceivedCallbackSelector]) {
			
			dataReceivedListenerCount++;
			[potentialListener performSelector:dataReceivedCallbackSelector withObject:fileDataAndName];
			
		}
	
	}
	
	if( dataReceivedListenerCount == 0) {
		
		NSException *noDataListenerException = [NSException exceptionWithName:@"No Data Received Listeners Exception" 
																	   reason:@"No listeners were found register to respond to data that arrived"
																	 userInfo:nil]; 
	
		[noDataListenerException raise]; 
		
		
		
	}
	
	
}



#pragma mark -
#pragma mark Generic Call, Return And Exception Methods




- (void) callMethod:(NSString *)methodName withParameters:(NSArray *)params andVerb:(NSString *) verb{
	
	
	Connection *outgoing = [[Connection alloc] initWithRetrieveTarget:nil andRetrieveAction:nil];
	

	
	[outgoing sendWithMethod:methodName usingVerb:verb andParameters:params];
	
	
	[connections addObject:outgoing]; 
	
	
	
	
	
	
}



/* onMethodCallReturn - This is called at the completion of the NSInvocationOperation to return values to calling server. The results
 * of the method are returns as an NSArray and all that are paired with it are sent to the server via a REST call through the connection*/
- (void) onMethodCallReturn:(id)returnValue {
	
	
	NSArray *params = (NSArray *) returnValue; 
	
		
	
	
	//We create a Connection object to call the return method on the server. The target/action is left as nil since there will be no return.
	Connection *outgoing = [[Connection alloc] init]; 
	
	
	
	[outgoing sendWithMethod:@"return" usingVerb:@"POST" andParameters:params]; 
	
	
	
	
	
}

/* onMethodCallException: - This method is called whenever there is an exception thrown while the NSInvocationOperation
 * is running. The value of the exception is assumed to be an NSString */
- (void) onMethodCallException:(id)exceptionValue {
	
	
	NSString *exception = (NSString *) exceptionValue; 
	NSArray *exceptionReturn = [NSArray arrayWithObject:exception];
	
	Connection *outgoing = [[Connection alloc] init]; 
	
	
	[outgoing sendWithMethod:@"exception" usingVerb:@"POST" andParameters:exceptionReturn];
	
	
	
}



 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 

@end
