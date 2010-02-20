//
//  SPGerberParser.h
//  Spark
//
//  Created by Matt Massicotte on 2/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol SPGerberParserDelegate;

@class PFGerberFormat, PFGerberApertureDefinition, PFGerberFunctionCode, PFGerberCoordinate;

@interface SPGerberParser : NSObject
{
	id<SPGerberParserDelegate> delegate;
    
	NSString*     fileContents;
    NSScanner*    scanner;
    NSFileHandle* fileHandle;
    
    NSCharacterSet* endOfDataBlockCharacterSet;
    NSCharacterSet* startOfDataBlockCharacterSet;
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

- (void)parser:(SPGerberParser*)parser foundFormat:(PFGerberFormat*)format;
- (void)parser:(SPGerberParser*)parser foundModeOfUnits:(BOOL)usingInches;
- (void)parser:(SPGerberParser*)parser foundOffsetForA:(double)aOffset andB:(double)bOffset;
- (void)parser:(SPGerberParser*)parser foundScaleFactorForA:(double)aScale andB:(double)bScale;
- (void)parser:(SPGerberParser*)parser foundApertureDefinition:(PFGerberApertureDefinition*)definition;
- (void)parser:(SPGerberParser*)parser foundLayer:(NSString*)name;
- (void)parser:(SPGerberParser*)parser foundLayerPolarity:(BOOL)positivePolarity;
- (void)parser:(SPGerberParser*)parser foundImagePolarity:(BOOL)positivePolarity;

- (void)parser:(SPGerberParser*)parser foundFunctionCode:(PFGerberFunctionCode*)functionCode;
- (void)parser:(SPGerberParser*)parser foundGCode:(PFGerberFunctionCode*)functionCode;
- (void)parser:(SPGerberParser*)parser foundCoordinate:(PFGerberCoordinate*)coordinate;
- (void)parser:(SPGerberParser*)parser foundDCode:(PFGerberFunctionCode*)functionCode;

@end
