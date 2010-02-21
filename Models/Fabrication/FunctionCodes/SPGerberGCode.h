//
//  SPGerberGCode.h
//  Spark
//
//  Created by Matt Massicotte on 2/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SPGerberFunctionCode.h"

enum _PFGerberGCodes {
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

@interface SPGerberGCode : SPGerberFunctionCode
{
}

@end
