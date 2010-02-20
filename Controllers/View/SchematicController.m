//
//  SchematicController.m
//  Spark
//
//  Created by Matt Massicotte on 8/29/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "SchematicController.h"
#import "SparkNewComponentWindowController.h"

@implementation SchematicController

- (void)dealloc
{
	[newComponentController release];
	
	[super dealloc];
}

- (IBAction)placeComponent:(id)sender
{
	if (!newComponentController)
	{
		newComponentController = [[SparkNewComponentWindowController alloc] initWithWindowNibName:@"NewComponent"];
		[newComponentController populateWithContext:[self managedObjectContext]];
	}
	
	[NSApp beginSheet:[newComponentController window]
	   modalForWindow:[self window]
		modalDelegate:self
	   didEndSelector:@selector(sheetDidEnd:returnCode:contextInfo:)
		  contextInfo:nil];
}

- (void)sheetDidEnd:(NSWindow *)sheet returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo
{
	NSLog(@"%d", returnCode);
}

@end
