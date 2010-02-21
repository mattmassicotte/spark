//
//  SPCAMTitleNode.m
//  Spark
//
//  Created by Matt Massicotte on 2/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SPCAMTitleNode.h"
#import "SPPCBLayerNode.h"
#import "SPPCBSublayerNode.h"

@interface SPCAMTitleNode ()

@property (nonatomic, retain) NSFetchRequest* request;

@end

@implementation SPCAMTitleNode

- (void)dealloc
{
    [request release];
    
    [super dealloc];
}

@synthesize managedObjectContext;
@synthesize request;

- (NSFetchRequest*)request
{
    if (!request)
    {
        NSEntityDescription* entityDescription;
        NSSortDescriptor*	 sortDescriptor;
        NSFetchRequest*      newRequest;
        
        entityDescription = [NSEntityDescription entityForName:@"PCBLayer" inManagedObjectContext:self.managedObjectContext];
        sortDescriptor    = [[[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES] autorelease];
        newRequest        = [[NSFetchRequest new] autorelease];
        
        [newRequest setEntity:entityDescription];
        
        [newRequest setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
        
        self.request = newRequest;
    }
    
    return request;
}

- (NSString*)displayName
{
    return @"CAM";
}

- (BOOL)isHeader
{
	return YES;
}

- (BOOL)isLeaf
{
    return NO;
}

- (NSArray*)children
{
    NSMutableArray* nodeArray;
    NSArray*        resultArray;
    NSError*        error;
	
    resultArray = [self.managedObjectContext executeFetchRequest:self.request error:&error];
    if (resultArray == nil)
    {
        NSLog(@"could not find pcb layers for SPCAMTitleNode");
        return nil;
    }
	
	nodeArray = [NSMutableArray array];
    [resultArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        SPPCBLayerNode* node;
		
		node = [SPPCBLayerNode node];
        node.pcbLayer = obj;
		[nodeArray addObject:node];
    }];
    
	return nodeArray;
}

@end
