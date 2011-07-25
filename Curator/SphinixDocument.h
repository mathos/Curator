//
//  SphinixDocument.h
//  Curator
//
//  Created by Thomas Cramer on 7/24/11.
//  Copyright 2011 BeliefNetworks. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SphinxTextView.h"

@interface SphinixDocument : NSDocument {
	IBOutlet SphinxTextView * textView;
	NSData * dataFromFile;
	NSString * filePath;
}


- (IBAction)buildHtml:(id)sender;



@end
