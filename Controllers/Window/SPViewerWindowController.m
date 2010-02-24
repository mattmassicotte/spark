//
//  SPViewerWindowController.m
//  Spark
//
//  Created by Matt Massicotte on 2/9/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SPViewerWindowController.h"
#import "SPViewerDocument.h"
#import "SparkCAMViewController.h"
#import "SPProjectNode.h"
#import "SPCAMTitleNode.h"
#import "PCBLayer.h"
#import "PCBSublayer.h"

@implementation SPViewerWindowController

- (NSString*)windowNibName 
{
    return @"SPViewerDocument";
}

- (void)windowDidLoad
{
	SPCAMTitleNode* node;
    
	node = [SPCAMTitleNode node];
    node.managedObjectContext = [self managedObjectContext];
    
    [self willChangeValueForKey:@"outlineSections"];
	[self.outlineSections addObject:node];
    [self didChangeValueForKey:@"outlineSections"];
}

@end
