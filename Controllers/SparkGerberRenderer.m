//
//  SparkGerberRenderer.m
//  Spark
//
//  Created by Matt Massicotte on 2/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SparkGerberRenderer.h"
#import "SparkVisualization.h"
#import "CAMLayer.h"
#import <math.h>

@interface SparkGerberRenderer ()

@property (nonatomic, retain) PFGerberApertureDefinition* activeAperture;
@property (nonatomic, retain) PFGerberCoordinate*         lastCoordinate;

@property (nonatomic, retain) CAMLayer*                   camLayer;
@property (nonatomic, retain) DesignElement*              currentElement;

@property (nonatomic, assign) PFGerberLightExposureType   activeExposure;

@end

@implementation SparkGerberRenderer

- (id)init
{
    self = [super init];
    if (self)
    {
        apertureDefinitions = [NSMutableDictionary new];
        self.activeAperture = nil;
        self.lastCoordinate = nil;
        self.currentElement = nil;
        
        lastXValue = 0;
        lastYValue = 0;
        
        xScaling = 0.001;
        yScaling = 0.001;
        
        maximumX = 0;
        minimumX = 0;
        maximumY = 0;
        minimumY = 0;
        
        fullCircleInterpolationEnabled = NO;
        interpolationMode = LinearInterpolationMode1XScale;
    }
    
    return self;
}

- (void)dealloc
{
    [apertureDefinitions release];
    [lastCoordinate release];
    [currentElement release];
    [camLayer release];
    
    [super dealloc];
}

#pragma mark -
#pragma mark Accessors

@synthesize activeAperture;
@synthesize lastCoordinate;
@synthesize currentElement;
@synthesize maximumX;
@synthesize minimumX;
@synthesize maximumY;
@synthesize minimumY;
@synthesize activeExposure;
@synthesize camLayer;

- (void)setLastCoordinate:(PFGerberCoordinate *)c
{
    if (lastCoordinate == c)
        return;
    
    [lastCoordinate release];
    lastCoordinate = [c retain];
    
    self.activeExposure = [c exposureType];
    
    if (c.x)
        lastXValue = xScaling * [c.x doubleValue];
    
    if (c.y)
        lastYValue = yScaling * [c.y doubleValue];
}

- (void)setActiveExposure:(PFGerberLightExposureType)type
{
    if (type != PFGerberExposureNotSpecified)
        activeExposure = type;
}

#pragma mark -
#pragma mark Rendering Methods

- (BOOL)renderGerberFile:(NSURL*)url onCAMLayer:(CAMLayer*)layer
{
    SPGerberParser*  parser;
    
    [apertureDefinitions removeAllObjects];
    
    parser = [[[SPGerberParser alloc] initWithContentsOfURL:url] autorelease];
    
    [parser setDelegate:self];
    
    self.camLayer = layer;
    
    if (![parser parse])
    {
        NSLog(@"We now need to remove that cam layer");
        return NO;
    }
    
    return YES;
}

- (void)renderLineFromPoint:(SPVec)start toPoint:(SPVec)end
{
    Quad*  quad;
    double length;
    double angle;
    double xShift;
    double yShift;
    
    quad = [NSEntityDescription insertNewObjectForEntityForName:@"Quad" inManagedObjectContext:[self.camLayer managedObjectContext]];
    
    // the radius of a circular aperture
    length = [[self.activeAperture.modifiers objectAtIndex:0] doubleValue] / 2.0;
    angle  = atan((end.y - start.y) / (end.x - start.x));
    
    xShift = cos(angle)*length;
    yShift = sin(angle)*length;
    
    quad.aX = [NSNumber numberWithDouble:start.x - xShift];
    quad.aY = [NSNumber numberWithDouble:start.y + yShift];
    quad.bX = [NSNumber numberWithDouble:end.x - xShift];
    quad.bY = [NSNumber numberWithDouble:end.y + yShift];
    quad.cX = [NSNumber numberWithDouble:end.x + xShift];
    quad.cY = [NSNumber numberWithDouble:end.y - yShift];
    quad.dX = [NSNumber numberWithDouble:start.x + xShift];
    quad.dY = [NSNumber numberWithDouble:start.y - yShift];
    
    [self.currentElement.graphicalRep addPrimitivesObject:quad];
}

- (void)renderArcFromPoint:(SPVec)start toPoint:(SPVec)end usingI:(double)i andJ:(double)j
{
    Arc*   arc;
    SPVec  center;
    double radius;
    double length;
    double startAngle;
    double endAngle;
    
    arc = [NSEntityDescription insertNewObjectForEntityForName:@"Arc" inManagedObjectContext:[self.camLayer managedObjectContext]];
    
    length = [[self.activeAperture.modifiers objectAtIndex:0] doubleValue] / 2.0;
    
    if (!fullCircleInterpolationEnabled)
    {
        NSLog(@"Non-360 degree interpolation not supported");
        return;
    }
    
    center = SPMakeVec(start.x + i, start.y + j, 0);
    
    startAngle = -1;
    endAngle   = -1;
    
//    NSLog(@"(%f,%f) (%f,%f), (%f,%f)", start.x, start.y, end.x, end.y, center.x, center.y);
    
    // The comparisons here are really tricky.  I needed to work it out very carefully on
    // graph paper before I got it.  The direction all matters
    
    if (start.x > center.x && start.y >= center.y)
    {
        // quadrant 1, between 0 and pi/2
        startAngle = 0.0 + atan((start.y - center.y)/(start.x - center.x));
    }
    else if (start.x <= center.x && start.y > center.y)
    {
        // quadrant 2, between pi/2 and pi
        startAngle = M_PI/2.0 + atan((center.x - start.x)/(start.y - center.y));
    }
    else if (start.x < center.x && start.y <= center.y)
    {
        // quadrant 3, between pi and 3pi/2
        startAngle = M_PI + atan((center.y - start.y)/(center.x - start.x));
    }
    else if (start.x >= center.x && start.y < center.y)
    {
        // quadrant 4, between 3pi/2 and 2pi
        startAngle = 3.0*M_PI/2.0 + atan((start.x - center.x)/(center.y - start.y));
    }
    else
    {
        NSLog(@"An unhandled start combination?");
    }

    if (end.x >= center.x && end.y > center.y)
    {
        // quadrant 1, between 0 and pi/2
        endAngle = M_PI/2.0 - atan((end.x - center.x)/(end.y - center.y));
    }
    else if (end.x < center.x && end.y >= center.y)
    {
        // quadrant 2, between pi/2 and pi
        endAngle = M_PI/2.0 + atan((center.x - end.x)/(end.y - center.y));
    }
    else if (end.x <= center.x && end.y < center.y)
    {
        // quadrant 3, between pi and 3pi/2
        endAngle = M_PI + atan((center.y - end.y)/(center.x - end.x));
    }
    else if (end.x > center.x && end.y <= center.y)
    {
        // quadrant 4, between 3pi/2 and 2pi
        //endAngle = 2.0*M_PI - atan((end.y - center.y)/(end.x - start.x));
        endAngle = 3.0*M_PI/2.0 + atan((end.x - center.x)/(center.y - end.y));
    }
    else
    {
        NSLog(@"An unhandled start combination?");
    }
    
    //NSLog(@"Final angles: (%f, %f)", startAngle/M_PI, endAngle/M_PI);
    
    radius = SPDistanceBetweenVec(start, center);
    
    arc.centerX = [NSNumber numberWithDouble:center.x];
    arc.centerY = [NSNumber numberWithDouble:center.y];
    
    arc.innerRadius = [NSNumber numberWithDouble:radius - length];
    arc.outerRadius = [NSNumber numberWithDouble:radius + length];
    
    arc.startAngle = [NSNumber numberWithDouble:startAngle];
    arc.endAngle   = [NSNumber numberWithDouble:endAngle];
    
    [self.currentElement.graphicalRep addPrimitivesObject:arc];
}

- (void)renderFlashAtPoint:(SPVec)point
{
    Arc*   arc;
    double radius;
    
    switch (activeAperture.apertureType)
    {
        case PFGerberApertureCircle:
            
            radius = [[self.activeAperture.modifiers objectAtIndex:0] doubleValue];
            
            arc = [NSEntityDescription insertNewObjectForEntityForName:@"Arc" inManagedObjectContext:[self.camLayer managedObjectContext]];

            arc.centerX = [NSNumber numberWithDouble:point.x];
            arc.centerY = [NSNumber numberWithDouble:point.y];
            
            arc.outerRadius = [NSNumber numberWithDouble:radius];
            
            NSLog(@"%@ - %d", self.activeAperture, [self.activeAperture.modifiers count]);
            switch ([self.activeAperture.modifiers count])
            {
                case 1:
                    arc.innerRadius = [NSNumber numberWithDouble:0.0];
                    break;
                case 2:
                    radius = [[self.activeAperture.modifiers objectAtIndex:1] doubleValue];
                    
                    arc.innerRadius = [NSNumber numberWithDouble:radius];
                    break;
                case 3:
                    NSLog(@"rectangular-holed circule aperture flashed.  Ignored");
                    return;
                default:
                    NSLog(@"Unsupported number of modifiers for circular aperture flashed");
                    return;
            }
                          

            arc.startAngle = [NSNumber numberWithDouble:0.0];
            arc.endAngle   = [NSNumber numberWithDouble:2.0*M_PI];
            
            [self.currentElement.graphicalRep addPrimitivesObject:arc];
            break;
    }
}

#pragma mark -
#pragma mark SPGerberParserDelegate Methods

- (void)parser:(SPGerberParser*)parser foundFormat:(PFGerberFormat*)format
{
}

- (void)parser:(SPGerberParser*)parser foundModeOfUnits:(BOOL)usingInches
{
}

- (void)parser:(SPGerberParser*)parser foundOffsetForA:(double)aOffset andB:(double)bOffset
{
}

- (void)parser:(SPGerberParser*)parser foundScaleFactorForA:(double)aScale andB:(double)bScale
{
}

- (void)parser:(SPGerberParser*)parser foundApertureDefinition:(PFGerberApertureDefinition*)definition
{
    NSNumber* dCode;
    
    dCode = [NSNumber numberWithInteger:definition.dCode];
    if ([apertureDefinitions objectForKey:dCode])
    {
        NSLog(@"Warning, redefinition of D%@ causes an implicit new layer", dCode);
        [NSException raise:@"SparkGerberRenderException" format:@"Unhandled aperture redefinition"];
    }
    
    [apertureDefinitions setObject:definition forKey:dCode];
}

- (void)parser:(SPGerberParser*)parser foundLayer:(NSString*)name
{
}

- (void)parser:(SPGerberParser*)parser foundFunctionCode:(PFGerberFunctionCode*)functionCode
{
    
}

- (void)parser:(SPGerberParser*)parser foundGCode:(PFGerberFunctionCode*)functionCode
{
    switch ([functionCode code]) {
        case PFGerberGCodeToolPrepare:
            self.activeAperture = [apertureDefinitions objectForKey:[NSNumber numberWithInteger:functionCode.dCode]];
            break;
        case PFGerberGCodeLinearInterpolation:
            interpolationMode = LinearInterpolationMode1XScale;
            break;
        case PFGerberGCodeClockwiseInterpolation:
            interpolationMode = CircularInterpolationModeClockwise;
            break;
        case PFGerberGCodeCouterclockwiseInterpolation:
            interpolationMode = CircularInterpolationModeCounterclockwise;
            break;
        case PFGerberGCodeEnable360DegreeCircularInterpolation:
            fullCircleInterpolationEnabled = YES;
            break;
        case PFGerberGCodeDisableCircularInterpolation:
            fullCircleInterpolationEnabled = NO;
            break;
        default:
            break;
    }
}

- (void)parser:(SPGerberParser*)parser foundCoordinate:(PFGerberCoordinate*)coordinate
{
    SPVec  previous;
    SPVec  current;
    double xValue;
    double yValue;
    
    if(!coordinate.x)
        xValue = lastXValue;
    else
    {
        xValue = xScaling * [coordinate.x doubleValue];
        maximumX = MAX(maximumX, xValue);
        minimumX = MIN(minimumX, xValue);
    }
    
    if(!coordinate.y)
        yValue = lastYValue;
    else
    {
        yValue = yScaling * [coordinate.y doubleValue];
        maximumY = MAX(maximumY, yValue);
        minimumY = MIN(minimumY, yValue);
    }
    
    if (!self.lastCoordinate)
    {
        if ([coordinate exposureType] != PFGerberExposureOff)
            NSLog(@"Warning, the first coordinate encountered did not have exposure off");
        
        if (coordinate.x == nil || coordinate.y == nil)
            NSLog(@"Warning, the first coordinate encountered did not have both x and y specified");
        
        self.lastCoordinate = coordinate;
        
        return;
    }
    
    // here, we do have a valid last coordinate

    // set our exposure
    self.activeExposure = [coordinate exposureType];
    
    previous = SPMakeVec(lastXValue, lastYValue, 0);
    current  = SPMakeVec(xValue, yValue, 0);
    
    if (self.activeExposure == PFGerberExposureOn)
    {
        if (!self.currentElement)
        {
            self.currentElement = [NSEntityDescription insertNewObjectForEntityForName:@"FreeElement" inManagedObjectContext:[self.camLayer managedObjectContext]];
            self.currentElement.graphicalRep = [NSEntityDescription insertNewObjectForEntityForName:@"GraphicalRep" inManagedObjectContext:[self.camLayer managedObjectContext]];
        }
        
        switch (interpolationMode)
        {
            case LinearInterpolationMode10XScale:
            case LinearInterpolationMode1XScale:
            case LinearInterpolationModePoint1XScale:
            case LinearInterpolationModePoint01XScale:
                [self renderLineFromPoint:previous toPoint:current];
                break;
            case CircularInterpolationModeClockwise:
            case CircularInterpolationModeCounterclockwise:
                [self renderArcFromPoint:previous toPoint:current usingI:xScaling * [[coordinate i] doubleValue] andJ:yScaling * [[coordinate j] doubleValue]];
                break;
        }
    }
    else if (self.activeExposure == PFGerberExposureFlash)
    {
        [self renderFlashAtPoint:current];
    }
    else
    {
        // element complete, start a new one
        self.currentElement = nil;
    }
    
    self.lastCoordinate = coordinate;
}

@end
