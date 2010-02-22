//
//  SPImportWindowController.m
//  Spark
//
//  Created by Matt Massicotte on 2/16/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SPImportWindowController.h"

@implementation SPImportWindowController

- (void)dealloc
{
    [completionHandler release];
    
    [super dealloc];
}

- (NSString*)windowNibName 
{
    return @"ImportWindow";
}

- (IBAction)performImport:(id)sender
{
    [NSApp endSheet:[self window]];
    
    [[self window] orderOut:self];
    
    if (completionHandler)
    {
        completionHandler(NSOKButton);
    }
}

- (IBAction)cancelImport:(id)sender
{
    [NSApp endSheet:[self window]];
    
    [[self window] orderOut:self];
    
    if (completionHandler)
    {
        completionHandler(NSCancelButton);
    }
}

- (void)beginSheetModalForWindow:(NSWindow *)mainWindow completionHandler:(void (^)(NSInteger result))handler
{
    [completionHandler release];
    completionHandler = [handler retain];
    
    [NSApp beginSheet:[self window]
       modalForWindow:mainWindow
        modalDelegate:self
       didEndSelector:NULL
          contextInfo:nil];
}

@end
