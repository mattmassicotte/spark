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
#import "DesignElement.h"
#import "Primitive.h"
#import "Quad.h"
#import "GraphicalRep.h"

@implementation SPGerberRenderingContext

- (id)initWithPCBSublayer:(PCBSublayer*)aSublayer
{
    self = [super init];
    if (self)
    {
        sublayer          = [aSublayer retain];
        apertures         = [NSMutableDictionary new];
        currentElement    = nil;
        interpolationMode = LinearInterpolationMode1XScale;
        fullCircleInterpolationEnabled = NO;
        
        lastPosition      = SPMakeVec(0.0, 0.0, 0.0);
        scale             = SPMakeVec(0.001, 0.001, 0.0);
    }
    
    return self;
}

- (void)dealloc
{
    [sublayer release];
    [apertures release];
    [currentElement release];
    
    [super dealloc];
}

@synthesize interpolationMode;
@synthesize fullCircleInterpolationEnabled;
@synthesize usingInches;
@synthesize offset;
@synthesize activeExposure;
@synthesize lastPosition;
@synthesize activeAperture;

- (double)scaleX:(double)xValue
{
    return xValue * scale.x + offset.x;
}

- (double)scaleY:(double)yValue
{
    return yValue * scale.y + offset.y;
}

- (SPVec)scalePoint:(SPVec)point
{
    return SPMakeVec([self scaleX:point.x], [self scaleY:point.y], point.z);
}

- (void)addApertureDefinition:(SPGerberApertureDefinition*)definition
{
    [apertures setObject:definition forKey:[NSNumber numberWithInteger:definition.dCode]];
}

- (void)setActiveAperture:(NSUInteger)apertureNumber
{
    activeAperture = [apertures objectForKey:[NSNumber numberWithInteger:apertureNumber]];
}

- (void)startElement
{
    NSManagedObjectContext* context;
    
    [self finishElement];
    
    context = [sublayer managedObjectContext];
    
    currentElement = [NSEntityDescription insertNewObjectForEntityForName:@"FreeElement" inManagedObjectContext:context];
    currentElement.graphicalRep = [NSEntityDescription insertNewObjectForEntityForName:@"GraphicalRep" inManagedObjectContext:context];

    [currentElement retain];
}

- (void)finishElement
{
    if (currentElement)
    {
        [currentElement release];
        currentElement = nil;
    }
}

- (Quad*)addQuadToCurrentElement
{
    Quad* quad;
    
    if (!currentElement)
        [self startElement];
    
    quad = [NSEntityDescription insertNewObjectForEntityForName:@"Quad" inManagedObjectContext:[sublayer managedObjectContext]];
    
    [currentElement.graphicalRep addPrimitivesObject:quad];
    
    return quad;
}

- (Arc*)addArcToCurrentElement
{
    Arc* arc;
    
    if (!currentElement)
        [self startElement];
    
    arc = [NSEntityDescription insertNewObjectForEntityForName:@"Arc" inManagedObjectContext:[sublayer managedObjectContext]];
    
    [currentElement.graphicalRep addPrimitivesObject:arc];
    
    return arc;
}

- (void)parser:(SPGerberParser*)parser foundStatement:(SPGerberStatement*)statement
{
    [statement applyToContext:self];
}

@end
