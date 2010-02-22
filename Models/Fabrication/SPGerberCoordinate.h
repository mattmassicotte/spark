//
//  SPGerberCoordinate.h
//  Spark
//
//  Created by Matt Massicotte on 2/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SPGerberStatement.h"
#import "SPGerberDCode.h"

@interface SPGerberCoordinate : SPGerberStatement
{
    NSNumber*            x;
    NSNumber*            y;
    NSNumber*            i;
    NSNumber*            j;
    SPGerberExposureType exposureType;
}

@property (nonatomic, retain) NSNumber*            x;
@property (nonatomic, retain) NSNumber*            y;
@property (nonatomic, retain) NSNumber*            i;
@property (nonatomic, retain) NSNumber*            j;
@property (nonatomic)         SPGerberExposureType exposureType;

@end
