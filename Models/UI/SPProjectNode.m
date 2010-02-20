//
//  SPProjectNode.m
//  Spark
//
//  Created by Matt Massicotte on 9/9/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "SPProjectNode.h"
#import "DesignSurface.h"

@implementation SPProjectNode

+ (id)nodeWithContext:(NSManagedObjectContext*)context
{
	SPProjectNode* node;
	
	node = [[[self class] new] autorelease];
	[node setManagedObjectContext:context];
	
	return node;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(newDesignSurface:)
                                                     name:DesignSurfaceWasCreatedNotification
                                                   object:nil];
    }
    
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
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
		SPProjectNode*	node;
		
		node = [SPProjectNode nodeWithContext:[self managedObjectContext]];
		[node setTitle:[object valueForKey:@"name"]];
		[node setManagedObject:object];
		[nodeArray addObject:node];
	}
	
	[self setChildren:nodeArray];
	
	return children;
}

- (void)newDesignSurface:(NSNotification*)notification
{
    NSLog(@"clearing children");
    self.children = nil;
}

@end
