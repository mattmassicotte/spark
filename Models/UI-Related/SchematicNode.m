//
//  SchematicNode.m
//  Spark
//
//  Created by Matt Massicotte on 9/9/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "SchematicNode.h"


@implementation SchematicNode

- (id)init
{
	self = [super init];
	if (self)
	{
		[self setTitle:@"Schematic"];
	}
	
	return self;
}

- (BOOL)isHeader
{
	return YES;
}

- (NSString*)entityName
{
	return @"Sheet";
}

@end
