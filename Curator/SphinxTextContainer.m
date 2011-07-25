//
//  SphinxTextContainer.m
//  Curator
//
//  Created by Thomas Cramer on 7/24/11.
//  Copyright 2011 BeliefNetworks. All rights reserved.
//

#import "SphinxTextContainer.h"

@implementation SphinxTextContainer

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}




- (NSRect)lineFragmentRectForProposedRect:(NSRect)proposedRect 
						   sweepDirection:(NSLineSweepDirection)sweepDirection 
						movementDirection:(NSLineMovementDirection)movementDirection 
							remainingRect:(NSRect *)remainingRect
{
    proposedRect.origin.x = left_margin_width;
	
    return [super lineFragmentRectForProposedRect:proposedRect sweepDirection:sweepDirection
								movementDirection:movementDirection remainingRect:remainingRect];
}

@end
