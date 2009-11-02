// 
//  DesignElement.m
//  Spark
//
//  Created by Matt Massicotte on 10/14/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "DesignElement.h"

#import "GraphicalRep.h"

@implementation DesignElement 

- (void)didTurnIntoFault
{
	if (trackingColorBuffer)
		free(trackingColorBuffer);
}

@dynamic yLocation;
@dynamic xLocation;
@dynamic zRotation;
@dynamic zLocation;
@dynamic surface;
@dynamic graphicalRep;

@synthesize trackingColorBuffer;

- (void)prepareForTrackingWithRed:(GLubyte)red green:(GLubyte)green blue:(GLubyte)blue
{
	NSUInteger i;
	GLubyte* colorPointer;
	
	if (trackingColorBuffer == nil)
	{
		trackingColorBuffer = malloc([[self graphicalRep] numberOfFacets] * 3 * sizeof(GLubyte));
	}
	
	colorPointer = trackingColorBuffer;
	
	for (i=0; i<[[self graphicalRep] numberOfFacets]; i++)
	{
		*(colorPointer++) = red;
		*(colorPointer++) = green;
		*(colorPointer++) = blue;
	}
}

@end
