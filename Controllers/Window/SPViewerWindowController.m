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

- (void)addFakeData
{
    PCBLayer*    layer;
    PCBSublayer* sublayer;
    
    NSLog(@"adding fake data");
    
    layer = [NSEntityDescription insertNewObjectForEntityForName:@"PCBLayer" inManagedObjectContext:[self managedObjectContext]];
    layer.name = @"Layer 1";
    
    sublayer = [NSEntityDescription insertNewObjectForEntityForName:@"PCBSublayer" inManagedObjectContext:[self managedObjectContext]];
    sublayer.name = @"Mechanical";
    [layer addSublayersObject:sublayer];
    
    sublayer = [NSEntityDescription insertNewObjectForEntityForName:@"PCBSublayer" inManagedObjectContext:[self managedObjectContext]];
    sublayer.name = @"Top Copper";
    [layer addSublayersObject:sublayer];
    
    sublayer = [NSEntityDescription insertNewObjectForEntityForName:@"PCBSublayer" inManagedObjectContext:[self managedObjectContext]];
    sublayer.name = @"Bottom Copper";
    [layer addSublayersObject:sublayer];
    
    layer = [NSEntityDescription insertNewObjectForEntityForName:@"PCBLayer" inManagedObjectContext:[self managedObjectContext]];
    layer.name = @"Layer 2";
    
    sublayer = [NSEntityDescription insertNewObjectForEntityForName:@"PCBSublayer" inManagedObjectContext:[self managedObjectContext]];
    sublayer.name = @"Mechanical";
    [layer addSublayersObject:sublayer];
    
    [projectOutlineView reloadData];
}

- (NSString *)windowNibName 
{
    return @"SPViewerDocument";
}

- (IBAction)import:(id)sender
{
    NSOpenPanel* panel;
    
    [self willChangeValueForKey:@"outlineSections"];
    [self addFakeData];
    [self didChangeValueForKey:@"outlineSections"];
    
    return;
    
    panel = [NSOpenPanel openPanel];
    
    [panel setAllowsMultipleSelection:YES];
    [panel setCanChooseFiles:YES];
    [panel setCanChooseDirectories:NO];
    
    [panel setAllowedFileTypes:[NSArray arrayWithObjects:@"com.spark.gerber", nil]];
    
    [panel beginSheetModalForWindow:[self window] completionHandler:^(NSInteger result) {
        if (result == NSFileHandlingPanelOKButton)
        {
            [[panel URLs] enumerateObjectsUsingBlock:^(id url, NSUInteger idx, BOOL *stop) {
                NSString* uti;
                
                [url getResourceValue:&uti forKey:NSURLTypeIdentifierKey error:nil];
                NSLog(@"%@", uti);
                
                [[self document] importGerberFile:url error:nil];
            }];
            
            [projectOutlineView reloadData];
            [[camViewController elementView] reloadData];
        }
    }];
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
