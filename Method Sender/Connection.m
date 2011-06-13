//
//  Wrapper.m
//  WrapperTest
//
//  Created by Adrian on 10/18/08.
//  Copyright 2008 Adrian Kosmaczewski. All rights reserved.
//

#import "Connection.h"

@interface Connection (Private)
- (void)startConnection:(NSURLRequest *)request;
@end

@implementation Connection

@synthesize receivedData;
@synthesize asynchronous;
@synthesize mimeType;
@synthesize didFailWithError;
@synthesize didGetStatusCode;
@synthesize didFaceAuthenticationChallenge;

@synthesize onRetrieveDataAction;
@synthesize onRetrieveDataTarget;
@synthesize fileDownload; 
@synthesize fileName; 

#pragma mark -
#pragma mark Constructor, Destructor and Class Methods

- (id)init
{
    if(self = [super init])
    {
        receivedData = [[NSMutableData alloc] init];
        conn = nil;
        asynchronous = YES;
        mimeType = @"text/html";
		didFailWithError = NO;
		fileDownload = NO; 
		
		
		//Acquire base address from the configuration file and add device id to form the baseAddress
		
		
		NSString *startAddressFromConfig = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"iOSRC Full Address"];
		
		
		//Check that full address variable was correctly set in the configuration file
		if (startAddressFromConfig == nil) {
			
			NSException *exception = [NSException exceptionWithName:@"Configuration Error" 
															 reason:@"The iOSRC Full Address is likely not configured in the *-Info.plist file" 
														   userInfo:nil];
			
			[exception raise];
			
			
		}
		
		
		
	
		NSMutableString *startAddress = [NSMutableString stringWithString:startAddressFromConfig]; 
		
		[startAddress appendString:[[UIDevice currentDevice] uniqueIdentifier]]; //Append the device uuid
		[startAddress appendString:@"/"];
		baseAddress = startAddress; 
		
		
		
		
		
    }

    return self;
}

 

- (id) initWithRetrieveTarget:(id) targetObject andRetrieveAction:(SEL) actionSelector {
	
	
	
	if (self = [self init]) {
		onRetrieveDataTarget = targetObject;
		onRetrieveDataAction = actionSelector; 
		
	}
	
	return self;
	
	

	
}
- (void)dealloc
{
    [receivedData release];
    receivedData = nil;
    self.mimeType = nil;
    [super dealloc];
}


/*
+ (NSString *) baseAddress
{

	NSMutableString *base = [NSMutableString stringWithString:@"http://172.17.14.69:50010/iOSRemoteConnector/"];
	[base appendString:[[UIDevice currentDevice] uniqueIdentifier]];
	[base appendString:@"/"];
	
	return [NSString stringWithString:base];

}
*/


#pragma mark -
#pragma mark Public Methods






- (void) sendWithMethod:(NSString *)method usingVerb: (NSString *) verb andParameters:(NSArray *)parameters
{
	
	NSMutableString *sendAddress = [NSMutableString stringWithString:baseAddress];
	[sendAddress appendString:method];
	
	NSString *param;
	
	for (param in parameters) {
		[sendAddress appendString:@"/"];
		[sendAddress appendString:param];
	}
	
	
	NSLog(@"Sending with method <%@> with the address <%@>", method, sendAddress); 
	
	[self sendRequestTo:[NSURL URLWithString:sendAddress] usingVerb:verb withParameters:nil];
		  
		 
		 
}


- (void)sendRequestTo:(NSURL *)url usingVerb:(NSString *)verb withParameters:(NSDictionary *)parameters
{
    NSData *body = nil;
    NSMutableString *params = nil;
    NSString *contentType = @"text/html; charset=utf-8";
    NSURL *finalURL = url;
    if (parameters != nil)
    {
        params = [[NSMutableString alloc] init];
        for (id key in parameters)
        {
            NSString *encodedKey = [key stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            CFStringRef value = (CFStringRef)[[parameters objectForKey:key] copy];
            // Escape even the "reserved" characters for URLs 
            // as defined in http://www.ietf.org/rfc/rfc2396.txt
            CFStringRef encodedValue = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, 
                                                                               value,
                                                                               NULL, 
                                                                               (CFStringRef)@";/?:@&=+$,", 
                                                                               kCFStringEncodingUTF8);
            [params appendFormat:@"%@=%@&", encodedKey, encodedValue];
            CFRelease(value);
            CFRelease(encodedValue);
        }
        [params deleteCharactersInRange:NSMakeRange([params length] - 1, 1)];
    }
    
    if ([verb isEqualToString:@"POST"] || [verb isEqualToString:@"PUT"])
    {
        contentType = @"application/x-www-form-urlencoded; charset=utf-8";
        body = [params dataUsingEncoding:NSUTF8StringEncoding];
    }
    else
    {
        if (parameters != nil)
        {
            NSString *urlWithParams = [[url absoluteString] stringByAppendingFormat:@"?%@", params];
            finalURL = [NSURL URLWithString:urlWithParams];
        }
    }

    NSMutableDictionary* headers = [[[NSMutableDictionary alloc] init] autorelease];
    [headers setValue:contentType forKey:@"Content-Type"];
    [headers setValue:mimeType forKey:@"Accept"];
    [headers setValue:@"no-cache" forKey:@"Cache-Control"];
    [headers setValue:@"no-cache" forKey:@"Pragma"];
    [headers setValue:@"close" forKey:@"Connection"]; // Avoid HTTP 1.1 "keep alive" for the connection

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:finalURL
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    [request setHTTPMethod:verb];
    [request setAllHTTPHeaderFields:headers];
    if (parameters != nil)
    {
        [request setHTTPBody:body];
    }
    [params release];
    [self startConnection:request];
}

//(TODO) What is the function below doing? Why is it hard coding data....


/* Multipart Data Transfer 
 Used to send data in chunks of 5kB with pre and post handling calls send to the server */
- (void) uploadMultipartData:(NSData *)data withName:(NSString *) name ofType:(NSString *) fileType
{
	
	//Initialize the transfer using the 
	NSMutableString *base = [NSMutableString stringWithString:@"http://172.17.14.69/WcfRestService4/Service1/iphone/upload/"];

	
	[base appendString:name];
	[base appendString:@"/"];
	[base appendString:fileType];
	
	NSMutableString *start = [[NSMutableString alloc] initWithString:base];
	
	[start appendString:@"/start"];
	
	
	[self sendRequestTo:[NSURL URLWithString:start] usingVerb:@"POST" withParameters:nil];
	NSLog(@"StartUp Message to %@", start); 
	
	NSUInteger transferredBytes = 0;
	NSUInteger transfer = 1000;

	
	while (transferredBytes < [data length]) {

		if (transfer > [data length] - transferredBytes) { transfer = [data length] - transferredBytes;}

		NSRange range = NSMakeRange(transferredBytes, transfer);
		NSData *chunk = [data subdataWithRange:range];

		transferredBytes += transfer;

		NSLog(@"Transfer Message %d of %d with  %d sent", transferredBytes,[data length], transfer);
		[self uploadData:chunk toURL:[NSURL URLWithString:base]];

		
	}

	NSMutableString *finish = [[NSMutableString alloc] initWithString:base];
	[finish appendString:@"/finish"];	[self sendRequestTo:[NSURL URLWithString:finish] usingVerb:@"POST" withParameters:nil];
	NSLog(@"Finished");
	
	
}

- (void)uploadData:(NSData *)data withMethod: (NSString *) method andParameters: (NSArray *) parameters {
	
	
	NSMutableString *sendAddress = [NSMutableString stringWithString:baseAddress];
	[sendAddress appendString:method];
	
	NSString *param;
	
	for (param in parameters) {
		[sendAddress appendString:@"/"];
		[sendAddress appendString:param];
	}
	
	[self uploadData:data toURL:[NSURL URLWithString:sendAddress]];
	
	
}
- (void)uploadData:(NSData *)data toURL:(NSURL *)url
{
    // File upload code adapted from http://www.cocoadev.com/index.pl?HTTPFileUpload
    // and http://www.cocoadev.com/index.pl?HTTPFileUploadSample

    NSString* stringBoundary = [NSString stringWithString:@"0xKhTmLbOuNdArY"];
    
    NSMutableDictionary* headers = [[[NSMutableDictionary alloc] init] autorelease];
    [headers setValue:@"no-cache" forKey:@"Cache-Control"];
    [headers setValue:@"no-cache" forKey:@"Pragma"];
    [headers setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@", stringBoundary] forKey:@"Content-Type"];
    
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    [request setHTTPMethod:@"POST"];
    [request setAllHTTPHeaderFields:headers];
    
    [request setHTTPBody:data];
    
    [self startConnection:request];
}

- (void)cancelConnection
{
    [conn cancel];
    [conn release];
    conn = nil;
}




#pragma mark -
#pragma mark Private methods

- (void)startConnection:(NSURLRequest *)request
{
    if (asynchronous)
    {
        [self cancelConnection];
        conn = [[NSURLConnection alloc] initWithRequest:request
                                               delegate:self
                                       startImmediately:YES];
        
        if (!conn)
        {
			didFailWithError = YES;
        }
    }
    else
    {
		
        NSURLResponse* response = [[NSURLResponse alloc] init];
        NSError* error = [[NSError alloc] init];
        NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        [receivedData setData:data];
		
		
		//(TODO) What the fuck is this? 
		if ([onRetrieveDataTarget respondsToSelector:onRetrieveDataAction]) {
			
			
			
			[onRetrieveDataTarget performSelector:onRetrieveDataAction withObject:receivedData];
			
			
		}
        
    }
}

#pragma mark -
#pragma mark NSURLConnection delegate methods

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
	
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    didGetStatusCode = [httpResponse statusCode];

    [receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{

	
	[receivedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [self cancelConnection];
	didFailWithError = YES;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	
	
    [self cancelConnection];
	

	
	if ([onRetrieveDataTarget respondsToSelector:onRetrieveDataAction]) {
		
		if (fileDownload) {
			
			/*If the connection is being used to download a file then we need to keep track of the filename for the callback */
			NSArray *params = [NSArray arrayWithObjects:fileName, receivedData, nil];
			[onRetrieveDataTarget performSelector:onRetrieveDataAction withObject:params];
			
			
		}

		else {
			
			[onRetrieveDataTarget performSelector:onRetrieveDataAction withObject:receivedData];
		}
		
		
		
	}
	
	
}

@end
