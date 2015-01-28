#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CaptainHook.h"

CHDeclareClass(MPIncomingPhoneCallController);

CHOptimizedMethod(0, self, void, MPIncomingPhoneCallController, viewDidLoad) {
  NSLog(@"opincall: Hooked viewDidLoad");

  CHSuper(0, MPIncomingPhoneCallController, viewDidLoad);
  UIView **_view = CHIvarRef(self, _view, UIView *);
  NSString **_incomingCallNumber = CHIvarRef(self, _incomingCallNumber, NSString *);
  NSString *incomingCallNumber = @"";
  if (_incomingCallNumber) {
    incomingCallNumber = *_incomingCallNumber;
    if (!incomingCallNumber) {
      *_incomingCallNumber = incomingCallNumber = @"NULL";
    }
  }

  if (_view) {
    UIView *bView = *_view;
    if (bView) { 
      /*NSDictionary *attributes = @{NSFontAttributeName          : [UIFont fontWithName:@"HelveticaNeue-Thin" size:48],
                                   NSForegroundColorAttributeName : [UIColor whiteColor],
                                   NSBackgroundColorAttributeName : [UIColor clearColor]};

      UIImage *image = [OPImageHelper imageFromString:(incomingCallNumber) attributes:attributes size:bView.bounds.size];
      UIImageView *numberImageView = [[UIImageView alloc] initWithImage:image];
      [bView addSubview:numberImageView];*/
      UILabel *bLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 117.0, bView.bounds.size.width, 100.0)];
      bLabel.backgroundColor = [UIColor clearColor];
      UIFont *font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:71];
      bLabel.font = font;
      bLabel.numberOfLines = 0;
      bLabel.userInteractionEnabled = NO;

      CGRect drawRect = [incomingCallNumber boundingRectWithSize:CGSizeMake(bView.bounds.size.width, 2000.0) 
                        options:NSStringDrawingUsesLineFragmentOrigin
                        attributes:@{NSFontAttributeName: font}
                        context: nil];

      bLabel.frame = CGRectOffset(drawRect, 0.0, 120.0);
      bLabel.lineBreakMode = NSLineBreakByCharWrapping;
      bLabel.text = incomingCallNumber;
      bLabel.textColor = [UIColor whiteColor];
      bLabel.textAlignment = NSTextAlignmentCenter;
      [bView addSubview: bLabel];
    }
    else {
      /*UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"CAO"
                                                    message:(incomingCallNumber)
                                                    delegate:nil 
                                                    cancelButtonTitle:@"OK" 
                                                    otherButtonTitles:nil, nil];
      [alert show];*/
      NSLog(@"Incoming Number is [%@]", incomingCallNumber);
    }
  }
}

CHDeclareClass(SBPluginManager);

CHOptimizedMethod(1, self, Class, SBPluginManager, loadPluginBundle, NSBundle *, bundle) {
    id ret = CHSuper(1, SBPluginManager, loadPluginBundle, bundle);

    if ([[bundle bundleIdentifier] isEqualToString:@"com.apple.mobilephone.incomingcall"] && [bundle isLoaded]) {
      NSLog(@"iAnnounce: SBPluginManager loaded com.apple.mobilephone.incomingcall");
        CHLoadLateClass(MPIncomingPhoneCallController);
        CHHook(0, MPIncomingPhoneCallController, viewDidLoad);
    }

    return ret;
}

CHConstructor {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

    CHLoadLateClass(SBPluginManager);
    CHHook(1, SBPluginManager, loadPluginBundle);
    [pool drain];
}