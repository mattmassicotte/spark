//
//  SPGerberScaleFactor.h
//  Spark
//
//  Created by Matt Massicotte on 2/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SPGerberParameter.h"

@interface SPGerberScaleFactor : SPGerberParameter
{
    double aScale;
    double bScale;
}

@property (nonatomic) double aScale;
@property (nonatomic) double bScale;

@end
