//
//  SPImportWindowController.h
//  Spark
//
//  Created by Matt Massicotte on 2/16/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface SPImportWindowController : NSWindowController
{
    void (^completionHandler)(NSInteger);
}

- (IBAction)performImport:(id)sender;
- (IBAction)cancelImport:(id)sender;

- (void)beginSheetModalForWindow:(NSWindow *)mainWindow completionHandler:(void (^)(NSInteger result))handler;

@end
