//
//  SPPCBSublayerNode.h
//  Spark
//
//  Created by Matt Massicotte on 2/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SPProjectNode.h"

@class PCBSublayer;

@interface SPPCBSublayerNode : SPProjectNode
{
    PCBSublayer* sublayer;
}

@property (nonatomic, retain) PCBSublayer* sublayer;

@end
