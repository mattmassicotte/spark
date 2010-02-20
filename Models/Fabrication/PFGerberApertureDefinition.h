//
//  PFGerberApertureDefinition.h
//  Spark
//
//  Created by Matt Massicotte on 2/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

typedef enum _PFGerberApertureType {
    PFGerberApertureCircle,
	PFGerberApertureRectangle,
	PFGerberApertureObround,
	PFGerberAperturePolygon,
    PFGerberApertureMacroReference
} PFGerberApertureType;

@interface PFGerberApertureDefinition : NSObject
{
    PFGerberApertureType apertureType;
    NSUInteger           dCode;
    NSString*            macroName;
    NSMutableArray*      modifiers;
}

@property (nonatomic)           PFGerberApertureType apertureType;
@property (nonatomic)           NSUInteger           dCode;
@property (nonatomic, copy)     NSString*            macroName;
@property (nonatomic, readonly) NSMutableArray*      modifiers;

- (void)addModifier:(NSNumber*)modifier;

@end
