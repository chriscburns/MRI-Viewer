//
//  Wrapper.h
//  WrapperTest
//
//  Created by Adrian on 10/18/08.
//  Copyright 2008 Adrian Kosmaczewski. All rights reserved.
//

#import <Foundation/Foundation.h> 


@interface Connection : NSObject 
{
@private
	
	NSString *baseAddress; 
	
	
    NSMutableData *receivedData;
    NSString *mimeType;
    NSURLConnection *conn;
    BOOL asynchronous;

	SEL onRetrieveDataAction;
	id onRetrieveDataTarget;
	
	
	BOOL fileDownload; 
	NSString *fileName; 
	
	
	
	BOOL didFailWithError;
	BOOL didFaceAuthenticationChallenge;
	int didGetStatusCode;

}


@property (nonatomic, readonly) NSData *receivedData;
@property (nonatomic) BOOL asynchronous;
@property (nonatomic, copy) NSString *mimeType;
@property (nonatomic) SEL onRetrieveDataAction;
@property (nonatomic,retain) id onRetrieveDataTarget;


@property (nonatomic) int didGetStatusCode;
@property (nonatomic) BOOL didFailWithError;
@property (nonatomic) BOOL didFaceAuthenticationChallenge;

@property (nonatomic, retain) NSString* fileName; 
@property (nonatomic) BOOL fileDownload; 

- (id) initWithRetrieveTarget:(id)targetObject andRetrieveAction:(SEL)actionSelector;
//+(NSString *) baseAddress;




- (void)sendWithMethod:(NSString *) method usingVerb: (NSString*) verb andParameters: (NSArray *) parameters; 
- (void)sendRequestTo:(NSURL *)url usingVerb:(NSString *)verb withParameters:(NSDictionary *)parameters;


//(TODO) These all need to be removed, since they have been replaced by 
- (void)uploadData:(NSData *) data toURL:(NSURL *) url;
- (void)uploadData:(NSData *)data withMethod: (NSString *) method andParameters: (NSArray *) parameters;
- (void)uploadMultipartData:(NSData *)data withName:(NSString *) name ofType:(NSString *) fileType;



- (void)cancelConnection;

@end

