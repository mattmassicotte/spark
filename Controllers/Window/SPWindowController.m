//
//  SPWindowController.m
//  Spark
//
//  Created by Matt Massicotte on 2/15/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SPWindowController.h"
#import "SPProjectNode.h"

@implementation SPWindowController

- (id)initWithWindow:(NSWindow *)window
{
	self = [super initWithWindow:window];
	if (self)
	{
		outlineSections = [NSMutableArray new];
	}
	
	return self;
}

- (void)dealloc
{
	[outlineSections release];

	[super dealloc];
}

#pragma mark Accessors
@synthesize outlineSections;

- (NSManagedObjectContext*)managedObjectContext
{
	return [[self document] managedObjectContext];
}

@end
