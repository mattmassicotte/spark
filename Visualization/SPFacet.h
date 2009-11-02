//
//  SPFacet.h
//  Spark
//
//  Created by Matt Massicotte on 6/25/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SPGeometry.h"

@interface SPFacet : NSObject
{
	SPVec vertexA, vertexB, vertexC;
	SPVec colorA, colorB, colorC;
	SPVec normal;
}

@property(assign) SPVec vertexA;
@property(assign) SPVec vertexB;
@property(assign) SPVec vertexC;
@property(assign) SPVec colorA;
@property(assign) SPVec colorB;
@property(assign) SPVec colorC;
@property(assign) SPVec color;
@property(assign) SPVec normal;

- (id)initWithA:(SPVec)a B:(SPVec)b C:(SPVec)c andNormal:(SPVec)n;

- (void)copyToVertexBuffer:(GLdouble**)vBuffer normalBuffer:(GLdouble**)nBuffer colorBuffer:(GLdouble**)cBuffer;

@end
