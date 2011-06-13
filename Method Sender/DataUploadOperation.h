//
//  FileUploadOperation.h
//  SMARTDemo
//
//  Created by Chris Burns on 10-07-27.
//  Copyright 2010 University of Calgary. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Connection.h"

@interface DataUploadOperation : NSOperation {

	
	
	NSData *data; 
	NSInteger bytesPerTransfer;
	NSString *type; 
	NSString *name;
	BOOL running; 
	
	id callbackTarget; //The callback may be called multiple times as the multiple internal functions return data.
	SEL callbackAction;

}

@property(retain) NSData *data; 
@property  NSInteger bytesPerTransfer;
@property(retain) NSString *type;
@property(retain) NSString *name;

@property(retain) id callbackTarget; 
@property SEL callbackAction; 

- (void)main;
//- (BOOL)isConcurrent;
//- (BOOL) isExecuting; 
//- (BOOL) isFinish;
- (void) cancel;

@end
