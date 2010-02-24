//
//  SparkCAMViewController.m
//  Spark
//
//  Created by Matt Massicotte on 2/9/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SparkCAMViewController.h"
#import "GraphicalRep.h"
#import "Primitive.h"

@implementation SparkCAMViewController
        
- (void)elementViewDidLoadElements:(SparkElementView*)view
{
//    __block double maxX, minX, maxY, minY;
//    SPVec          center;
//    
//    center = view.sceneCenter;
//    maxX = minX = maxY = minY = 0;
//    
//    [[self elementsInElementView:view] enumerateObjectsUsingBlock:^(id element, NSUInteger idx, BOOL *stop1) {
//        [[[element graphicalRep] primitives] enumerateObjectsUsingBlock:^(id primitive, BOOL *stop2) {
//            double x, y;
//            
//            x = [(Primitive*)primitive center].x;
//            y = [(Primitive*)primitive center].y;
//            
//            maxX = MAX(maxX, x);
//            minX = MIN(minX, x);
//            maxY = MAX(maxY, y);
//            minY = MIN(minY, y);
//        }];
//    }];
//    
//    center.x -= (maxX - minX) / 2.0;
//    center.y -= (maxY - minY) / 2.0;
//    
//    //NSLog(@"(%f,%f) (%f,%f) %@", maxX, maxY, minX, minY, SPVecToString(center));
//    view.sceneCenter = center;
}

@end
