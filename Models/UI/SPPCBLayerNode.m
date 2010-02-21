//
//  SPPCBLayerNode.m
//  Spark
//
//  Created by Matt Massicotte on 10/12/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "SPPCBLayerNode.h"
#import "PCBLayer.h"
#import "SPPCBSublayerNode.h"

@implementation SPPCBLayerNode

- (void)dealloc
{
    [pcbLayer release];
    
    [super dealloc];
}

@synthesize pcbLayer;

- (NSString*)displayName
{
    return pcbLayer.name;
}

- (BOOL)isLeaf
{
    return [pcbLayer.sublayers count] == 0;
}

- (NSArray*)children
{
    NSMutableArray* nodeArray;
    
    nodeArray = [NSMutableArray array];
    [pcbLayer.sublayers enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
        SPPCBSublayerNode* node;
        
        node = [SPPCBSublayerNode new];
        node.sublayer = obj;
        
        [nodeArray addObject:node];
    }];
    
    return nodeArray;
}

@end
