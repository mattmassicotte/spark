//
//  SPGerberParser.m
//  Spark
//
//  Created by Matt Massicotte on 2/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SPGerberParser.h"
#import "PFGerberFormat.h"
#import "PFGerberFunctionCode.h"
#import "PFGerberCoordinate.h"
#import "PFGerberApertureDefinition.h"
#import "PFGerberApertureMacro.h"

#import "NSScannerExtensions.h"

@interface SPGerberParser ()

@property (nonatomic, retain) NSScanner* scanner;

- (BOOL)parseNextStatement;
- (BOOL)parseFunctionCode;
- (BOOL)finishParsingGCode:(PFGerberFunctionCode*)functionCode;
- (BOOL)parseParameter;
- (BOOL)parseCoordinate;

- (BOOL)parseFormatStatement;
- (BOOL)parseModeOfUnits;
- (BOOL)parseOffset;
- (BOOL)parseScaleFactor;
- (BOOL)parseApertureDefinition;
- (BOOL)parserApertureMacro;
- (BOOL)parseLayerName;
- (BOOL)parseImagePolarity;
- (BOOL)parseLayerPolarity;

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
        
        endOfDataBlockCharacterSet = [[NSCharacterSet characterSetWithCharactersInString:@"\n*"] retain];
        
        startOfDataBlockCharacterSet = [[NSCharacterSet characterSetWithCharactersInString:@"%ADFGIJLMOSXY"] retain];
	}
    
	return self;
}

- (void)dealloc
{
    [fileContents release];
    [scanner release];
    [endOfDataBlockCharacterSet release];
    [startOfDataBlockCharacterSet release];
    
    [super dealloc];
}

@synthesize delegate;
@synthesize scanner;

- (BOOL)parse
{
    self.scanner = [NSScanner scannerWithString:fileContents];
    [self.scanner setCharactersToBeSkipped:nil];
    [self.scanner setCaseSensitive:NO];
    
    [self.scanner scanCharactersFromSet:[NSCharacterSet whitespaceAndNewlineCharacterSet] intoString:nil];
    
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
        
        [self.scanner scanCharactersFromSet:[NSCharacterSet whitespaceAndNewlineCharacterSet] intoString:nil];
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
    PFGerberFunctionCode* functionCode;
    NSInteger             integerValue;
    
    functionCode = [PFGerberFunctionCode new];
    
    if ([scanner scanString:@"N" intoString:nil]) // N-Code
    {
        functionCode.type = PFGerberFunctionCodeNCode;
    }
    else if ([scanner scanString:@"G" intoString:nil]) // G-Code
    {
        functionCode.type = PFGerberFunctionCodeGCode;
    }
    else if ([scanner scanString:@"D" intoString:nil]) // D-Code
    {
        functionCode.type = PFGerberFunctionCodeDCode;
    }
    else if ([scanner scanString:@"M" intoString:nil]) // M-Code
    {
        functionCode.type = PFGerberFunctionCodeMCode;
    }
    else
    {
        NSLog(@"found an unsupported function code");
        return NO;
    }
    
    [scanner scanInteger:&integerValue];
    functionCode.code = integerValue;
    
    // scan remainder
    if (functionCode.type == PFGerberFunctionCodeGCode)
    {
        [self finishParsingGCode:functionCode];
    }

    [scanner scanCharactersFromSet:endOfDataBlockCharacterSet intoString:nil];
	
    if ([delegate respondsToSelector:@selector(parser:foundFunctionCode:)])
    {
        [delegate parser:self foundFunctionCode:functionCode];
    }
    
    switch ([functionCode type]) {
        case PFGerberFunctionCodeGCode:
            if ([delegate respondsToSelector:@selector(parser:foundGCode:)])
                [delegate parser:self foundGCode:functionCode];
            break;
        case PFGerberFunctionCodeDCode:
            if ([delegate respondsToSelector:@selector(parser:foundDCode:)])
                [delegate parser:self foundDCode:functionCode];
            break;
    }
    
    [functionCode release];
    
	return YES;
}

- (BOOL)finishParsingGCode:(PFGerberFunctionCode*)functionCode
{
    NSInteger integerValue;
    double    doubleValue;
    
    if (functionCode.code == 4)
    {
        // ignore data block
        [scanner scanUpToCharactersFromSet:endOfDataBlockCharacterSet intoString:nil];
        return YES;
    }
    if ([scanner scanString:@"X" intoString:nil])
    {
        [scanner scanDouble:&doubleValue];
        functionCode.xValue = doubleValue;
    }
    
    if ([scanner scanString:@"Y" intoString:nil])
    {
        [scanner scanDouble:&doubleValue];
        functionCode.yValue = doubleValue;
    }
    
    if ([scanner scanString:@"I" intoString:nil])
    {
        [scanner scanDouble:&doubleValue];
        functionCode.iValue = doubleValue;
    }
    
    if ([scanner scanString:@"J" intoString:nil])
    {
        [scanner scanDouble:&doubleValue];
        functionCode.jValue = doubleValue;
    }
    
    if ([scanner scanString:@"D" intoString:nil])
    {
        [scanner scanInteger:&integerValue];
        functionCode.dCode = integerValue;
    }
    
    return YES;
}

- (BOOL)parseParameter
{
	NSString* code;
    BOOL      result;
    
    code = [[scanner string] substringWithRange:NSMakeRange([scanner scanLocation], 2)];
    
    result = NO;
    
    if ([code isEqualToString:@"AS"]) // axis select
    {
//        parameter.type = PFGerberParameterAxisSelect;
    }
    else if ([code isEqualToString:@"FS"]) // format statement
    {
        result = [self parseFormatStatement];
    }
    else if ([code isEqualToString:@"MI"]) // mirror image
    {
 //       parameter.type = PFGerberParameterMirrorImage;
    }
    else if ([code isEqualToString:@"MO"]) // mode of units
    {
        result = [self parseModeOfUnits];
    }
    else if ([code isEqualToString:@"OF"]) // offset
    {
        result = [self parseOffset];
    }
    else if ([code isEqualToString:@"SF"]) // scale factor
    {
        result = [self parseScaleFactor];
    }
    else if ([code isEqualToString:@"IJ"]) // image justify
    {
//        parameter.type = PFGerberParameterImageJustify;
    }
    else if ([code isEqualToString:@"IN"]) // image name
    {
//        parameter.type = PFGerberParameterImageName;
    }
    else if ([code isEqualToString:@"IO"]) // image offset
    {
//        parameter.type = PFGerberParameterImageOffset;
    }
    else if ([code isEqualToString:@"IP"]) // image polarity
    {
        result = [self parseImagePolarity];
    }
    else if ([code isEqualToString:@"IR"]) // image rotation
    {
//        parameter.type = PFGerberParameterImageRotation;
    }
    else if ([code isEqualToString:@"PF"]) // plotter film
    {
//        parameter.type = PFGerberParameterPlotterFilm;
    }
    else if ([code isEqualToString:@"AD"]) // aperture description
    {
        result = [self parseApertureDefinition];
    }
    else if ([code isEqualToString:@"AM"]) // aperture macro
    {
        result = [self parserApertureMacro];
//        parameter.type = PFGerberParameterApertureMacro;
    }
    else if ([code isEqualToString:@"KO"]) // knockout
    {
//        parameter.type = PFGerberParameterKnockout;
    }
    else if ([code isEqualToString:@"LN"]) // layer name
    {
        result = [self parseLayerName];
    }
    else if ([code isEqualToString:@"LP"]) // layer polarity
    {
        result = [self parseLayerPolarity];
    }
    else if ([code isEqualToString:@"SR"]) // step and repeat
    {
//        parameter.type = PFGerberParameterStepAndRepeat;
    }
    else if ([code isEqualToString:@"IF"]) // include file
    {
//        parameter.type = PFGerberParameterIncludeFile;
    }
    
	return result;
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
    
    [coordinate release];
    
    [scanner scanString:@"*" intoString:nil];
    
	return YES;
}

#pragma mark Parameters

- (BOOL)parseFormatStatement
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
    
    if ([delegate respondsToSelector:@selector(parser:foundFormat:)])
    {
        [delegate parser:self foundFormat:format];
    }
    
    [format release];
    
    return YES;
}

- (BOOL)parseModeOfUnits
{
    BOOL usingInches;
    
    [scanner scanString:@"MO" intoString:nil];
    
    if ([scanner scanString:@"MM" intoString:nil])
    {
        usingInches = NO;
    }
    else if ([scanner scanString:@"IN" intoString:nil])
    {
        usingInches = YES;
    }
    else
    {
        NSLog(@"Unexpected string in MO parameter");
        return NO;
    }
    
    if ([delegate respondsToSelector:@selector(parser:foundModeOfUnits:)])
    {
        [delegate parser:self foundModeOfUnits:usingInches];
    }
    
    [scanner scanString:@"*" intoString:nil];
    
    return YES;
}

- (BOOL)parseOffset
{
    NSInteger aOffset;
    NSInteger bOffset;
    
    [scanner scanString:@"OF" intoString:nil];
    
    [scanner scanString:@"A" intoString:nil];
    [scanner scanInteger:&aOffset];
    
    [scanner scanString:@"B" intoString:nil];
    [scanner scanInteger:&bOffset];
    
    if ([delegate respondsToSelector:@selector(parser:foundOffsetForA:andB:)])
    {
        [delegate parser:self foundOffsetForA:aOffset andB:bOffset];
    }
    
    [scanner scanString:@"*" intoString:nil];
    
    return YES;
}

- (BOOL)parseScaleFactor
{
    double aScale;
    double bScale;
    
    [scanner scanString:@"SF" intoString:nil];
    
    [scanner scanString:@"A" intoString:nil];
    [scanner scanDouble:&aScale];
    
    [scanner scanString:@"B" intoString:nil];
    [scanner scanDouble:&bScale];
    
    if ([delegate respondsToSelector:@selector(parser:foundScaleFactorForA:andB:)])
    {
        [delegate parser:self foundScaleFactorForA:aScale andB:bScale];
    }
    
    [scanner scanString:@"*" intoString:nil];
    
    return YES;
}

- (BOOL)parseApertureDefinition
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
    
    if ([delegate respondsToSelector:@selector(parser:foundApertureDefinition:)])
    {
        [delegate parser:self foundApertureDefinition:definition];
    }
    
    return YES;
}

- (BOOL)parserApertureMacro
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
    
    [macro release];
    
    return YES;
}

- (BOOL)parseLayerName
{
    NSString* name;
    
    [scanner scanString:@"LN" intoString:nil];
    
    [scanner scanUpToString:@"*" intoString:&name];
    
    if ([delegate respondsToSelector:@selector(parser:foundLayer:)])
    {
        [delegate parser:self foundLayer:name];
    }
    
    [scanner scanString:@"*" intoString:nil];
    
    return YES;
}

- (BOOL)parseImagePolarity
{
    BOOL polarityPositive;
    
    [scanner scanString:@"IP" intoString:nil];
    
    polarityPositive = NO;
    
    if ([scanner scanString:@"POS" intoString:nil])
    {
        polarityPositive = YES;
    }
    else if ([scanner scanString:@"NEG" intoString:nil])
    {
        polarityPositive = NO;
    }
    else {
        NSLog(@"Malformed image polarity parameter");
        return NO;
    }

    if ([delegate respondsToSelector:@selector(parser:foundImagePolarity:)])
    {
        [delegate parser:self foundImagePolarity:polarityPositive];
    }
    
    [scanner scanString:@"*" intoString:nil];
    
    return YES;
}

- (BOOL)parseLayerPolarity
{
    BOOL polarityPositive;
    
    [scanner scanString:@"LP" intoString:nil];
    
    polarityPositive = NO;
    
    if ([scanner scanString:@"D" intoString:nil])
    {
        polarityPositive = YES;
    }
    else if ([scanner scanString:@"C" intoString:nil])
    {
        polarityPositive = NO;
    }
    else {
        NSLog(@"Malformed layer polarity parameter");
        return NO;
    }
    
    if ([delegate respondsToSelector:@selector(parser:foundLayerPolarity:)])
    {
        [delegate parser:self foundLayerPolarity:polarityPositive];
    }
    
    [scanner scanString:@"*" intoString:nil];
    
    return YES;
}

@end
