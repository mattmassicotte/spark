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

#pragma mark -
#pragma mark OutlineView Support
- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item
{
	if (item == nil)
	{
		return [outlineSections objectAtIndex:index];
	}
	
	return [[item children] objectAtIndex:index];
}
- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item
{
	if (item == nil)
	{
		return YES;
	}
    
	return ![item isLeaf];
}

- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item
{
	if (item == nil)
	{
		return [outlineSections count];
	}
	
	return [[item children] count];
}
- (id)outlineView:(NSOutlineView *)outlineView objectValueForTableColumn:(NSTableColumn *)tableColumn byItem:(id)item
{
	return [item title];
}

- (BOOL)outlineView:(NSOutlineView *)outlineView shouldSelectItem:(id)item
{
	return ![item isHeader];
}

@end
