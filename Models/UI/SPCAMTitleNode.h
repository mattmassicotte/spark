//
//  SPCAMTitleNode.h
//  Spark
//
//  Created by Matt Massicotte on 2/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SPProjectNode.h"

@interface SPCAMTitleNode : SPProjectNode
{
    NSManagedObjectContext* managedObjectContext;
    NSFetchRequest*         request;
}

@property (nonatomic, retain) NSManagedObjectContext* managedObjectContext;

@end
