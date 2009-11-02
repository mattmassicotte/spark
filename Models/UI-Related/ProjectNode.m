//
//  ProjectNode.m
//  Spark
//
//  Created by Matt Massicotte on 9/9/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ProjectNode.h"

@implementation ProjectNode

+ (id)nodeWithContext:(NSManagedObjectContext*)context
{
	ProjectNode* node;
	
	node = [[[self class] new] autorelease];
	[node setManagedObjectContext:context];
	
	return node;
}

- (void)dealloc
{
	[managedObjectContext release];
	[children release];
	
	[super dealloc];
}

#pragma mark Accessors
@synthesize managedObjectContext;
@synthesize managedObject;
@synthesize title;

- (BOOL)isHeader
{
	return NO;
}

- (BOOL)isLeaf
{
	return ![self isHeader];
}

@synthesize children;

- (NSString*)entityName
{
	return nil;
}

- (NSArray*)children
{
	NSMutableArray*			nodeArray;
	NSArray*				resultArray;
	NSManagedObjectContext*	context;
	NSEntityDescription*	entityDescription;
//	NSPredicate*			predicate;
	NSSortDescriptor*		sortDescriptor;
	NSFetchRequest*			request;
	NSError*				error;
	
	if ([self entityName] == nil)
		return nil;
	
	if (children)
		return children;
	
	context = [self managedObjectContext];
	entityDescription = [NSEntityDescription entityForName:[self entityName] inManagedObjectContext:context];
	request = [[[NSFetchRequest alloc] init] autorelease];
	sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
	
	[request setEntity:entityDescription];
	
	//predicate = [NSPredicate predicateWithFormat:@"(lastName LIKE[c] 'Worsley') AND (salary > %@)", minimumSalary];
	//[request setPredicate:predicate];
	
	[request setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
	[sortDescriptor release];
	
	resultArray = [context executeFetchRequest:request error:&error];
	if (resultArray == nil)
	{
		// Deal with error...
		NSLog(@"error!");
	}
	
	nodeArray = [NSMutableArray array];
	for (NSManagedObject* object in resultArray)
	{
		ProjectNode*	node;
		
		node = [ProjectNode nodeWithContext:[self managedObjectContext]];
		[node setTitle:[object valueForKey:@"name"]];
		[node setManagedObject:object];
		NSLog(@"new cam node: %@", [node title]);
		[nodeArray addObject:node];
	}
	
	[self setChildren:nodeArray];
	
	return children;
}

@end
