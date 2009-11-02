//
//  SparkWindowController.m
//  Spark
//
//  Created by Matt Massicotte on 8/29/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "SparkWindowController.h"
#import "ProjectNode.h"
#import "SchematicNode.h"
#import "PCBNode.h"
#import "CAMNode.h"

@implementation SparkWindowController

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
	NSLog(@"window controller dealloc'ed");
	[super dealloc];
}

- (void)windowDidLoad
{
	ProjectNode* node;
	
	node = [SchematicNode nodeWithContext:[self managedObjectContext]];
	[outlineSections addObject:node];
	
	node = [PCBNode nodeWithContext:[self managedObjectContext]];
	[outlineSections addObject:node];
	
	node = [CAMNode nodeWithContext:[self managedObjectContext]];
	[outlineSections addObject:node];
	
	[projectOutlineView reloadData];
}

#pragma mark Accessors
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
