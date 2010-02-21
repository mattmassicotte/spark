//
//  SPGerberParser.h
//  Spark
//
//  Created by Matt Massicotte on 2/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol SPGerberParserDelegate;

@class SPGerberStatement, SPGerberFunctionCode, PFGerberCoordinate, SPGerberParameter;

@interface SPGerberParser : NSObject
{
	id<SPGerberParserDelegate> delegate;
    
	NSString*     fileContents;
    NSScanner*    scanner;
    NSFileHandle* fileHandle;
    
    NSCharacterSet* endOfDataBlockCharacterSet;
    NSCharacterSet* startOfDataBlockCharacterSet;
    NSCharacterSet* numericCharacterSet;
    BOOL            parsingParameters;
}

- (id)initWithContentsOfURL:(NSURL*)url;

- (BOOL)parse;

@property (nonatomic, assign) id<SPGerberParserDelegate> delegate;

@end

@protocol SPGerberParserDelegate <NSObject>
@optional

- (void)parserDidStartDocument:(SPGerberParser*)parser;
- (void)parserDidEndDocument:(SPGerberParser*)parser;

- (void)parser:(SPGerberParser*)parser foundStatement:(SPGerberStatement*)statement;
- (void)parser:(SPGerberParser*)parser foundParameter:(SPGerberParameter*)parameter;
- (void)parser:(SPGerberParser*)parser foundFunctionCode:(SPGerberFunctionCode*)functionCode;
- (void)parser:(SPGerberParser*)parser foundCoordinate:(PFGerberCoordinate*)coordinate;

@end
