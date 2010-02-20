//
//  SparkWindowController.h
//  Spark
//
//  Created by Matt Massicotte on 8/29/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class SchematicController;

@interface SparkWindowController : NSWindowController
{
	IBOutlet NSOutlineView*			projectOutlineView;
	IBOutlet SchematicController*	schematicController;
	
	NSMutableArray*					outlineSections;
	// prototype support - should get this
	// from the document
	NSMutableArray*	sidebarArray;
}

@property (assign,readonly) IBOutlet NSManagedObjectContext* managedObjectContext;

@end
