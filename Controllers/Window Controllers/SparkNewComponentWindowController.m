//
//  SparkNewComponentWindowController.m
//  Spark
//
//  Created by Matt Massicotte on 10/31/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "SparkNewComponentWindowController.h"

#import "SparkDefinitionParser.h"
#import "Definition.h"
#import "SymbolDefinition.h"
#import "Symbol.h"

@implementation SparkNewComponentWindowController

- (id)initWithWindow:(NSWindow *)window
{
	self = [super initWithWindow:window];
	if (self)
	{
		components = [NSMutableArray new];
	}
	
	return self;
}

- (void)dealloc
{
	[components release];
	
	[super dealloc];
}

@synthesize components;

- (void)windowDidLoad
{
}

- (IBAction)cancel:(id)sender
{
	[NSApp endSheet:[self window]];
	[[self window] orderOut:self];
}

- (void)populateWithContext:(NSManagedObjectContext*)context
{
	//Symbol*					symbol;
	Definition*				definition;
	SparkDefinitionParser*	parser;
	NSURL*					url;
	
	[self willChangeValueForKey:@"components"];
	
	url = [NSURL fileURLWithPath:@"/Users/matt/Documents/programming/Spark/Stock Documents/Symbols/resistor.xml"];
	parser = [SparkDefinitionParser new];
	
	//symbol = [NSEntityDescription insertNewObjectForEntityForName:@"Symbol" inManagedObjectContext:context];
	definition = [parser insertDefinitionAtURL:url intoManagedObjectContext:context];
	
	[components addObject:definition];
	
	//[symbol setSymbolDefinition:(SymbolDefinition*)definition];
	
	//[symbol setGraphicalRep:[[[definition graphicalRep] allObjects] objectAtIndex:0]];
	
	[self didChangeValueForKey:@"components"];
}

@end
