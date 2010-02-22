//
//  SPGerberStatement.h
//  Spark
//
//  Created by Matt Massicotte on 2/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class SPGerberRenderingContext;

@interface SPGerberStatement : NSObject
{
}

- (void)applyToContext:(SPGerberRenderingContext*)context;

@end
