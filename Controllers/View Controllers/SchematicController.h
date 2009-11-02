//
//  SchematicController.h
//  Spark
//
//  Created by Matt Massicotte on 8/29/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "GraphicalController.h"

@class SparkNewComponentWindowController;

@interface SchematicController : GraphicalController
{
	SparkNewComponentWindowController* newComponentController;
}

- (IBAction)placeComponent:(id)sender;

@end
