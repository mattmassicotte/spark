//
//  SPWindowController.h
//  Spark
//
//  Created by Matt Massicotte on 2/15/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface SPWindowController : NSWindowController
{
    IBOutlet NSOutlineView* projectOutlineView;
    
    NSMutableArray*         outlineSections;
}

@property (nonatomic, assign, readonly) IBOutlet NSManagedObjectContext* managedObjectContext;

@property (nonatomic, retain, readonly) NSMutableArray* outlineSections;

@end
