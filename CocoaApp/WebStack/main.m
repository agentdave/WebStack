//
//  main.m
//  WebStack
//
//  Created by David Ackerman on 10-04-26.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//
//	Heavily based on the following post:
//
//	http://th30z.netsons.org/2008/10/cocoa-system-statusbar-item-aka-traybar/
//

#import <Cocoa/Cocoa.h>
#import "TrayMenu.h"

int main(int argc, char *argv[])
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    [NSApplication sharedApplication];

    TrayMenu *menu = [[TrayMenu alloc] init];
    [NSApp setDelegate:menu];
    [NSApp run];

    [pool release];
	
    return EXIT_SUCCESS;
}
