#import <UIKit/UIKit.h>

static UIWindow *welcomeWindow = nil;
static BOOL welcomeShown = NO;

#define IMAGE_URL @"https://raw.githubusercontent.com/sd695802-rgb/Os/main/IMG_2608.jpeg"

@interface WelcomeController : UIViewController
@end

@implementation WelcomeController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor blackColor];

    // Full-screen background image.
    UIImageView *background = [[UIImageView alloc] initWithFrame:CGRectZero];
    background.translatesAutoresizingMaskIntoConstraints = NO;
    background.contentMode = UIViewContentModeScaleAspectFill;
    background.clipsToBounds = YES;
    [self.view addSubview:background];

    [NSLayoutConstraint activateConstraints:@[
        [background.topAnchor constraintEqualToAnchor:self.view.topAnchor],
        [background.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
        [background.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [background.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor]
    ]];

    // Load the image asynchronously so the welcome screen appears immediately.
    NSURL *imageURL = [NSURL URLWithString:IMAGE_URL];
    if (imageURL) {
        [[[NSURLSession sharedSession] dataTaskWithURL:imageURL
            completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                if (data && !error) {
                    UIImage *image = [UIImage imageWithData:data];
                    if (image) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            background.image = image;
                        });
                    }
                }
            }] resume];
    }

    // Fixed welcome panel.
    UIView *panel = [[UIView alloc] initWithFrame:CGRectZero];
    panel.translatesAutoresizingMaskIntoConstraints = NO;
    panel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.86];
    panel.layer.cornerRadius = 22.0;
    panel.layer.borderWidth = 1.0;
    panel.layer.borderColor = [UIColor colorWithRed:0.85 green:0.08 blue:0.14 alpha:1.0].CGColor;
    [self.view addSubview:panel];

    [NSLayoutConstraint activateConstraints:@[
        [panel.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:18.0],
        [panel.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-18.0],
        [panel.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor]
    ]];

    UILabel *welcome = [[UILabel alloc] initWithFrame:CGRectZero];
    welcome.translatesAutoresizingMaskIntoConstraints = NO;
    welcome.text = @"أهلا وسهلا بكم";
    welcome.textColor = [UIColor whiteColor];
    welcome.font = [UIFont boldSystemFontOfSize:25.0];
    welcome.textAlignment = NSTextAlignmentCenter;
    welcome.numberOfLines = 1;
    [panel addSubview:welcome];

    UILabel *subtitle = [[UILabel alloc] initWithFrame:CGRectZero];
    subtitle.translatesAutoresizingMaskIntoConstraints = NO;
    subtitle.text = @"في متجر ملوك الدليم ملفات IPA";
    subtitle.textColor = [UIColor whiteColor];
    subtitle.font = [UIFont boldSystemFontOfSize:17.0];
    subtitle.textAlignment = NSTextAlignmentCenter;
    subtitle.numberOfLines = 0;
    [panel addSubview:subtitle];

    UIButton *telegram = [self makeButton:@"قناة التيليجرام"
                                    color:[UIColor colorWithRed:0.0 green:0.45 blue:0.80 alpha:1.0]
                                   action:@selector(openTelegram)];

    UIButton *certificate = [self makeButton:@"لشراء شهادة سنوية"
                                        color:[UIColor colorWithRed:0.75 green:0.08 blue:0.13 alpha:1.0]
                                       action:@selector(openCertificate)];

    UIButton *ok = [self makeButton:@"OK"
                              color:[UIColor colorWithRed:0.12 green:0.55 blue:0.28 alpha:1.0]
                             action:@selector(closeWelcome)];

    [panel addSubview:telegram];
    [panel addSubview:certificate];
    [panel addSubview:ok];

    [NSLayoutConstraint activateConstraints:@[
        [welcome.topAnchor constraintEqualToAnchor:panel.topAnchor constant:20.0],
        [welcome.leadingAnchor constraintEqualToAnchor:panel.leadingAnchor constant:8.0],
        [welcome.trailingAnchor constraintEqualToAnchor:panel.trailingAnchor constant:-8.0],

        [subtitle.topAnchor constraintEqualToAnchor:welcome.bottomAnchor constant:8.0],
        [subtitle.leadingAnchor constraintEqualToAnchor:panel.leadingAnchor constant:10.0],
        [subtitle.trailingAnchor constraintEqualToAnchor:panel.trailingAnchor constant:-10.0],

        [telegram.topAnchor constraintEqualToAnchor:subtitle.bottomAnchor constant:18.0],
        [telegram.leadingAnchor constraintEqualToAnchor:panel.leadingAnchor constant:16.0],
        [telegram.trailingAnchor constraintEqualToAnchor:panel.trailingAnchor constant:-16.0],
        [telegram.heightAnchor constraintEqualToConstant:48.0],

        [certificate.topAnchor constraintEqualToAnchor:telegram.bottomAnchor constant:10.0],
        [certificate.leadingAnchor constraintEqualToAnchor:telegram.leadingAnchor],
        [certificate.trailingAnchor constraintEqualToAnchor:telegram.trailingAnchor],
        [certificate.heightAnchor constraintEqualToConstant:48.0],

        [ok.topAnchor constraintEqualToAnchor:certificate.bottomAnchor constant:10.0],
        [ok.leadingAnchor constraintEqualToAnchor:telegram.leadingAnchor],
        [ok.trailingAnchor constraintEqualToAnchor:telegram.trailingAnchor],
        [ok.heightAnchor constraintEqualToConstant:45.0],
        [ok.bottomAnchor constraintEqualToAnchor:panel.bottomAnchor constant:-18.0]
    ]];
}

- (UIButton *)makeButton:(NSString *)title color:(UIColor *)color action:(SEL)action {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.translatesAutoresizingMaskIntoConstraints = NO;
    button.backgroundColor = color;
    button.layer.cornerRadius = 12.0;
    button.clipsToBounds = YES;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (void)openTelegram {
    [self openLink:@"https://t.me/AhmedAlawad_811"];
}

- (void)openCertificate {
    [self openLink:@"https://t.me/Anmed001"];
}

- (void)openLink:(NSString *)string {
    NSURL *url = [NSURL URLWithString:string];
    if (url) {
        [[UIApplication sharedApplication] openURL:url
                                           options:@{}
                                 completionHandler:nil];
    }
}

- (void)closeWelcome {
    welcomeWindow.hidden = YES;
    welcomeWindow = nil;
}

@end

static void showWelcome(void) {
    if (welcomeShown) {
        return;
    }

    UIApplication *application = [UIApplication sharedApplication];
    UIWindowScene *activeScene = nil;

    for (UIScene *scene in application.connectedScenes) {
        if ([scene isKindOfClass:[UIWindowScene class]] &&
            scene.activationState == UISceneActivationStateForegroundActive) {
            activeScene = (UIWindowScene *)scene;
            break;
        }
    }

    if (!activeScene) {
        return;
    }

    welcomeShown = YES;

    UIWindow *window = [[UIWindow alloc] initWithWindowScene:activeScene];
    window.frame = activeScene.coordinateSpace.bounds;
    window.windowLevel = UIWindowLevelAlert + 1.0;
    window.rootViewController = [[WelcomeController alloc] init];
    welcomeWindow = window;
    [window makeKeyAndVisible];
}

__attribute__((constructor))
static void WelcomeInit(void) {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter]
            addObserverForName:UIApplicationDidBecomeActiveNotification
                        object:nil
                         queue:[NSOperationQueue mainQueue]
                    usingBlock:^(NSNotification *note) {
            showWelcome();
        }];

        showWelcome();
    });
}
