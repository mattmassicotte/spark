//
//  GraphicalController.h
//  Spark
//
//  Created by Matt Massicotte on 8/31/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SparkElementView.h"

@class SparkScrollView, SparkElementView;

@interface GraphicalController : NSResponder <SparkElementViewDataSource>
{
	IBOutlet SparkScrollView*	scrollView;
	IBOutlet SparkElementView*	elementView;
}

@property (retain, readonly) SparkElementView*	elementView;
@property (assign, readonly) NSWindow*			window;
@property (assign, readonly, nonatomic) NSDocument*	document;
@property (assign, readonly, nonatomic) NSManagedObjectContext* managedObjectContext;

@end
