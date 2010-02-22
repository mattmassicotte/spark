//
//  SPGerberRenderingContext.m
//  Spark
//
//  Created by Matt Massicotte on 2/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SPGerberRenderingContext.h"
#import "PCBSublayer.h"
#import "SPGerberApertureDefinition.h"

@implementation SPGerberRenderingContext

- (id)initWithPCBSublayer:(PCBSublayer*)aSublayer
{
    self = [super init];
    if (self)
    {
        sublayer  = [aSublayer retain];
        apertures = [NSMutableDictionary new];
    }
    
    return self;
}

- (void)dealloc
{
    [sublayer release];
    [apertures release];
    
    [super dealloc];
}

@synthesize interpolationMode;
@synthesize fullCircleInterpolationEnabled;
@synthesize usingInches;
@synthesize offset;
@synthesize activeExposure;

- (void)addApertureDefinition:(SPGerberApertureDefinition*)definition
{
    [apertures setObject:definition forKey:[NSNumber numberWithInteger:definition.dCode]];
}

- (void)setActiveAperture:(NSUInteger)apertureNumber
{
    activeAperture = [apertures objectForKey:[NSNumber numberWithInteger:apertureNumber]];
}

- (void)parser:(SPGerberParser*)parser foundStatement:(SPGerberStatement*)statement
{
    [statement applyToContext:self];
}

@end
