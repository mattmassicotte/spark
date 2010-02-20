//
//  PCBNode.m
//  Spark
//
//  Created by Matt Massicotte on 10/12/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "PCBNode.h"

@implementation PCBNode

- (id)init
{
	self = [super init];
	if (self)
	{
		[self setTitle:@"PCB"];
	}
	
	return self;
}

- (BOOL)isHeader
{
	return YES;
}

- (NSString*)entityName
{
	return @"PCBLayer";
}

@end
