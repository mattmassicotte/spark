/*
 *  SPGeometry.h
 *  Spark
 *
 *  Created by Matt Massicotte on 6/16/08.
 *  Copyright 2008 __MyCompanyName__. All rights reserved.
 *
 */

typedef struct {
	GLdouble x,y,z;
} SPVec;

typedef enum _SPAxis {
	SP_X_AXIS,
	SP_Y_AXIS,
	SP_Z_AXIS
} SPAxis;

static SPVec SPMakeVec(GLdouble x, GLdouble y, GLdouble z)
{
	SPVec vec;
	
	vec.x = x;
	vec.y = y;
	vec.z = z;
	
	return vec;
}

static GLdouble SPDistanceBetweenVec(SPVec v1, SPVec v2)
{
    return pow(pow(v2.x - v1.x, 2.0) + pow(v2.y - v1.y, 2.0), 0.5);
}

static BOOL SPValidVec(SPVec v)
{
	if (isnan(v.x) || isnan(v.y) || isnan(v.z))
		return false;
	
	if (isinf(v.x) || isinf(v.y) || isinf(v.z))
		return false;
	
	return true;
}

static NSString* SPVecToString(SPVec v)
{
	return [NSString stringWithFormat:@"(%f,%f,%f)", v.x, v.y, v.z];
}

static void SPVecCopyIntoBuffer(SPVec v, GLdouble** buffer)
{
	**buffer = v.x;
	(*buffer)++;
	**buffer = v.y;
	(*buffer)++;
	**buffer = v.z;
	(*buffer)++;
}