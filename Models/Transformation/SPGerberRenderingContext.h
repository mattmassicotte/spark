//
//  SPGerberRenderingContext.h
//  Spark
//
//  Created by Matt Massicotte on 2/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SPGerberParser.h"
#import "SPGerberDCode.h"
#import "SPGeometry.h"

typedef enum _SparkGerberInterpolationMode
{
    LinearInterpolationMode10XScale,
    LinearInterpolationMode1XScale,
    LinearInterpolationModePoint1XScale,
    LinearInterpolationModePoint01XScale,
    CircularInterpolationModeClockwise,
    CircularInterpolationModeCounterclockwise,
} SparkGerberInterpolationMode;

@class PCBSublayer, DesignElement, Quad, Arc;
@class SPGerberOffset, SPGerberApertureDefinition;

@interface SPGerberRenderingContext : NSObject <SPGerberParserDelegate>
{
    PCBSublayer*                 sublayer;
    DesignElement*               currentElement;
    
    SparkGerberInterpolationMode interpolationMode;
    BOOL                         fullCircleInterpolationEnabled;
    BOOL                         usingInches;
    
    SPVec                        offset;
    SPVec                        scale;
    
    NSMutableDictionary*         apertures;
    SPGerberApertureDefinition*  activeAperture;
    SPGerberExposureType         activeExposure;
    
    SPVec                        lastPosition;
}

- (id)initWithPCBSublayer:(PCBSublayer*)aSublayer;

@property (nonatomic)                   SparkGerberInterpolationMode interpolationMode;
@property (nonatomic)                   BOOL                         fullCircleInterpolationEnabled;
@property (nonatomic)                   BOOL                         usingInches;
@property (nonatomic)                   SPVec                        offset;
@property (nonatomic)                   SPGerberExposureType         activeExposure;
@property (nonatomic)                   SPVec                        lastPosition;
@property (nonatomic, retain, readonly) SPGerberApertureDefinition*  activeAperture;

- (double)scaleX:(double)xValue;
- (double)scaleY:(double)yValue;
- (SPVec)scalePoint:(SPVec)point;

- (void)addApertureDefinition:(SPGerberApertureDefinition*)definition;
- (void)setActiveAperture:(NSUInteger)apertureNumber;

- (void)startElement;
- (void)finishElement;
- (Quad*)addQuadToCurrentElement;
- (Arc*)addArcToCurrentElement;

@end
