//
//  SPProjectNode.m
//  Spark
//
//  Created by Matt Massicotte on 9/9/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "SPProjectNode.h"

@implementation SPProjectNode

+ (id)node
{
    return [[[self class] new] autorelease];
}

#pragma mark Accessors

- (NSString*)displayName
{
    return @"Unknown";
}

- (BOOL)isHeader
{
	return NO;
}

- (BOOL)isLeaf
{
	return ![self isHeader];
}

- (NSArray*)children
{
	return nil;
}

@end
