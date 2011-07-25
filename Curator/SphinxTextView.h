//
//  SphinxTextView.h
//  Curator
//
//  Created by Thomas Cramer on 7/24/11.
//  Copyright 2011 BeliefNetworks. All rights reserved.
//

#import <AppKit/AppKit.h>
#import "SphinxTextContainer.h"

@interface SphinxTextView : NSTextView {
	BOOL                drawNumbersInMargin;
    BOOL                drawLineNumbers;
    NSMutableDictionary *marginAttributes;

}

-(void)initLineMargin:(NSRect)frame;

-(void)updateMargin;
-(void)updateLayout;

-(void)drawEmptyMargin:(NSRect)aRect;
-(void)drawNumbersInMargin:(NSRect)aRect;
-(void)drawOneNumberInMargin:(unsigned) aNumber inRect:(NSRect)aRect;

-(NSRect)marginRect;






@end
