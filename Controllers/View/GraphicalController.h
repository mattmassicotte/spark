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

@interface GraphicalController : NSResponder <SparkElementViewDataSource, SparkElementViewDelegate>
{
	IBOutlet SparkScrollView*  scrollView;
	IBOutlet SparkElementView* elementView;
}

@property (nonatomic, retain, readonly) SparkElementView*       elementView;
@property (nonatomic, assign, readonly) NSWindow*               window;
@property (nonatomic, assign, readonly) NSDocument*             document;
@property (nonatomic, assign, readonly) NSManagedObjectContext* managedObjectContext;

@end
