//
//  SPGerberFunctionCode.h
//  Spark
//
//  Created by Matt Massicotte on 2/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

typedef enum _PFGerberFunctionCodeType {
    PFGerberFunctionCodeNCode,
	PFGerberFunctionCodeGCode,
	PFGerberFunctionCodeDCode,
	PFGerberFunctionCodeMCode,
} PFGerberFunctionCodeType;

enum _PFGerberFunctionCodeGCodes {
    PFGerberGCodeMove                                  = 0,
	PFGerberGCodeLinearInterpolation                   = 1,
	PFGerberGCodeClockwiseInterpolation                = 2,
	PFGerberGCodeCouterclockwiseInterpolation          = 3,
    PFGerberGCodeIgnore                                = 4,
    PFGerberGCode10XLinearInterpolation                = 10,
    PFGerberGCodeOne10thXLinearInterpolation           = 11,
    PFGerberGCodeOne100thXLinearInterpolation          = 12,
    PFGerberGCodePolygonAreaFillOn                     = 36,
    PFGerberGCodePolygonAreaFillOff                    = 37,
    PFGerberGCodeToolPrepare                           = 54,
    PFGerberGCodeInchs                                 = 70,
    PFGerberGCodeMillimeters                           = 71,
    PFGerberGCodeDisableCircularInterpolation          = 74,
    PFGerberGCodeEnable360DegreeCircularInterpolation  = 75,
    PFGerberGCodeAbsoluteFormat                        = 90,
    PFGerberGCodeIncrementalFormat                     = 91
};

@interface SPGerberFunctionCode : NSObject
{
    PFGerberFunctionCodeType type;
    NSUInteger               code;
    
    double                   xValue;
    double                   yValue;
    double                   iValue;
    double                   jValue;
    NSUInteger               dCode;
}

@property (nonatomic) PFGerberFunctionCodeType type;
@property (nonatomic) NSUInteger               code;
@property (nonatomic) double                   xValue;
@property (nonatomic) double                   yValue;
@property (nonatomic) double                   iValue;
@property (nonatomic) double                   jValue;
@property (nonatomic) NSUInteger               dCode;

@end
