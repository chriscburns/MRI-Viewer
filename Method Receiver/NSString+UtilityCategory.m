//
//  NSString+UtilityCategory.m
//  SMARTDemo
//
//  Created by Chris Burns on 10-07-26.
//  Copyright 2010 University of Calgary. All rights reserved.
//

#import "NSString+UtilityCategory.h"
#import "TouchXML.h"

@implementation NSString (deserializeFromMS)

- (NSString *) deserializeString {
	
	
	CXMLDocument *document = [[CXMLDocument alloc] initWithXMLString:self options:0 error:nil];
	
	CXMLElement *value = [document rootElement];
	
	
	
	
	return [value stringValue];
	
	

	
}

	




@end
