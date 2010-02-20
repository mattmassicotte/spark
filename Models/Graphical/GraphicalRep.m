// 
//  GraphicalRep.m
//  Spark
//
//  Created by Matt Massicotte on 10/13/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "GraphicalRep.h"

#import "Definition.h"
#import "Primitive.h"

#import "SPFacet.h"

@interface GraphicalRep (PrivateMethods)
- (void)destroyBuffers;
@end

@implementation GraphicalRep 

@dynamic primitives;
@dynamic definition;
@dynamic elements;

- (void)didTurnIntoFault
{
	[self destroyBuffers];
}

#pragma mark Accessors
@synthesize numberOfFacets;
@synthesize vertexBuffer;
@synthesize normalBuffer;
@synthesize colorBuffer;

- (void)prepareBuffers
{
	NSMutableArray*	facets;
	GLdouble*		vertexP;
	GLdouble*		colorP;
	GLdouble*		normalP;
	size_t			bytesInBuffer;
	
	if (vertexBuffer && normalBuffer && colorBuffer)
		return;
	
	facets = [NSMutableArray new];
	
	
	for (Primitive* p in [self primitives])
	{
		[facets addObjectsFromArray:[p facetArray]];
	}
	
	// # facets x 3 points per facet x 3 dimentions per point x size of each point
	// but we need to store the number of indices seperately
	numberOfFacets = [facets count] * 3;
	bytesInBuffer = numberOfFacets * 3 * sizeof(GLdouble);
	
	vertexBuffer	= malloc(bytesInBuffer);
	normalBuffer	= malloc(bytesInBuffer);
	colorBuffer		= malloc(bytesInBuffer);
	
	vertexP = vertexBuffer;
	normalP = normalBuffer;
	colorP  = colorBuffer;
	
	for (SPFacet* facet in facets)
	{
		SPVecCopyIntoBuffer(facet.vertexA, &vertexP);		
		SPVecCopyIntoBuffer(facet.vertexB, &vertexP);
		SPVecCopyIntoBuffer(facet.vertexC, &vertexP);
		
		SPVecCopyIntoBuffer(facet.normal, &normalP);		
		SPVecCopyIntoBuffer(facet.normal, &normalP);
		SPVecCopyIntoBuffer(facet.normal, &normalP);
		
		SPVecCopyIntoBuffer(facet.colorA, &colorP);		
		SPVecCopyIntoBuffer(facet.colorB, &colorP);
		SPVecCopyIntoBuffer(facet.colorC, &colorP);
		
		//[tracker copyColorIndexForObject:facet intoBuffer:&trackingPointer];
		//[facet copyToVertexBuffer:&vertexPointer normalBuffer:&normalPointer colorBuffer:&colorPointer];
	}
	
	[facets release];
}

- (void)destroyBuffers
{
	if (vertexBuffer)
		free(vertexBuffer);
	
	if (normalBuffer)
		free(normalBuffer);
	
	if (colorBuffer)
		free(colorBuffer);
	
	vertexBuffer = normalBuffer = colorBuffer = nil;
	numberOfFacets = 0;
}

@end
