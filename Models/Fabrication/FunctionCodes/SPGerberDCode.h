//
//  SPGerberDCode.h
//  Spark
//
//  Created by Matt Massicotte on 2/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SPGerberFunctionCode.h"

typedef enum _SPGerberExposureType {
    SPGerberExposureNotSpecified = 0,
    SPGerberExposureOn           = 1,
	SPGerberExposureOff          = 2,
	SPGerberExposureFlash        = 3
} SPGerberExposureType;

@interface SPGerberDCode : SPGerberFunctionCode
{
}

@end
