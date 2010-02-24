//
//  SPGerberCoordinate.m
//  Spark
//
//  Created by Matt Massicotte on 2/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SPGerberCoordinate.h"
#import "SPGerberApertureDefinition.h"
#import "SPGerberRenderingContext.h"
#import "Quad.h"
#import "Arc.h"
#import "DesignElement.h"
#import "GraphicalRep.h"

@interface SPGerberCoordinate ()

- (void)renderLineFromPoint:(SPVec)start toPoint:(SPVec)end inContext:(SPGerberRenderingContext *)context;
- (void)renderArcFromPoint:(SPVec)start toPoint:(SPVec)end inContext:(SPGerberRenderingContext*)context;
- (void)renderFlashAtPoint:(SPVec)point inContext:(SPGerberRenderingContext*)context;

@end

@implementation SPGerberCoordinate

- (void)dealloc
{
    [x release];
    [y release];
    [i release];
    [j release];
    
    [super dealloc];
}

@synthesize x;
@synthesize y;
@synthesize i;
@synthesize j;
@synthesize exposureType;

- (NSString*)description
{
    NSMutableString* string;
    
    string = [NSMutableString string];
    [string appendFormat:@"<X:%@ Y:%@ I:%@ J:%@", self.x, self.y, self.i, self.j];
    [string appendFormat:@" %d>", self.exposureType];
    
    return string;
}

- (void)applyToContext:(SPGerberRenderingContext *)context
{
    SPVec startPoint;
    SPVec endPoint;
    
    startPoint = context.lastPosition;
    endPoint   = startPoint;
    
    if (x)
        endPoint.x = [context scaleX:[x doubleValue]];
    
    if (y)
        endPoint.y = [context scaleY:[y doubleValue]];
    
    if (self.exposureType != SPGerberExposureNotSpecified)
        context.activeExposure = self.exposureType;
    
    if (self.exposureType == SPGerberExposureOn)
    {
        switch (context.interpolationMode)
        {
            case LinearInterpolationMode10XScale:
            case LinearInterpolationMode1XScale:
            case LinearInterpolationModePoint1XScale:
            case LinearInterpolationModePoint01XScale:
                [self renderLineFromPoint:startPoint toPoint:endPoint inContext:context];
                break;
            case CircularInterpolationModeClockwise:
            case CircularInterpolationModeCounterclockwise:
                [self renderArcFromPoint:startPoint toPoint:endPoint inContext:context];
                break;
        }
    }
    else if (self.exposureType == SPGerberExposureFlash)
    {
        [self renderFlashAtPoint:endPoint inContext:context];
    }
    
    context.lastPosition = endPoint;
}

- (void)renderLineFromPoint:(SPVec)start toPoint:(SPVec)end inContext:(SPGerberRenderingContext*)context
{
    Quad*  quad;
    double length;
    double angle;
    double xShift;
    double yShift;
    
    quad = [context addQuadToCurrentElement];
    
    // the radius of a circular aperture
    length = [[context.activeAperture.modifiers objectAtIndex:0] doubleValue] / 2.0;
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
}

- (void)renderArcFromPoint:(SPVec)start toPoint:(SPVec)end inContext:(SPGerberRenderingContext*)context
{
    Arc*   arc;
    SPVec  center;
    double radius;
    double length;
    double startAngle;
    double endAngle;
    
    arc = [context addArcToCurrentElement];
    
    length = [[context.activeAperture.modifiers objectAtIndex:0] doubleValue] / 2.0;
    
    if (!context.fullCircleInterpolationEnabled)
    {
        NSLog(@"Non-360 degree interpolation not supported");
        return;
    }
    
    center = SPMakeVec(start.x + [context scaleX:[i doubleValue]], start.y + [context scaleY:[j doubleValue]], 0);
    
    startAngle = -1;
    endAngle   = -1;
    
    //    NSLog(@"(%f,%f) (%f,%f), (%f,%f)", start.x, start.y, end.x, end.y, center.x, center.y);
    
    // The comparisons here are really tricky.  I needed to work it out very carefully on
    // graph paper before I got it.  The direction of rotation matters.  It also makes a difference
    // if we're at the start or end line.
    
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
}

- (void)renderFlashAtPoint:(SPVec)point inContext:(SPGerberRenderingContext*)context
{
}

@end
