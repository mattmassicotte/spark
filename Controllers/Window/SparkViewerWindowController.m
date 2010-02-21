//
//  SparkViewerWindowController.m
//  Spark
//
//  Created by Matt Massicotte on 2/9/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SparkViewerWindowController.h"
#import "SPViewerDocument.h"
#import "SparkCAMViewController.h"
#import "SPProjectNode.h"
#import "CAMNode.h"

@implementation SparkViewerWindowController

- (IBAction)import:(id)sender
{
    NSOpenPanel* panel;
    
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
	SPProjectNode* node;
    
	node = [CAMNode nodeWithContext:[self managedObjectContext]];
    
	[self.outlineSections addObject:node];
        
	[projectOutlineView reloadData];
}

@end
