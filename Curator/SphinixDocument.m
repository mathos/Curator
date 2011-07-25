//
//  SphinixDocument.m
//  Curator
//
//  Created by Thomas Cramer on 7/24/11.
//  Copyright 2011 BeliefNetworks. All rights reserved.
//

#import "SphinixDocument.h"

@implementation SphinixDocument

- (id)init
{
    self = [super init];
    if (self) {
		// Add your subclass-specific initialization here.
		// If an error occurs here, send a [self release] message and return nil.
    }
    return self;
}

- (NSString *)windowNibName
{
	// Override returning the nib file name of the document
	// If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this method and override -makeWindowControllers instead.
	return @"SphinixDocument";
}

- (void)windowControllerDidLoadNib:(NSWindowController *)aController
{
	[super windowControllerDidLoadNib:aController];
	if (dataFromFile) {
		NSString * text = [[NSString alloc] initWithData:dataFromFile encoding:NSUTF8StringEncoding];
		[textView setString:text];
		[text release];
	}
	[textView setAllowsUndo:YES];
	// Add any code here that needs to be executed once the windowController has loaded the document's window.
}

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError
{
	NSString * text = [textView string];
	/*
	 Insert code here to write your document to data of the specified type. If outError != NULL, ensure that you create and set an appropriate error when returning nil.
	You can also choose to override -fileWrapperOfType:error:, -writeToURL:ofType:error:, or -writeToURL:ofType:forSaveOperation:originalContentsURL:error: instead.
	*/
//	if (outError) {
//	    *outError = [NSError errorWithDomain:NSOSStatusErrorDomain code:unimpErr userInfo:NULL];
//	}
	return [text dataUsingEncoding:NSUTF8StringEncoding];
}

- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError
{
	
	dataFromFile = [data retain];
	/*
	Insert code here to read your document from the given data of the specified type. If outError != NULL, ensure that you create and set an appropriate error when returning NO.
	You can also choose to override -readFromFileWrapper:ofType:error: or -readFromURL:ofType:error: instead.
	If you override either of these, you should also override -isEntireFileLoaded to return NO if the contents are lazily loaded.
	*/
	if (outError) {
	    *outError = [NSError errorWithDomain:NSOSStatusErrorDomain code:unimpErr userInfo:NULL];
	}
	return YES;
}


- (IBAction)buildHtml:(id)sender {
	NSString * applicationPath = [[NSBundle mainBundle] bundlePath];
	NSDictionary *environmentDict = [[NSProcessInfo processInfo] environment];
//	NSLog(@"base: %@",[[self fileURL] lastPathComponent]); //intl.rst
//	NSLog(@"base: %@",[[self fileURL] relativePath]); // /Users/mathos/sphinx/sphinx/doc/intl.rst
	
	
	NSString * lastComponent = [[self fileURL] lastPathComponent];

	NSString * pathExtension = [[self fileURL] pathExtension];
	NSRange fileRange = [lastComponent rangeOfString:pathExtension
												options:NSBackwardsSearch];
	
	// Chop the fragment.
	NSString* fileName = [lastComponent substringToIndex:(fileRange.location - 1)];

	
	
	NSString * relativePath = [[self fileURL] relativePath];
	NSRange fragmentRange = [relativePath rangeOfString:lastComponent
									 options:NSBackwardsSearch];
	
	// Chop the fragment.
	NSString* basePath = [relativePath substringToIndex:fragmentRange.location];


	
	NSString *outputPath = [basePath stringByAppendingString:@"_build"];
	
	NSString *newFile = [@"file://" stringByAppendingFormat:@"%@/%@.html",outputPath,fileName];
	
	
	
	NSString* path_env = [environmentDict objectForKey:@"PATH"];
	NSString *sphinx_launch_path = [applicationPath stringByAppendingString:@"/Contents/Resources/python/curator_ext_env/bin/sphinx-build"];
	NSString *sphinx_conf = [applicationPath stringByAppendingString:@"/Contents/Resources/python/defaults"];

	NSString *bin_path = [applicationPath stringByAppendingFormat:@"/Contents/Resources/python/curator_ext_env/bin:%@",path_env];

	//NSLog(@"conf: %@",basePath);

	NSMutableDictionary* new_env = [NSMutableDictionary dictionaryWithDictionary:environmentDict];
	
	[new_env setValue:bin_path forKey:@"PATH"];

	NSTask *task = [NSTask new];
	[task setEnvironment:new_env];

	[task setLaunchPath:sphinx_launch_path];
	[task setArguments:[NSArray arrayWithObjects:@"-c",sphinx_conf,basePath,outputPath,relativePath, nil]];
	
	NSPipe *pipe = [NSPipe pipe];
	[task setStandardOutput:pipe];
	
	[task launch];
	
	NSData *data = [[pipe fileHandleForReading] readDataToEndOfFile];
	
	[task waitUntilExit];
	NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	//NSLog (@"got\n%@", string);
	[string release];
	
	
	
	[task release];
	
	NSWorkspace * ws = [NSWorkspace sharedWorkspace];
	[ws openURL:[NSURL URLWithString:newFile]];

	
}


+ (BOOL)autosavesInPlace
{
    return YES;
}

- (void) dealloc{
	[dataFromFile release];
	[filePath release];
	[super dealloc];
}

@end
