//
//  SPGerberLayerName.h
//  Spark
//
//  Created by Matt Massicotte on 2/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SPGerberParameter.h"

@interface SPGerberLayerName : SPGerberParameter
{
    NSString* name;
}

@property (nonatomic, copy) NSString* name;

@end
