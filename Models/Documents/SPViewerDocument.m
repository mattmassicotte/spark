//
//  SPViewerDocument.m
//  Spark
//
//  Created by Matt Massicotte on 2/8/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SPViewerDocument.h"
#import "SPViewerWindowController.h"
#import "SPImportWindowController.h"
#import "SPGerberRenderingContext.h"
#import "PCBLayer.h"
#import "PCBSublayer.h"

#define GERBER_UTI @"com.spark.gerber"

@interface SPViewerDocument ()

- (BOOL)importGerberFile:(NSURL*)url error:(NSError **)error;

@end

@implementation SPViewerDocument

- (id)init 
{
    self = [super init];
    if (self != nil)
	{
    }
    
    return self;
}

- (void)makeWindowControllers
{
	[self addWindowController:[[SPViewerWindowController new] autorelease]];
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
        }
    }];
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
    
    layer    = [NSEntityDescription insertNewObjectForEntityForName:@"PCBLayer" inManagedObjectContext:[self managedObjectContext]];
    sublayer = [NSEntityDescription insertNewObjectForEntityForName:@"PCBSublayer" inManagedObjectContext:[self managedObjectContext]];
    
    [layer addSublayersObject:sublayer];
    
    context = [[SPGerberRenderingContext alloc] initWithPCBSublayer:sublayer];
    parser  = [[SPGerberParser alloc] initWithContentsOfURL:url];
    parser.delegate = context;
    
    [parser parse];
    
    return YES;
}

@end
