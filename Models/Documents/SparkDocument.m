//
//  SparkDocument.m
//  Spark
//
//  Created by Matt Massicotte on 8/23/09.
//  Copyright __MyCompanyName__ 2009 . All rights reserved.
//

#import "SparkDocument.h"
#import "SparkWindowController.h"

#import "SparkDefinitionParser.h"
#import "Definition.h"
#import "SymbolDefinition.h"
#import "Symbol.h"

@implementation SparkDocument

- (id)init 
{
    self = [super init];
    if (self != nil)
	{
        NSManagedObject* mo;
		
		// new document.  We need one sheet, 3 pcb layers, and 3 matching cam layers
		mo = [NSEntityDescription insertNewObjectForEntityForName:@"Sheet" inManagedObjectContext:[self managedObjectContext]];
		[mo setValue:@"Untitled" forKey:@"name"];
		
		mo = [NSEntityDescription insertNewObjectForEntityForName:@"PCBLayer" inManagedObjectContext:[self managedObjectContext]];
		[mo setValue:@"Top Layer" forKey:@"name"];
		
		mo = [NSEntityDescription insertNewObjectForEntityForName:@"PCBLayer" inManagedObjectContext:[self managedObjectContext]];
		[mo setValue:@"Bottom Layer" forKey:@"name"];
		
		mo = [NSEntityDescription insertNewObjectForEntityForName:@"PCBLayer" inManagedObjectContext:[self managedObjectContext]];
		[mo setValue:@"Mechanical Layer" forKey:@"name"];
		
//		[self populateWithFakeData];
    }
    return self;
}

- (void)makeWindowControllers
{
	SparkWindowController* windowController;
	
	windowController = [[SparkWindowController alloc] initWithWindowNibName:[self windowNibName]];
	[self addWindowController:windowController];
	
	[windowController release];
}

- (NSString *)windowNibName 
{
    return @"SparkDocument";
}

- (void)windowControllerDidLoadNib:(NSWindowController *)windowController 
{
    [super windowControllerDidLoadNib:windowController];
    // user interface preparation code
}

- (void)populateWithFakeData
{
	NSManagedObjectContext*	context;
	Symbol*					symbol;
	Definition*				definition;
	SparkDefinitionParser*	parser;
	NSURL*					url;
	
	context = [self managedObjectContext];
	url = [NSURL fileURLWithPath:@"/Users/matt/Documents/programming/Spark/Stock Documents/Symbols/resistor.xml"];
	parser = [SparkDefinitionParser new];

	symbol = [NSEntityDescription insertNewObjectForEntityForName:@"Symbol" inManagedObjectContext:context];
	definition = [parser insertDefinitionAtURL:url intoManagedObjectContext:context];
	
	[symbol setSymbolDefinition:(SymbolDefinition*)definition];
	
	[symbol setGraphicalRep:[[[definition graphicalRep] allObjects] objectAtIndex:0]];
}

@end
