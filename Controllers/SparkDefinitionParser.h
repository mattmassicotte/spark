//
//  SparkDefinitionParser.h
//  Spark
//
//  Created by Matt Massicotte on 10/13/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

typedef enum _ParseState {
	BeginningParseState,
	SymbolDefParseState,
	SymbolParseState,
	SymbolGraphicalParseState,
	SymbolGraphicalPrimitiveParseState
} ParseState_t;

@class Definition, GraphicalRep, Primitive;

@interface SparkDefinitionParser : NSObject <NSXMLParserDelegate>
{
	NSManagedObjectContext*	context;
	ParseState_t	state;
	Definition*		currentDefinition;
	GraphicalRep*	currentGraphicalRep;
	Primitive*		currentPrimitive;
}

- (Definition*)insertDefinitionAtURL:(NSURL*)url intoManagedObjectContext:(NSManagedObjectContext*)aContext;

@end
