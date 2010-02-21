//
//  SPViewerDocument.h
//  Spark
//
//  Created by Matt Massicotte on 2/8/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class SPImportWindowController;

@interface SPViewerDocument : NSPersistentDocument
{
    SPImportWindowController* importWindowController;
}

- (BOOL)importGerberFile:(NSURL*)url error:(NSError **)error;

@end
