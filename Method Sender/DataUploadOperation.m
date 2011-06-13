//
//  FileUploadOperation.m
//  SMARTDemo
//
//  Created by Chris Burns on 10-07-27.
//  Copyright 2010 University of Calgary. All rights reserved.
//

#import "DataUploadOperation.h"


@implementation DataUploadOperation

@synthesize data,bytesPerTransfer,type,name,callbackAction, callbackTarget;




- (void) cancel {
	
	
	
	
}

- (id) init {
	
	
	
	if (self == [super init]) {
		
		
		bytesPerTransfer = 5000; 
		running = NO; 
		callbackAction = nil; 
		callbackTarget = nil;
		
		
	}
	
	return self; 
	
	
	
	
}
- (void) main {
	
	//Create connection object (without a callback target) and set to asynchronous
	Connection *con = [[Connection alloc] initWithRetrieveTarget:callbackTarget	andRetrieveAction:callbackAction];
	con.asynchronous = NO;
	
	

	
	NSString *lengthOfData = [NSString stringWithFormat:@"%d", [data length]];
	
	
	//Begin transfer by calling uploadstart
	[con	sendWithMethod:@"uploadstart" usingVerb:@"POST" 
		  andParameters:[[NSArray alloc] initWithObjects:name,type,lengthOfData, nil]];
	
	
	
	//Divide transfer into chunks and send them seperately
	
	NSInteger transferredBytes = 0;
	NSString *lengthOfTransfer  = nil;
	
	
	while (transferredBytes < [data length]) {
		
		//If the amount remaining is less then the bytesPerTransfer just send the remaining amount
		if (bytesPerTransfer > [data length] - transferredBytes) { bytesPerTransfer = [data length] - transferredBytes;}
		
		//Get the current chunk of data to be transferred [transferredBytes, transferredBytes+bytesPerTransfer] interval
		NSRange range = NSMakeRange(transferredBytes, bytesPerTransfer);
		NSData *chunk = [data subdataWithRange:range];
		
		transferredBytes += bytesPerTransfer;
		lengthOfTransfer = [NSString stringWithFormat:@"%d", bytesPerTransfer];
		
		
		//NSLog(@"Transfer Message %d of %d with  %d sent", transferredBytes,[data length], bytesPerTransfer);
		[con	uploadData:chunk withMethod:@"upload" 
		  andParameters:[[NSArray alloc] initWithObjects:name,type,lengthOfTransfer, nil]];
		
		
		
	}
	
	[con	sendWithMethod:@"uploadfinish" usingVerb:@"POST" 
		  andParameters:[[NSArray alloc] initWithObjects:name,type,nil]];
	
	
	
	
}
@end
