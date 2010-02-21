//
//  SPGerberImagePolarity.h
//  Spark
//
//  Created by Matt Massicotte on 2/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SPGerberParameter.h"

@interface SPGerberImagePolarity : SPGerberParameter
{
    BOOL isPositive;
}

@property (nonatomic) BOOL isPositive;

@end
