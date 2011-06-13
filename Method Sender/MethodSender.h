//
//  API.h
//  
//
//  Created by Chris Burns on 10-06-07.
//  Copyright 2010 University of Calgary. All rights reserved.


#import <Foundation/Foundation.h>
#import "Connection.h"
#import "DataUploadOperation.h"

@interface MethodSender : NSObject{
	
	//NSString *deviceID;
	NSMutableSet *connections;
	NSInteger *bytesPerRequest;
	NSOperationQueue *operationQueue; 
	
	NSMutableArray *dataReceivedListeners; 

}


@property (nonatomic, retain) NSMutableSet *connections;
@property (nonatomic, retain) NSMutableArray *dataReceivedListeners; 



- (void) onMethodCallReturn: (id) returnValues;
- (void) onMethodCallException: (id) exceptionValues;
- (void) callMethod:(NSString *)methodName withParameters:(NSArray *)params andVerb: (NSString *) verb;



- (void) registerDevice: (id) target andSelector: (SEL) selector;
- (void) deregisterDevice;


- (void) testString;
- (void) onTestStringReturn: (NSData *) data; 

- (void) sendJPEG: (UIImage *)image withName:(NSString *) name;
- (void) sendPNG: (UIImage *)image withName:(NSString *) name; 
- (void) sendDataFromPath: (NSString *) path;


- (void) receiveData:(NSString *) filename;
- (void) onReceiveDataReturn: (NSArray *) fileDataAndName;


@end
