//
//  CAMLayer.h
//  Spark
//
//  Created by Matt Massicotte on 2/16/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "DesignSurface.h"

@interface CAMLayer : DesignSurface  
{
}

@property (nonatomic, retain) NSManagedObject * pcbLayer;

@end



