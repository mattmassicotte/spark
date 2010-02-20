//
//  PFGerberApertureMacro.h
//  Spark
//
//  Created by Matt Massicotte on 2/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

typedef enum _PFGerberApertureMacroPrimitiveType
{
    PFGerberApertureMacroCircle          = 1,
    PFGerberApertureMacroLineVector      = 2,
    PFGerberApertureMacroOtherLineVector = 20,
    PFGerberApertureMacroLineCenter      = 21,
    PFGerberApertureMacroLineLowerLeft   = 22,
    PFGerberApertureMacroFileEnd         = 3,
    PFGerberApertureMacroOutline         = 4,
    PFGerberApertureMacroPolygon         = 5,
    PFGerberApertureMacroMoire           = 6,
    PFGerberApertureMacroThermal         = 7
} PFGerberApertureMacroPrimitiveType;

#define PFGerberApertureMacroMaxModifiers 50

@interface PFGerberApertureMacro : NSObject
{
    NSString*                          name;
    PFGerberApertureMacroPrimitiveType type;
}

@property (nonatomic, copy)   NSString*                          name;
@property (nonatomic, assign) PFGerberApertureMacroPrimitiveType type;

@end
