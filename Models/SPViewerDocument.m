//
//  SPViewerDocument.m
//  Spark
//
//  Created by Matt Massicotte on 2/8/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SPViewerDocument.h"
#import "SparkViewerWindowController.h"
#import "SparkGerberRenderer.h"
#import "SPImportWindowController.h"

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
	SparkViewerWindowController* windowController;
	
	windowController = [[SparkViewerWindowController alloc] initWithWindowNibName:[self windowNibName]];
	[self addWindowController:windowController];
	
	[windowController release];
}

- (NSString *)windowNibName 
{
    return @"SPViewerDocument";
}

- (void)windowControllerDidLoadNib:(NSWindowController *)windowController 
{
    [super windowControllerDidLoadNib:windowController];
    // user interface preparation code
}

+ (NSArray *)readableTypes
{
    NSMutableArray* types;
    
    types = [NSMutableArray arrayWithArray:[super readableTypes]];
    [types addObject:@"com.spark.gerber"];
    
    return types;
}

- (BOOL)readFromURL:(NSURL *)absoluteURL ofType:(NSString *)typeName error:(NSError **)error
{
    if (UTTypeConformsTo((CFStringRef)typeName, CFSTR("com.spark.gerber")))
    {
        return [self importGerberFile:absoluteURL error:error];
    }
    
    return [super readFromURL:absoluteURL ofType:typeName error:error];
}

- (BOOL)importGerberFile:(NSURL*)url error:(NSError **)error
{
//    NSString*            uti;
//    CAMLayer*            layer;
//    SparkGerberRenderer* renderer;
//    
//    renderer = [[SparkGerberRenderer new] autorelease];
//    
//    layer = [NSEntityDescription insertNewObjectForEntityForName:@"CAMLayer" inManagedObjectContext:[self managedObjectContext]];
//    [layer setValue:[url lastPathComponent] forKey:@"name"];
//    
//    [url getResourceValue:&uti forKey:NSURLTypeIdentifierKey error:nil];
//    
//    if (UTTypeEqual((CFStringRef)uti, CFSTR("com.spark.gerber")) || UTTypeEqual((CFStringRef)uti, CFSTR("public.plain-text")))
//    {
//        // we don't know what layer we are dealing with, so we need to ask
//        if (!importWindowController)
//            importWindowController = [[SPImportWindowController alloc] initWithWindowNibName:@"ImportWindow"];
//
//        NSLog(@"%@ %@", [importWindowController window], [self windowForSheet]);
//        
//        [NSApp beginSheet:[importWindowController window]
//           modalForWindow:[self windowForSheet]
//            modalDelegate:self
//           didEndSelector:@selector(didEndImportSheet:returnCode:contextInfo:)
//              contextInfo:nil];
//    }
//    
//    if (![renderer renderGerberFile:url onCAMLayer:layer])
//    {
//        return NO;
//    }
//    
//    return YES;
    
    return NO;
}

 - (void)didEndImportSheet:(NSWindow *)sheet returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo
{
    [NSApp endSheet:sheet];
    
    [sheet orderOut:self];
}
@end
