//
//  SPGerberOffset.h
//  Spark
//
//  Created by Matt Massicotte on 2/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SPGerberParameter.h"

@interface SPGerberOffset : SPGerberParameter
{
    double aOffset;
    double bOffset;
}

@property (nonatomic) double aOffset;
@property (nonatomic) double bOffset;

@end
