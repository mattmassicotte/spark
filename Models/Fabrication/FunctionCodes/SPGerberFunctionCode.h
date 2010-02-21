//
//  SPGerberFunctionCode.h
//  Spark
//
//  Created by Matt Massicotte on 2/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SPGerberStatement.h"

@interface SPGerberFunctionCode : SPGerberStatement
{
    NSUInteger               code;
}

+ (id)functionCodeWithIdentifier:(NSString*)identifier;

@property (nonatomic) NSUInteger               code;

@end
