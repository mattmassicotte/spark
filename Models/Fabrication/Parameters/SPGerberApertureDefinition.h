//
//  SPGerberApertureDefinition.h
//  Spark
//
//  Created by Matt Massicotte on 2/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SPGerberParameter.h"

typedef enum _SPGerberApertureType {
    SPGerberApertureCircle,
	SPGerberApertureRectangle,
	SPGerberApertureObround,
	SPGerberAperturePolygon,
    SPGerberApertureMacroReference
} SPGerberApertureType;

@interface SPGerberApertureDefinition : SPGerberParameter
{
    SPGerberApertureType apertureType;
    NSUInteger           dCode;
    NSString*            macroName;
    NSMutableArray*      modifiers;
}

@property (nonatomic)           SPGerberApertureType apertureType;
@property (nonatomic)           NSUInteger           dCode;
@property (nonatomic, copy)     NSString*            macroName;
@property (nonatomic, readonly) NSMutableArray*      modifiers;

- (void)addModifier:(NSNumber*)modifier;

@end
