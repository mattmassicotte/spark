//
//  SPPCBSublayerNode.m
//  Spark
//
//  Created by Matt Massicotte on 2/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SPPCBSublayerNode.h"
#import "PCBSublayer.h"

@implementation SPPCBSublayerNode

@synthesize sublayer;

- (NSString*)displayName
{
    return sublayer.name;
}

- (BOOL)isLeaf
{
    return YES;
}

@end
