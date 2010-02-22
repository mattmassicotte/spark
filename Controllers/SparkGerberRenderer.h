//
//  SparkGerberRenderer.h
//  Spark
//
//  Created by Matt Massicotte on 2/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SPFabrication.h"

@class CAMLayer, DesignElement;

@interface SparkGerberRenderer : NSObject <SPGerberParserDelegate>
{
    NSMutableDictionary*        apertureDefinitions;
    PFGerberApertureDefinition* activeAperture;
    PFGerberCoordinate*         lastCoordinate;
    PFGerberLightExposureType   activeExposure;
    double                      lastXValue;
    double                      lastYValue;
    BOOL                        fullCircleInterpolationEnabled;
    
    CAMLayer*                   camLayer;
    DesignElement*              currentElement;
    
    SparkGerberRenderedInterpolationMode interpolationMode;
    
    double                      xScaling;
    double                      yScaling;
    
    double                      maximumX;
    double                      minimumX;
    double                      maximumY;
    double                      minimumY;
}

@property (nonatomic, readonly) double                  maximumX;
@property (nonatomic, readonly) double                  minimumX;
@property (nonatomic, readonly) double                  maximumY;
@property (nonatomic, readonly) double                  minimumY;

- (BOOL)renderGerberFile:(NSURL*)url onCAMLayer:(CAMLayer*)layer;

@end
