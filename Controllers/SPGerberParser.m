//
//  SPGerberParser.m
//  Spark
//
//  Created by Matt Massicotte on 2/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SPGerberParser.h"
#import "PFGerberFormat.h"
#import "SPGerberUnitMode.h"
#import "SPGerberOffset.h"
#import "SPGerberScaleFactor.h"
#import "SPGerberLayerName.h"
#import "SPGerberImagePolarity.h"
#import "SPGerberLayerPolarity.h"
#import "SPGerberFunctionCode.h"
#import "PFGerberCoordinate.h"
#import "PFGerberApertureDefinition.h"
#import "PFGerberApertureMacro.h"

#import "NSScannerExtensions.h"

@interface SPGerberParser ()

@property (nonatomic, retain) NSScanner* scanner;

- (BOOL)parseNextStatement;
- (BOOL)parseFunctionCode;
- (BOOL)parseParameter;
- (BOOL)parseCoordinate;

- (SPGerberParameter*)parseFormatStatement;
- (SPGerberParameter*)parseModeOfUnits;
- (SPGerberParameter*)parseOffset;
- (SPGerberParameter*)parseScaleFactor;
- (SPGerberParameter*)parseApertureDefinition;
- (SPGerberParameter*)parserApertureMacro;
- (SPGerberParameter*)parseLayerName;
- (SPGerberParameter*)parseImagePolarity;
- (SPGerberParameter*)parseLayerPolarity;

@end

@implementation SPGerberParser

- (id)initWithContentsOfURL:(NSURL*)url
{
	self = [super init];
	if (self)
	{
        self.delegate = nil;
        
		fileContents = [[NSString alloc] initWithContentsOfURL:url
													  encoding:NSASCIIStringEncoding
														 error:nil];
        
        if (!fileContents)
        {
            [self release];
            return nil;
        }
        
        endOfDataBlockCharacterSet = [[NSCharacterSet characterSetWithCharactersInString:@"\n*%"] retain];
        
        startOfDataBlockCharacterSet = [[NSCharacterSet characterSetWithCharactersInString:@"%ADFGIJLMOSXY"] retain];
        
        numericCharacterSet = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] retain];
	}
    
	return self;
}

- (void)dealloc
{
    [fileContents release];
    [scanner release];
    [endOfDataBlockCharacterSet release];
    [startOfDataBlockCharacterSet release];
    [numericCharacterSet release];
    
    [super dealloc];
}

@synthesize delegate;
@synthesize scanner;

- (BOOL)parse
{
    NSCharacterSet* whitespaceAndNewlineCharacterSet;
    
    self.scanner = [NSScanner scannerWithString:fileContents];
    [self.scanner setCharactersToBeSkipped:nil];
    [self.scanner setCaseSensitive:NO];
    
    whitespaceAndNewlineCharacterSet = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    
    [self.scanner scanCharactersFromSet:whitespaceAndNewlineCharacterSet intoString:nil];
    
    parsingParameters = NO;
    
    if ([delegate respondsToSelector:@selector(parserDidStartDocument:)])
    {
        [delegate parserDidStartDocument:self];
    }
    
	while (![self.scanner isAtEnd])
	{
        if (![self parseNextStatement])
        {
            NSLog(@"Failed to parse a statement");
            return NO;
        }
        
        [self.scanner scanCharactersFromSet:whitespaceAndNewlineCharacterSet intoString:nil];
	}
	
    if ([delegate respondsToSelector:@selector(parserDidEndDocument:)])
    {
        [delegate parserDidEndDocument:self];
    }
    
	return YES;
}

- (BOOL)parseNextStatement
{
    [self.scanner scanUpToCharactersFromSet:startOfDataBlockCharacterSet intoString:nil];

    if ([scanner currentCharacter] == '%')
    {
        [self.scanner scanString:@"%" intoString:nil];
        parsingParameters = !parsingParameters;
        return YES;
    }
    
    if (parsingParameters)
        return [self parseParameter];
    
    switch ([scanner currentCharacter])
    {
        case 'x':
        case 'X':
        case 'y':
        case 'Y':
        case 'i':
        case 'I':
        case 'j':
        case 'J':
            return [self parseCoordinate];
        case 'N':
        case 'G':
        case 'D':
        case 'M':
            return [self parseFunctionCode];
    }
    
    return NO;
}

- (BOOL)parseFunctionCode
{
    NSString*             identifier;
    SPGerberFunctionCode* functionCode;
    NSInteger             integerValue;
    
    [scanner scanUpToCharactersFromSet:numericCharacterSet intoString:&identifier];
    
    functionCode = [SPGerberFunctionCode functionCodeWithIdentifier:identifier];
    
    [scanner scanInteger:&integerValue];
    functionCode.code = integerValue;
    
    // we need to special-case comments
    if ([identifier isEqualToString:@"G"] && (integerValue == 4))
    {
        // ignore data block
        [scanner scanUpToCharactersFromSet:endOfDataBlockCharacterSet intoString:nil];
    }
    
    if ([delegate respondsToSelector:@selector(parser:foundFunctionCode:)])
    {
        [delegate parser:self foundFunctionCode:functionCode];
    }
    else if ([delegate respondsToSelector:@selector(parser:foundStatement:)])
    {
        [delegate parser:self foundStatement:functionCode];
    }
    
    // scan the *, which may or may not actually be there
    [self.scanner scanString:@"*" intoString:nil];
    
	return YES;
}

- (BOOL)parseParameter
{
	NSString*          code;
    SPGerberParameter* parameter;
    
    code = [[scanner string] substringWithRange:NSMakeRange([scanner scanLocation], 2)];
    
    parameter = nil;
    
    if ([code isEqualToString:@"AS"]) // axis select
    {
    }
    else if ([code isEqualToString:@"FS"]) // format statement
    {
        parameter = [self parseFormatStatement];
    }
    else if ([code isEqualToString:@"MI"]) // mirror image
    {
    }
    else if ([code isEqualToString:@"MO"]) // mode of units
    {
        parameter = [self parseModeOfUnits];
    }
    else if ([code isEqualToString:@"OF"]) // offset
    {
        parameter = [self parseOffset];
    }
    else if ([code isEqualToString:@"SF"]) // scale factor
    {
        parameter = [self parseScaleFactor];
    }
    else if ([code isEqualToString:@"IJ"]) // image justify
    {
    }
    else if ([code isEqualToString:@"IN"]) // image name
    {
    }
    else if ([code isEqualToString:@"IO"]) // image offset
    {
    }
    else if ([code isEqualToString:@"IP"]) // image polarity
    {
        parameter = [self parseImagePolarity];
    }
    else if ([code isEqualToString:@"IR"]) // image rotation
    {
    }
    else if ([code isEqualToString:@"PF"]) // plotter film
    {
    }
    else if ([code isEqualToString:@"AD"]) // aperture description
    {
        parameter = [self parseApertureDefinition];
    }
    else if ([code isEqualToString:@"AM"]) // aperture macro
    {
        parameter = [self parserApertureMacro];
    }
    else if ([code isEqualToString:@"KO"]) // knockout
    {
    }
    else if ([code isEqualToString:@"LN"]) // layer name
    {
        parameter = [self parseLayerName];
    }
    else if ([code isEqualToString:@"LP"]) // layer polarity
    {
        parameter = [self parseLayerPolarity];
    }
    else if ([code isEqualToString:@"SR"]) // step and repeat
    {
    }
    else if ([code isEqualToString:@"IF"]) // include file
    {
    }
    
    if (parameter == nil)
        return NO;
    
    if ([delegate respondsToSelector:@selector(parser:foundParameter:)])
    {
        [delegate parser:self foundParameter:parameter];
    }
    else if ([delegate respondsToSelector:@selector(parser:foundStatement:)])
    {
        [delegate parser:self foundStatement:parameter];
    }
    
	return YES;
}

- (BOOL)parseCoordinate
{
    PFGerberCoordinate* coordinate;
    double              doubleValue;
    NSInteger           integerValue;
	
    coordinate = [PFGerberCoordinate new];
    
    if ([scanner scanString:@"X" intoString:nil])
    {
        [scanner scanDouble:&doubleValue];
        coordinate.x = [NSNumber numberWithDouble:doubleValue];
    }
    
    if ([scanner scanString:@"Y" intoString:nil])
    {
        [scanner scanDouble:&doubleValue];
        coordinate.y = [NSNumber numberWithDouble:doubleValue];
    }
    
    if ([scanner scanString:@"I" intoString:nil])
    {
        [scanner scanDouble:&doubleValue];
        coordinate.i = [NSNumber numberWithDouble:doubleValue];
    }
    
    if ([scanner scanString:@"J" intoString:nil])
    {
        [scanner scanDouble:&doubleValue];
        coordinate.j = [NSNumber numberWithDouble:doubleValue];
    }
    
    if ([scanner scanString:@"D" intoString:NULL])
    {
        [scanner scanInteger:&integerValue];
        coordinate.exposureType = integerValue;
    }
    
    if ([delegate respondsToSelector:@selector(parser:foundCoordinate:)])
    {
        [delegate parser:self foundCoordinate:coordinate];
    }
    else if ([delegate respondsToSelector:@selector(parser:foundStatement:)])
    {
        [delegate parser:self foundStatement:coordinate];
    }
    
    [coordinate release];
    
    [scanner scanString:@"*" intoString:nil];
    
	return YES;
}

#pragma mark Parameters

- (SPGerberParameter*)parseFormatStatement
{
    PFGerberFormat* format;
    NSInteger       integerValue;
    
    format = [PFGerberFormat new];
    
    // FS<L or T><A or I>[Nn][Gn]<Xn><Yn>[Dn][Mn]
    
    [scanner scanString:@"FS" intoString:nil];
    
    while (![scanner scanString:@"*" intoString:nil])
    {
        switch ([scanner currentCharacter])
        {
            case 'L': // omit leading zeros
                [scanner scanString:@"L" intoString:nil];
                format.omitLeadingZeros = YES;
                break;
            case 'T': // omit trailing zeros
                [scanner scanString:@"T" intoString:nil];
                format.omitTrailingZeros = YES;
                break;
            case 'A':
                [scanner scanString:@"A" intoString:nil];
                // absolute coordinates
                break;
            case 'I':
                [scanner scanString:@"I" intoString:nil];
                // incremetal coordinates
                break;
            case 'N':
                [scanner scanString:@"N" intoString:nil];
                [scanner scanInteger:&integerValue];
                break;
            case 'G':
                [scanner scanString:@"G" intoString:nil];
                [scanner scanInteger:&integerValue];
                break;
            case 'X':
                [scanner scanString:@"X" intoString:nil];
                [scanner scanInteger:&integerValue];
                break;
            case 'Y':
                [scanner scanString:@"Y" intoString:nil];
                [scanner scanInteger:&integerValue];
                break;
            case 'D':
                [scanner scanString:@"D" intoString:nil];
                [scanner scanInteger:&integerValue];
                break;
            case 'M':
                [scanner scanString:@"M" intoString:nil];
                [scanner scanInteger:&integerValue];
                break;
            default:
                NSLog(@"invalid character in format statement '%c'", [scanner currentCharacter]);
                return NO;
                
        }
    }
    
    return [format autorelease];
}

- (SPGerberParameter*)parseModeOfUnits
{
    SPGerberUnitMode* mode;
    
    [scanner scanString:@"MO" intoString:nil];
    
    mode = [SPGerberUnitMode new];
    
    if ([scanner scanString:@"MM" intoString:nil])
    {
        mode.usingInches = NO;
    }
    else if ([scanner scanString:@"IN" intoString:nil])
    {
        mode.usingInches = YES;
    }
    else
    {
        NSLog(@"Unexpected string in MO parameter");
        return NO;
    }
    
    return [mode autorelease];
}

- (SPGerberParameter*)parseOffset
{
    SPGerberOffset* offset;
    double          value;
    
    offset = [SPGerberOffset new];
    
    [scanner scanString:@"OF" intoString:nil];
    
    [scanner scanString:@"A" intoString:nil];
    [scanner scanDouble:&value];
    offset.aOffset = value;
    
    [scanner scanString:@"B" intoString:nil];
    [scanner scanDouble:&value];
    offset.bOffset = value;
    
    [scanner scanString:@"*" intoString:nil];
    
    return [offset autorelease];
}

- (SPGerberParameter*)parseScaleFactor
{
    SPGerberScaleFactor* scaleFactor;
    double               value;
    
    scaleFactor = [SPGerberScaleFactor new];
    
    [scanner scanString:@"SF" intoString:nil];
    
    [scanner scanString:@"A" intoString:nil];
    [scanner scanDouble:&value];
    scaleFactor.aScale = value;
    
    [scanner scanString:@"B" intoString:nil];
    [scanner scanDouble:&value];
    scaleFactor.bScale = value;

    [scanner scanString:@"*" intoString:nil];

    return [scaleFactor autorelease];
}

- (SPGerberParameter*)parseApertureDefinition
{
    PFGerberApertureDefinition* definition;
    NSString*                   apertureType;
    NSInteger                   integerValue;
    double                      doubleValue;
    
    definition = [PFGerberApertureDefinition new];
    
    [scanner scanString:@"ADD" intoString:nil];
    [scanner scanInteger:&integerValue];
    definition.dCode = integerValue;
    
    [scanner scanUpToCharactersFromSet:[NSCharacterSet characterSetWithCharactersInString:@"1234567890,"] intoString:&apertureType];

    if ([apertureType isEqualToString:@"C"])
    {
        [scanner scanString:@"C" intoString:nil];
        definition.apertureType = PFGerberApertureCircle;
    }
    else if ([apertureType isEqualToString:@"R"])
    {
        [scanner scanString:@"R" intoString:nil];
        definition.apertureType = PFGerberApertureRectangle;
    }
    else if ([apertureType isEqualToString:@"O"])
    {
        [scanner scanString:@"O" intoString:nil];
        definition.apertureType = PFGerberApertureObround;
    }
    else if ([apertureType isEqualToString:@"P"])
    {
        [scanner scanString:@"P" intoString:nil];
        definition.apertureType = PFGerberAperturePolygon;
    }
    else
    {
        definition.apertureType = PFGerberApertureMacroReference;
        definition.macroName = apertureType;
    }
    
    if ([scanner scanString:@"," intoString:nil])
    {
        [scanner scanDouble:&doubleValue];
        [definition addModifier:[NSNumber numberWithDouble:doubleValue]];
        
        [scanner scanString:@"X" intoString:nil]; // may or may not be there
    }
    
    // this will scan the second parameter after an X, or the numeric value after a 
    // macro name
    [scanner scanDouble:&doubleValue];
    [definition addModifier:[NSNumber numberWithDouble:doubleValue]];
    
    [scanner scanString:@"*" intoString:nil];
    
    return [definition autorelease];
}

- (SPGerberParameter*)parserApertureMacro
{
    PFGerberApertureMacro* macro;
    NSString*              string;
    NSInteger              integer;
    NSCharacterSet*        modifierEndCharacterSet;
    
    [self.scanner scanString:@"AM" intoString:nil];
    
    macro = [PFGerberApertureMacro new];
    
    // this parameter can easily span a multiple lines
    [self.scanner setCharactersToBeSkipped:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    // next up is the aperture macro name
    [self.scanner scanUpToString:@"*" intoString:&string];
    macro.name = string;
    [self.scanner scanString:@"*" intoString:nil];
    
    // followed by the integer code for aperture type
    [self.scanner scanInteger:&integer];
    macro.type = integer;
    [self.scanner scanString:@"," intoString:nil];
    
    modifierEndCharacterSet = [NSCharacterSet characterSetWithCharactersInString:@",*"];
    
    while ([self.scanner scanUpToCharactersFromSet:modifierEndCharacterSet intoString:&string])
    {
        //NSLog(@"expression: %@", string);
        //
        if ([self.scanner scanString:@"," intoString:nil])
            continue;
        
        if ([self.scanner scanString:@"*" intoString:nil])
            break;
    }

    // reset the scanning behavior
    [self.scanner setCharactersToBeSkipped:nil];

    return [macro autorelease];
}

- (SPGerberParameter*)parseLayerName
{
    SPGerberLayerName* layerName;
    NSString* name;
    
    layerName = [SPGerberLayerName new];
    
    [scanner scanString:@"LN" intoString:nil];
    
    [scanner scanUpToCharactersFromSet:endOfDataBlockCharacterSet intoString:&name];
    layerName.name = name;
    
    [scanner scanString:@"*" intoString:nil];
    
    return [layerName autorelease];
}

- (SPGerberParameter*)parseImagePolarity
{
    SPGerberImagePolarity* polarity;
    
    polarity = [SPGerberImagePolarity new];
    
    [scanner scanString:@"IP" intoString:nil];
    
    if ([scanner scanString:@"POS" intoString:nil])
    {
        polarity.isPositive = YES;
    }
    else if ([scanner scanString:@"NEG" intoString:nil])
    {
        polarity.isPositive = NO;
    }
    else {
        NSLog(@"Malformed image polarity parameter");
        return nil;
    }

    [scanner scanString:@"*" intoString:nil];
    
    return [polarity autorelease];
}

- (SPGerberParameter*)parseLayerPolarity
{
    SPGerberLayerPolarity* polarity;
    
    polarity = [SPGerberLayerPolarity new];
    
    [scanner scanString:@"LP" intoString:nil];
    
    if ([scanner scanString:@"D" intoString:nil])
    {
        polarity.isDark = YES;
    }
    else if ([scanner scanString:@"C" intoString:nil])
    {
        polarity.isDark = NO;
    }
    else {
        NSLog(@"Malformed layer polarity parameter");
        return NO;
    }
    
    [scanner scanString:@"*" intoString:nil];
    
    return [polarity autorelease];
}

@end
