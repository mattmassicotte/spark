//
//  PFGerberFormat.h
//  Spark
//
//  Created by Matt Massicotte on 2/9/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SPGerberParameter.h"

@interface PFGerberFormat : SPGerberParameter
{
    BOOL omitLeadingZeros;
    BOOL omitTrailingZeros;
}

@property (nonatomic) BOOL omitLeadingZeros;
@property (nonatomic) BOOL omitTrailingZeros;

@end
