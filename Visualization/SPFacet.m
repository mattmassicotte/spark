//
//  SPFacet.m
//  Spark
//
//  Created by Matt Massicotte on 6/25/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "SPFacet.h"


@implementation SPFacet

@synthesize vertexA;
@synthesize vertexB;
@synthesize vertexC;
@synthesize colorA;
@synthesize colorB;
@synthesize colorC;
@synthesize normal;

- (id)initWithA:(SPVec)a B:(SPVec)b C:(SPVec)c andNormal:(SPVec)n
{
	self = [super init];
	if( self )
	{
		vertexA = a;
		vertexB = b;
		vertexC = c;
		normal  = n;
	}
	
	return self;
}

- (SPVec)color
{
	return colorA;
}

- (void)setColor:(SPVec)v
{
	self.colorA = v;
	self.colorB = v;
	self.colorC = v;
}

- (void)copyToVertexBuffer:(GLdouble**)vBuffer normalBuffer:(GLdouble**)nBuffer colorBuffer:(GLdouble**)cBuffer
{
	SPVecCopyIntoBuffer(vertexA, vBuffer);
	SPVecCopyIntoBuffer(vertexB, vBuffer);
	SPVecCopyIntoBuffer(vertexC, vBuffer);
	
	SPVecCopyIntoBuffer(normal, nBuffer);
	SPVecCopyIntoBuffer(normal, nBuffer);
	SPVecCopyIntoBuffer(normal, nBuffer);
	
	SPVecCopyIntoBuffer(colorA, cBuffer);
	SPVecCopyIntoBuffer(colorB, cBuffer);
	SPVecCopyIntoBuffer(colorC, cBuffer);
}

@end
