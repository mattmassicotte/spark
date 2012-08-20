//
//  SPViewerDocument.m
//  Spark
//
//  Created by Matt Massicotte on 2/8/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SPViewerDocument.h"
#import "SparkCAMViewController.h"
#import "SPImportWindowController.h"
#import "SPGerberRenderingContext.h"
#import "PCBLayer.h"
#import "PCBSublayer.h"
#import "FreeElement.h"
#import "Arc.h"
#import "SPCAMTitleNode.h"

#define GERBER_UTI @"com.spark.gerber"

@interface SPViewerDocument ()

@property (nonatomic, retain) NSArray* projectHeadings;

- (BOOL)importGerberFile:(NSURL*)url error:(NSError **)error;

@end

@implementation SPViewerDocument

- (id)init 
{
    self = [super init];
    if (self != nil)
	{
		SPCAMTitleNode* node;
		
		node = [SPCAMTitleNode node];
		node.managedObjectContext = [self managedObjectContext];
		
		self.projectHeadings = [NSArray arrayWithObject:node];
    }
    
    return self;
}

- (void)dealloc
{
	[projectHeadings release];
	
    [super dealloc];
}

@synthesize projectHeadings;

- (NSString*)windowNibName 
{
    return @"SPViewerDocument";
}

- (void)windowControllerDidLoadNib:(NSWindowController *)windowController
{
    camViewController.managedObjectContext = [self managedObjectContext];
}

+ (NSArray *)readableTypes
{
    NSMutableArray* types;
    
    types = [NSMutableArray arrayWithArray:[super readableTypes]];
    [types addObject:GERBER_UTI];
    [types addObject:@"public.plain-text"];
    
    return types;
}

- (BOOL)readFromURL:(NSURL *)absoluteURL ofType:(NSString *)typeName error:(NSError **)error
{
    if (UTTypeConformsTo((CFStringRef)typeName, (CFStringRef)GERBER_UTI))
    {
        return [self importGerberFile:absoluteURL error:error];
    }
    
    return [super readFromURL:absoluteURL ofType:typeName error:error];
}

#pragma mark -
#pragma mark IBActions

- (IBAction)import:(id)sender
{
    NSOpenPanel* panel;

    panel = [NSOpenPanel openPanel];
    
    [panel setAllowsMultipleSelection:YES];
    [panel setCanChooseFiles:YES];
    [panel setCanChooseDirectories:NO];
    
    [panel setAllowedFileTypes:[[self class] readableTypes]];
    
    [panel beginSheetModalForWindow:[self windowForSheet] completionHandler:^(NSInteger result) {
        if (result == NSFileHandlingPanelOKButton)
        {
            [[panel URLs] enumerateObjectsUsingBlock:^(id url, NSUInteger idx, BOOL *stop) {
                [self importGerberFile:url error:nil];
            }];
            
            [camViewController reloadData];
        }
    }];
}

- (IBAction)toggleMiniViewer:(id)sender
{
	NSRect scrollViewTargetFrame;
	NSRect miniViewerTargetFrame;
	
	scrollViewTargetFrame = [projectOutlineScrollView frame];
	miniViewerTargetFrame = [miniViewerContainerView frame];
	
	NSLog(@"%@", [projectOutlineView superview]);
	
	if (miniViewerTargetFrame.size.height == 0)
	{
		// show viewer
		miniViewerTargetFrame.size.height = 144;
		
		scrollViewTargetFrame.size.height =  scrollViewTargetFrame.size.height - miniViewerTargetFrame.size.height;
		scrollViewTargetFrame.origin.y    += miniViewerTargetFrame.size.height;
	}
	else
	{
		// hide viewer
		scrollViewTargetFrame.size.height = scrollViewTargetFrame.size.height + miniViewerTargetFrame.size.height;
		scrollViewTargetFrame.origin.y    = miniViewerTargetFrame.origin.y;

		miniViewerTargetFrame.size.height = 0;
	}

	[NSAnimationContext beginGrouping];
	[[NSAnimationContext currentContext] setDuration:0.2];
	
	[[projectOutlineScrollView animator] setFrame:scrollViewTargetFrame];
	[[miniViewerContainerView animator] setFrame:miniViewerTargetFrame];
	
	[NSAnimationContext endGrouping];
}

- (BOOL)importGerberFile:(NSURL*)url error:(NSError **)error
{
    SPGerberRenderingContext* context;
    SPGerberParser*           parser;
    PCBLayer*                 layer;
    PCBSublayer*              sublayer;
    NSString*                 uti;
    
    [url getResourceValue:&uti forKey:NSURLTypeIdentifierKey error:nil];
        
//    if (UTTypeEqual((CFStringRef)uti, (CFStringRef)GERBER_UTI) || UTTypeEqual((CFStringRef)uti, CFSTR("public.plain-text")))
//    {
//        // we don't know what layer we are dealing with, so we need to ask
//        if (!importWindowController)
//            importWindowController = [SPImportWindowController new];
//        
//        [importWindowController beginSheetModalForWindow:[self windowForSheet] completionHandler:^(NSInteger result) {
//            NSLog(@"Complete: %d", result);
//        }];
//    }
    
	[self willChangeValueForKey:@"projectHeadings"];
	
    layer    = [NSEntityDescription insertNewObjectForEntityForName:@"PCBLayer" inManagedObjectContext:[self managedObjectContext]];
	sublayer = [NSEntityDescription insertNewObjectForEntityForName:@"PCBSublayer" inManagedObjectContext:[self managedObjectContext]];
    
    [layer addSublayersObject:sublayer];
    
	layer.name = @"Layer";
	sublayer.name = [url lastPathComponent];
	
    context = [[SPGerberRenderingContext alloc] initWithPCBSublayer:sublayer];
    parser  = [[SPGerberParser alloc] initWithContentsOfURL:url];
    parser.delegate = context;
    
    [parser parse];
    
    [parser release];
    [context release];
    
	[self didChangeValueForKey:@"projectHeadings"];
//    FreeElement* e = [NSEntityDescription insertNewObjectForEntityForName:@"FreeElement" inManagedObjectContext:[self managedObjectContext]];
//    e.graphicalRep = [NSEntityDescription insertNewObjectForEntityForName:@"GraphicalRep" inManagedObjectContext:[self managedObjectContext]];
//    Arc* arc       = [NSEntityDescription insertNewObjectForEntityForName:@"Arc" inManagedObjectContext:[self managedObjectContext]];
//    
//    arc.centerX = [NSNumber numberWithDouble:0.0];
//    arc.centerY = [NSNumber numberWithDouble:0.0];
//    
//    arc.innerRadius = [NSNumber numberWithDouble:1.0];
//    arc.outerRadius = [NSNumber numberWithDouble:2.0];
//    
//    arc.startAngle  = [NSNumber numberWithDouble:3.0*M_PI/2.0];
//    arc.endAngle    = [NSNumber numberWithDouble:2.0*M_PI];
//    
//    [e.graphicalRep addPrimitivesObject:arc];
    
    return YES;
}



#pragma mark -
#pragma mark NSOutlineViewDelegate methods

- (void)outlineView:(NSOutlineView *)outlineView willDisplayCell:(id)cell forTableColumn:(NSTableColumn *)tableColumn item:(id)item
{
	//[cell setFont:[NSFont systemFontOfSize:[NSFont smallSystemFontSize]]];
}

- (BOOL)outlineView:(NSOutlineView *)outlineView shouldEditTableColumn:(NSTableColumn *)tableColumn item:(id)item
{
	return NO;
}

- (BOOL)outlineView:(NSOutlineView *)outlineView shouldSelectItem:(id)item
{
	SPProjectNode* node;
	
	node = [item representedObject];
	
	if ([node isHeader])
		return NO;
	
	return YES;
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isGroupItem:(id)item
{
	return [[item representedObject] isHeader];
}

@end
