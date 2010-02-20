// 
//  DesignSurface.m
//  Spark
//
//  Created by Matt Massicotte on 2/16/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "DesignSurface.h"
#import "DesignElement.h"

NSString* const DesignSurfaceWasCreatedNotification = @"DesignSurfaceWasCreatedNotification";

@implementation DesignSurface 

- (void)awakeFromInsert
{
    [[NSNotificationCenter defaultCenter] postNotificationName:DesignSurfaceWasCreatedNotification object:self];
}

@dynamic name;
@dynamic elements;

@end
