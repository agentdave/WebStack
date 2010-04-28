//
//  TrayMenu.m
//  WebStack
//
//  Created by David Ackerman on 10-04-26.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//
//	Heavily based on the following post:
//
//	http://th30z.netsons.org/2008/10/cocoa-system-statusbar-item-aka-traybar/
//

#import "TrayMenu.h"


@implementation TrayMenu

- (id) init
{
	self = [super init];
	
	if(self)
	{
		startWSCommand = [[NSTask alloc] init];
		[startWSCommand setLaunchPath:@"/usr/bin/security"];
		[startWSCommand setArguments:[NSArray arrayWithObjects: @"execute-with-privileges",
																@"/Applications/WebStack/bin/start.sh",
																nil]];
		
		stopWSCommand = [[NSTask alloc] init];
		[stopWSCommand setLaunchPath:@"/usr/bin/security"];		
		[stopWSCommand setArguments:[NSArray arrayWithObjects:	@"execute-with-privileges",
																@"/Applications/WebStack/bin/stop.sh",
																nil]];
	}
	
	return self;
}

- (void) startWebStack:(id)sender
{
	[_statusItem setImage:[NSImage imageNamed:@"in-progress"]];
	dispatch_queue_t queue = dispatch_get_global_queue(0,0);
	dispatch_async(queue,^{
		NSAppleScript *script = [[NSAppleScript alloc] initWithSource:
			@"do shell script \"/Applications/WebStack/bin/start.sh\" with administrator privileges"];
		NSDictionary *errorInfo;
		[script executeAndReturnError:&errorInfo];
		[_statusItem setImage:[NSImage imageNamed:@"on"]];
	});
}

- (void) stopWebStack:(id)sender
{
	[_statusItem setImage:[NSImage imageNamed:@"in-progress"]];
	dispatch_queue_t queue = dispatch_get_global_queue(0,0);
	dispatch_async(queue,^{
		NSAppleScript *script = [[NSAppleScript alloc] initWithSource:
			@"do shell script \"/Applications/WebStack/bin/stop.sh\" with administrator privileges"];
		NSDictionary *errorInfo;
		[script executeAndReturnError:&errorInfo];
		[_statusItem setImage:[NSImage imageNamed:@"off"]];
	});
}

- (void) quitWebStack:(id)sender
{
  [NSApp terminate:sender];
}

- (NSMenu *) createMenu
{
  NSZone *menuZone = [NSMenu menuZone];
  NSMenu *menu = [[NSMenu allocWithZone:menuZone] init];
  NSMenuItem *menuItem;

  // Add To Items
  menuItem = [menu addItemWithTitle:@"Start WebStack"
							 action:@selector(startWebStack:)
					  keyEquivalent:@""];
					  
  [menuItem setTarget:self];


  menuItem = [menu addItemWithTitle:@"Stop WebStack"
							 action:@selector(stopWebStack:)
					  keyEquivalent:@""];
					  
  [menuItem setTarget:self];

  // Add Separator
  [menu addItem:[NSMenuItem separatorItem]];

  // Add Quit Action
  menuItem = [menu addItemWithTitle:@"Quit"
							 action:@selector(quitWebStack:)
					  keyEquivalent:@""];
					  
  [menuItem setToolTip:@"Click to Remove the WebStack Menu from the task bar."];
  [menuItem setTarget:self];

  return menu;
}

- (void) applicationDidFinishLaunching:(NSNotification *)notification {
  NSMenu *menu = [self createMenu];

  _statusItem = [[[NSStatusBar systemStatusBar]
                  statusItemWithLength:NSSquareStatusItemLength] retain];
  [_statusItem setMenu:menu];
  [_statusItem setHighlightMode:YES];
  [_statusItem setToolTip:@"WebStack"];
  [_statusItem setImage:[NSImage imageNamed:@"off"]];

  [menu release];
}

@end