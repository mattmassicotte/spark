//
//  CAMNode.m
//  Spark
//
//  Created by Matt Massicotte on 10/12/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "CAMNode.h"

@implementation CAMNode

- (id)init
{
	self = [super init];
	if (self)
	{
		[self setTitle:@"CAM"];
	}
	
	return self;
}

- (BOOL)isHeader
{
	return YES;
}

- (NSString*)entityName
{
	return @"CAMLayer";
}

@end
