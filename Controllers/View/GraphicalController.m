//
//  GraphicalController.m
//  Spark
//
//  Created by Matt Massicotte on 8/31/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "GraphicalController.h"
#import "SparkOpenGLView.h"

#import "FreeElement.h"
#import "GraphicalRep.h"
#import "Quad.h"
#import "Arc.h"

@implementation GraphicalController

@synthesize elementView;

- (id)init
{
	self = [super init];
	if (self)
	{
	}
	
	return self;
}

- (void)dealloc
{
    [elementView release];
    
	[super dealloc];
}

- (void)awakeFromNib
{
	NSResponder* r;
	
	// this is commented out so that we don't make things explode!
	elementView = (SparkElementView*)[scrollView contentView];
    [elementView retain];
	[elementView setDataSource:self];
    [elementView setDelegate:self];
	
	// inject ourselves into the responder chain
	r = [elementView nextResponder];
	[elementView setNextResponder:self];
	[self setNextResponder:r];

	// this is disabled, because the view tries to draw
	// itself only when needed, and there is no
	// animation, so regular drawing isn't required
//	[elementView setRenderingInterval:5.0];
//	[elementView beginRendering:self];
    
//    FreeElement* e = [NSEntityDescription insertNewObjectForEntityForName:@"FreeElement" inManagedObjectContext:[self managedObjectContext]];
//    e.graphicalRep = [NSEntityDescription insertNewObjectForEntityForName:@"GraphicalRep" inManagedObjectContext:[self managedObjectContext]];
//    Arc* arc       = [NSEntityDescription insertNewObjectForEntityForName:@"Arc" inManagedObjectContext:[self managedObjectContext]];
//    
//    arc.centerX = [NSNumber numberWithDouble:25.0];
//    arc.centerY = [NSNumber numberWithDouble:5.0];
//    
//    arc.innerRadius = [NSNumber numberWithDouble:1.0];
//    arc.outerRadius = [NSNumber numberWithDouble:2.0];
//    
//    arc.startAngle  = [NSNumber numberWithDouble:3.0*M_PI/2.0];
//    arc.endAngle    = [NSNumber numberWithDouble:2.0*M_PI];
//    
//    [e.graphicalRep addPrimitivesObject:arc];
}

- (NSWindow*)window
{
	return [scrollView window];
}
- (NSDocument*)document
{
	return [[[self window] windowController] document];
}
- (NSManagedObjectContext*)managedObjectContext
{
	return [(NSPersistentDocument*)[self document] managedObjectContext];
}

#pragma mark SparkElementView DataSource
- (NSArray*)elementsInElementView:(SparkElementView*)view
{
	NSArray*				resultArray;
	NSManagedObjectContext*	context;
	NSEntityDescription*	entityDescription;
//	NSPredicate*			predicate;
//	NSSortDescriptor*		sortDescriptor;
	NSFetchRequest*			request;
	NSError*				error;
	    
	context = [self managedObjectContext];
        
    if (!context)
        [NSException raise:@"SparkGrapicalControllerException" format:@"Managed object context is nil"];
    
	entityDescription = [NSEntityDescription entityForName:@"DesignElement" inManagedObjectContext:context];
	request = [[[NSFetchRequest alloc] init] autorelease];
	//sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
	
	[request setEntity:entityDescription];
	
	//predicate = [NSPredicate predicateWithFormat:@"(lastName LIKE[c] 'Worsley') AND (salary > %@)", minimumSalary];
	//[request setPredicate:predicate];
	
	//[request setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
	//[sortDescriptor release];
	
	resultArray = [context executeFetchRequest:request error:&error];
	if (resultArray == nil)
	{
		// Deal with error...
		NSLog(@"error getting entities");
	}
	
	return resultArray;
}

@end
