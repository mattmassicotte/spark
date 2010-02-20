//
//  SparkViewerWindowController.h
//  Spark
//
//  Created by Matt Massicotte on 2/9/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SPWindowController.h"

@class SparkCAMViewController;

@interface SparkViewerWindowController : SPWindowController
{
    IBOutlet SparkCAMViewController* camViewController;
}

@end
