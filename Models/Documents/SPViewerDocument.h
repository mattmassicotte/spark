//
//  SPViewerDocument.h
//  Spark
//
//  Created by Matt Massicotte on 2/8/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class SparkCAMViewController;

@interface SPViewerDocument : NSPersistentDocument
{
    IBOutlet SparkCAMViewController* camViewController;
    IBOutlet NSOutlineView*			 projectOutlineView;
	IBOutlet NSArray*                projectHeadings;
}

@property (nonatomic, retain, readonly) NSArray* projectHeadings;

- (BOOL)importGerberFile:(NSURL*)url error:(NSError **)error;

@end
