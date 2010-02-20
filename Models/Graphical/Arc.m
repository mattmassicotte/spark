// 
//  Arc.m
//  Spark
//
//  Created by Matt Massicotte on 2/13/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Arc.h"
#import "SPFacet.h"

// number of slices that make up the circle
#define NUMBER_OF_SLICES 50

@implementation Arc 

@dynamic centerX;
@dynamic innerRadius;
@dynamic centerY;
@dynamic endAngle;
@dynamic outerRadius;
@dynamic startAngle;

- (void)assign:(NSString*)name with:(NSDictionary*)dict
{
}

- (NSArray *)facetArray
{
    NSMutableArray* array;
    SPVec           bottomColor;
	GLdouble	    angle;
	NSUInteger		i;
	GLdouble        innerRadiusValue;
    GLdouble        outerRadiusValue;
    GLdouble        centerXValue;
    GLdouble        centerYValue;
    
    innerRadiusValue = [self.innerRadius doubleValue];
    outerRadiusValue = [self.outerRadius doubleValue];
    centerXValue     = [self.centerX doubleValue];
    centerYValue     = [self.centerY doubleValue];
    
    bottomColor = [self color];
	bottomColor = SPMakeVec(bottomColor.x/4.0, bottomColor.y/4.0, bottomColor.z/4.0);
    
	array = [NSMutableArray array];
	
	angle = [self.startAngle doubleValue];
    
	for (i = 0; i < NUMBER_OF_SLICES && angle < [self.endAngle doubleValue]; i++ )
	{
		GLdouble inner[2],     outer[2];
		GLdouble nextInner[2], nextOuter[2];
		SPFacet* facet1;
		SPFacet* facet2;
		
		inner[0] = innerRadiusValue*cos(angle) + centerXValue;
		inner[1] = innerRadiusValue*sin(angle) + centerYValue;
		outer[0] = outerRadiusValue*cos(angle) + centerXValue;
		outer[1] = outerRadiusValue*sin(angle) + centerYValue;
		
		angle += 2 * M_PI / NUMBER_OF_SLICES;
		
		nextInner[0] = innerRadiusValue*cos(angle) + centerXValue;
		nextInner[1] = innerRadiusValue*sin(angle) + centerYValue;
		nextOuter[0] = outerRadiusValue*cos(angle) + centerXValue;
		nextOuter[1] = outerRadiusValue*sin(angle) + centerYValue;
		
		// top surfaces
		facet1 = [SPFacet new];
		facet2 = [SPFacet new];
		facet1.vertexA = SPMakeVec(inner[0], inner[1], self.zTop);
		facet1.vertexC = SPMakeVec(outer[0], outer[1], self.zTop);
		
		facet2.vertexB = SPMakeVec(nextInner[0], nextInner[1], self.zTop);
		facet2.vertexC = SPMakeVec(nextOuter[0], nextOuter[1], self.zTop);
		
		facet2.vertexA = facet1.vertexA;
		facet1.vertexB = facet2.vertexC;
		
		facet1.normal = SPMakeVec(0, 0, -1);
		facet1.color = self.color;
		facet2.normal = facet1.normal;
		facet2.color = self.color;
		[array addObject:facet1];
		[array addObject:facet2];
		[facet1 release];
		[facet2 release];
        
        // bottom surfaces
		facet1 = [SPFacet new];
		facet2 = [SPFacet new];
		facet1.vertexA = SPMakeVec(inner[0], inner[1], self.zBottom);
		facet1.vertexB = SPMakeVec(outer[0], outer[1], self.zBottom);
		
		facet2.vertexC = SPMakeVec(nextInner[0], nextInner[1], self.zBottom);
		facet2.vertexB = SPMakeVec(nextOuter[0], nextOuter[1], self.zBottom);
		
		facet2.vertexA = facet1.vertexA;
		facet1.vertexC = facet2.vertexB;
		
		facet1.normal = SPMakeVec(0, 0, 1);
		facet1.color = bottomColor;
		facet2.normal = facet1.normal;
		facet2.color = bottomColor;
		[array addObject:facet1];
		[array addObject:facet2];
		[facet1 release];
		[facet2 release];
        
		// inner wall
		facet1 = [SPFacet new];
		facet2 = [SPFacet new];
		
		facet1.vertexA = SPMakeVec(inner[0], inner[1], self.zTop);
		facet1.vertexB = SPMakeVec(inner[0], inner[1], self.zBottom);
		facet1.vertexC = SPMakeVec(nextInner[0], nextInner[1], self.zBottom);
		
		facet2.vertexA = SPMakeVec(inner[0], inner[1], self.zTop);
		facet2.vertexB = SPMakeVec(nextInner[0], nextInner[1], self.zBottom);
		facet2.vertexC = SPMakeVec(nextInner[0], nextInner[1], self.zTop);
		
		facet1.normal = SPMakeVec(0, 0, -1);
		facet1.colorA = self.color;
        facet1.colorB = bottomColor;
        facet1.colorC = bottomColor;
		facet2.normal = facet1.normal;
		facet2.colorA = self.color;
        facet2.colorB = bottomColor;
        facet2.colorC = self.color;
		[array addObject:facet1];
		[array addObject:facet2];
		[facet1 release];
		[facet2 release];
		
		// outer wall
		facet1 = [SPFacet new];
		facet2 = [SPFacet new];
		
		facet1.vertexA = SPMakeVec(outer[0], outer[1], self.zTop);
		facet1.vertexB = SPMakeVec(nextOuter[0], nextOuter[1], self.zBottom);
		facet1.vertexC = SPMakeVec(outer[0], outer[1], self.zBottom);
		
		facet2.vertexA = SPMakeVec(outer[0], outer[1], self.zTop);
		facet2.vertexB = SPMakeVec(nextOuter[0], nextOuter[1], self.zTop);
		facet2.vertexC = SPMakeVec(nextOuter[0], nextOuter[1], self.zBottom);
		
		facet1.normal = SPMakeVec(0, 0, -1);
		facet1.colorA = self.color;
        facet1.colorB = bottomColor;
        facet1.colorC = bottomColor;
		facet2.normal = facet1.normal;
		facet2.colorA = self.color;
        facet2.colorB = self.color;
        facet2.colorC = bottomColor;
		[array addObject:facet1];
		[array addObject:facet2];
		[facet1 release];
		[facet2 release];
	}
    
	return array;
}

@end
