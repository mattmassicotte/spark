//
//  PCBSublayer.h
//  Spark
//
//  Created by Matt Massicotte on 2/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "DesignSurface.h"

@class PCBLayer;

@interface PCBSublayer : DesignSurface
{
}

@property (nonatomic, retain) PCBLayer * layer;

@end


