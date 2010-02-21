//
//  PFGerberFunctionCode.m
//  Spark
//
//  Created by Matt Massicotte on 2/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SPGerberFunctionCode.h"
#import "SPGerberGCode.h"
#import "SPGerberDCode.h"
#import "SPGerberMCode.h"

@implementation SPGerberFunctionCode

+ (id)functionCodeWithIdentifier:(NSString*)identifier
{
    Class functionCodeClass;
    
    if ([identifier isEqualToString:@"N"])
    {
    }
    else if ([identifier isEqualToString:@"G"])
    {
        functionCodeClass = [SPGerberGCode class];
    }
    else if ([identifier isEqualToString:@"D"])
    {
        functionCodeClass = [SPGerberDCode class];
    }
    else if ([identifier isEqualToString:@"M"])
    {
        functionCodeClass = [SPGerberMCode class];
    }
    else
    {
        [NSException raise:@"SPUnrecognizedGerberFunctionCode"
                    format:@"Encountered a function code with an identifier of %@", identifier];
        
        return nil;
    }

    return [[functionCodeClass new] autorelease];
}

@synthesize code;

@end
