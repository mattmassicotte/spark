//
//  PFGerberCoordinate.h
//  Spark
//
//  Created by Matt Massicotte on 2/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

typedef enum _PFGerberLightExposureType {
    PFGerberExposureNotSpecified = 0,
    PFGerberExposureOn           = 1,
	PFGerberExposureOff          = 2,
	PFGerberExposureFlash        = 3
} PFGerberLightExposureType;

@interface PFGerberCoordinate : NSObject
{
    NSNumber*                 x;
    NSNumber*                 y;
    NSNumber*                 i;
    NSNumber*                 j;
    PFGerberLightExposureType exposureType;
}

@property (nonatomic, retain) NSNumber*                 x;
@property (nonatomic, retain) NSNumber*                 y;
@property (nonatomic, retain) NSNumber*                 i;
@property (nonatomic, retain) NSNumber*                 j;
@property (nonatomic)         PFGerberLightExposureType exposureType;

@end
