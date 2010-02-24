//
//  GraphicalController.m
//  Spark
//
//  Created by Matt Massicotte on 8/31/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "GraphicalController.h"
#import "SparkOpenGLView.h"

@implementation GraphicalController

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
    [managedObjectContext release];
    
	[super dealloc];
}

@synthesize elementView;
@synthesize managedObjectContext;

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
}

- (void)reloadData
{
    [elementView reloadData];
}

#pragma mark SparkElementView DataSource
- (NSArray*)elementsInElementView:(SparkElementView*)view
{
	NSArray*				resultArray;
	NSManagedObjectContext*	context;
	NSEntityDescription*	entityDescription;
	NSFetchRequest*			request;
	NSError*				error;
	    
	context = [self managedObjectContext];
    
    if (!context)
        [NSException raise:@"SparkGraphicalControllerException" format:@"Managed object context is nil"];
    
	entityDescription = [NSEntityDescription entityForName:@"DesignElement" inManagedObjectContext:context];
	request           = [[[NSFetchRequest alloc] init] autorelease];
	
	[request setEntity:entityDescription];
	
	resultArray = [context executeFetchRequest:request error:&error];
	if (resultArray == nil)
	{
		// Deal with error...
		NSLog(@"error getting entities");
	}
	
	return resultArray;
}

@end
