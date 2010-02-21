//
//  SPPCBLayerNode.h
//  Spark
//
//  Created by Matt Massicotte on 10/12/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SPProjectNode.h"

@class PCBLayer;

@interface SPPCBLayerNode : SPProjectNode
{
    PCBLayer* pcbLayer;
}

@property (nonatomic, retain) PCBLayer* pcbLayer;

@end
