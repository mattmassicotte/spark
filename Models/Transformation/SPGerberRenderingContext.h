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

typedef enum _SparkGerberInterpolationMode
{
    LinearInterpolationMode10XScale,
    LinearInterpolationMode1XScale,
    LinearInterpolationModePoint1XScale,
    LinearInterpolationModePoint01XScale,
    CircularInterpolationModeClockwise,
    CircularInterpolationModeCounterclockwise,
} SparkGerberInterpolationMode;

@class PCBSublayer;
@class SPGerberOffset, SPGerberApertureDefinition;

@interface SPGerberRenderingContext : NSObject <SPGerberParserDelegate>
{
    PCBSublayer* sublayer;
    
    SparkGerberInterpolationMode interpolationMode;
    BOOL                         fullCircleInterpolationEnabled;
    BOOL                         usingInches;
    
    SPGerberOffset*              offset;
    
    NSMutableDictionary*         apertures;
    SPGerberApertureDefinition*  activeAperture;
    SPGerberExposureType         activeExposure;
}

- (id)initWithPCBSublayer:(PCBSublayer*)aSublayer;

@property (nonatomic, assign) SparkGerberInterpolationMode interpolationMode;
@property (nonatomic, assign) BOOL                         fullCircleInterpolationEnabled;
@property (nonatomic, assign) BOOL                         usingInches;
@property (nonatomic, retain) SPGerberOffset*              offset;
@property (nonatomic, assign) SPGerberExposureType         activeExposure;

- (void)addApertureDefinition:(SPGerberApertureDefinition*)definition;
- (void)setActiveAperture:(NSUInteger)apertureNumber;

@end
