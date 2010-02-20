//
//  SparkNewComponentWindowController.h
//  Spark
//
//  Created by Matt Massicotte on 10/31/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface SparkNewComponentWindowController : NSWindowController
{
	IBOutlet NSTableView*	componentTableView;
	IBOutlet NSButton*		placeButton;
	
	NSMutableArray*			components;
}

@property (retain,readonly,nonatomic)	NSMutableArray*	components;

- (IBAction)cancel:(id)sender;

- (void)populateWithContext:(NSManagedObjectContext*)context;

@end
