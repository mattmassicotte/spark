//
//  SparkDefinitionParser.m
//  Spark
//
//  Created by Matt Massicotte on 10/13/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "SparkDefinitionParser.h"
#import "Definition.h"
#import "GraphicalRep.h"
#import "Primitive.h"

@implementation SparkDefinitionParser

- (id)init
{
	self = [super init];
	if (self)
	{
		state = BeginningParseState;
	}
	
	return self;
}

- (Definition*)insertDefinitionAtURL:(NSURL*)url intoManagedObjectContext:(NSManagedObjectContext*)aContext
{
	NSXMLParser*		parser;
	
	parser = [[NSXMLParser alloc] initWithContentsOfURL:url];
	
	context = aContext;
	[parser setDelegate:self];
	currentDefinition = nil;
	
	if (![parser parse])
	{
		NSLog(@"parser returned false");
		NSLog(@"parser returned %@", [[parser parserError] description]);
		return nil;
	}
	
	[parser release];
	
	return currentDefinition;	
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
}
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
	switch (state)
	{
		case BeginningParseState:
			if ([elementName caseInsensitiveCompare:@"symboldefinition"] == NSOrderedSame)
			{
				state = SymbolDefParseState;
				currentDefinition = [NSEntityDescription insertNewObjectForEntityForName:@"SymbolDefinition" inManagedObjectContext:context];
			}
			break;
		case SymbolDefParseState:
			if ([elementName caseInsensitiveCompare:@"symbol"] == NSOrderedSame)
			{
				state = SymbolParseState;
			}
			break;
		case SymbolParseState:
			if ([elementName caseInsensitiveCompare:@"graphical"] == NSOrderedSame)
			{
				state = SymbolGraphicalParseState;
				currentGraphicalRep = [NSEntityDescription insertNewObjectForEntityForName:@"GraphicalRep" inManagedObjectContext:context];
				[currentDefinition addGraphicalRepObject:currentGraphicalRep];
			}
			break;
		case SymbolGraphicalParseState:
			if ([Primitive isNameOfPrimitive:elementName])
			{
				currentPrimitive = [Primitive addPrimitiveWithName:[elementName capitalizedString]
													toGraphicalRep:currentGraphicalRep];
				
				if (currentPrimitive)
				{
					[currentPrimitive setIdentifier:[attributeDict objectForKey:@"identifier"]];

					state = SymbolGraphicalPrimitiveParseState;
				}
			}
			break;
		case SymbolGraphicalPrimitiveParseState:
			[currentPrimitive assign:elementName with:attributeDict];
			break;
	}
}
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
	switch (state)
	{
		case BeginningParseState:
			break;
		case SymbolDefParseState:
			if ([elementName caseInsensitiveCompare:@"symboldefinition"] == NSOrderedSame)
			{
				state = BeginningParseState;
			}
			break;
		case SymbolParseState:
			if ([elementName caseInsensitiveCompare:@"symbol"] == NSOrderedSame)
			{
				state = SymbolDefParseState;
			}
			break;
		case SymbolGraphicalParseState:
			if ([elementName caseInsensitiveCompare:@"graphical"] == NSOrderedSame)
			{
				state = SymbolParseState;
			}
			break;
		case SymbolGraphicalPrimitiveParseState:
			if ([Primitive isNameOfPrimitive:elementName])
			{
				state = SymbolGraphicalParseState;
			}
			break;
	}
	
}

@end
