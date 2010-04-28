//
//  TrayMenu.h
//  WebStack
//
//  Created by David Ackerman on 10-04-26.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <SecurityFoundation/SFAuthorization.h>

@interface TrayMenu : NSObject {
    @private
        NSStatusItem *_statusItem;
		NSTask* startWSCommand;
		NSTask* stopWSCommand;
		SFAuthorization *authorization;
}

@end
