
#import <UIKit/UIKit.h>

static UIWindow *welcomeWindow;
static BOOL welcomeShown = NO;

#define IMAGE_URL @"https://raw.githubusercontent.com/sd695802-rgb/Os/main/IMG_2608.jpeg"

@interface WelcomeController : UIViewController
@end

@implementation WelcomeController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = UIColor.blackColor;

    // صورة الخلفية
    UIImageView *background = [[UIImageView alloc] init];
    background.translatesAutoresizingMaskIntoConstraints = NO;
    background.contentMode = UIViewContentMode.scaleAspectFill;
    background.clipsToBounds = YES;
    [self.view addSubview:background];

    [NSLayoutConstraint activateConstraints:@[
        [background.topAnchor constraintEqualToAnchor:self.view.topAnchor],
        [background.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
        [background.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [background.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor]
    ]];

    // تحميل الصورة بدون تعطيل ظهور شاشة الترحيب
    NSURL *imageURL = [NSURL URLWithString:IMAGE_URL];

    [[[NSURLSession sharedSession] dataTaskWithURL:imageURL
        completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {

        if (data && !error) {
            UIImage *image = [UIImage imageWithData:data];

            dispatch_async(dispatch_get_main_queue(), ^{
                background.image = image;
            });
        }
    }] resume];

    // طبقة داكنة خلف الأزرار
    UIView *panel = [[UIView alloc] init];
    panel.translatesAutoresizingMaskIntoConstraints = NO;
    panel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.83];
    panel.layer.cornerRadius = 22;
    panel.layer.borderWidth = 1;
    panel.layer.borderColor = [UIColor colorWithRed:0.8 green:0.05 blue:0.12 alpha:1].CGColor;
    [self.view addSubview:panel];

    [NSLayoutConstraint activateConstraints:@[
        [panel.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:18],
        [panel.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-18],
        [panel.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor constant:190]
    ]];

    // رسالة الترحيب
    UILabel *welcome = [[UILabel alloc] init];
    welcome.translatesAutoresizingMaskIntoConstraints = NO;
    welcome.text = @"أهلاً وسهلاً بكم";
    welcome.textColor = UIColor.whiteColor;
    welcome.font = [UIFont boldSystemFontOfSize:25];
    welcome.textAlignment = NSTextAlignment.center;
    [panel addSubview:welcome];

    UILabel *subtitle = [[UILabel alloc] init];
    subtitle.translatesAutoresizingMaskIntoConstraints = NO;
    subtitle.text = @"في متجر ملوك الدليم ملفات IPA";
    subtitle.textColor = UIColor.whiteColor;
    subtitle.font = [UIFont boldSystemFontOfSize:17];
    subtitle.textAlignment = NSTextAlignment.center;
    [panel addSubview:subtitle];

    // إنشاء الأزرار
    UIButton *telegram = [self makeButton:@"قناة التيليجرام"
        color:[UIColor colorWithRed:0.0 green:0.45 blue:0.8 alpha:1]
        action:@selector(openTelegram)];

    UIButton *certificate = [self makeButton:@"لشراء شهادة سنوية"
        color:[UIColor colorWithRed:0.75 green:0.08 blue:0.13 alpha:1]
        action:@selector(openCertificate)];

    UIButton *ok = [self makeButton:@"OK"
        color:[UIColor colorWithRed:0.12 green:0.55 blue:0.28 alpha:1]
        action:@selector(closeWelcome)];

    [panel addSubview:telegram];
    [panel addSubview:certificate];
    [panel addSubview:ok];

    [NSLayoutConstraint activateConstraints:@[
        [welcome.topAnchor constraintEqualToAnchor:panel.topAnchor constant:20],
        [welcome.leadingAnchor constraintEqualToAnchor:panel.leadingAnchor constant:8],
        [welcome.trailingAnchor constraintEqualToAnchor:panel.trailingAnchor constant:-8],

        [subtitle.topAnchor constraintEqualToAnchor:welcome.bottomAnchor constant:8],
        [subtitle.leadingAnchor constraintEqualToAnchor:panel.leadingAnchor constant:8],
        [subtitle.trailingAnchor constraintEqualToAnchor:panel.trailingAnchor constant:-8],

        [telegram.topAnchor constraintEqualToAnchor:subtitle.bottomAnchor constant:18],
        [telegram.leadingAnchor constraintEqualToAnchor:panel.leadingAnchor constant:16],
        [telegram.trailingAnchor constraintEqualToAnchor:panel.trailingAnchor constant:-16],
        [telegram.heightAnchor constraintEqualToConstant:48],

        [certificate.topAnchor constraintEqualToAnchor:telegram.bottomAnchor constant:10],
        [certificate.leadingAnchor constraintEqualToAnchor:telegram.leadingAnchor],
        [certificate.trailingAnchor constraintEqualToAnchor:telegram.trailingAnchor],
        [certificate.heightAnchor constraintEqualToConstant:48],

        [ok.topAnchor constraintEqualToAnchor:certificate.bottomAnchor constant:10],
        [ok.leadingAnchor constraintEqualToAnchor:telegram.leadingAnchor],
        [ok.trailingAnchor constraintEqualToAnchor:telegram.trailingAnchor],
        [ok.heightAnchor constraintEqualToConstant:45],
        [ok.bottomAnchor constraintEqualToAnchor:panel.bottomAnchor constant:-18]
    ]];
}

- (UIButton *)makeButton:(NSString *)title
                   color:(UIColor *)color
                  action:(SEL)action {

    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.translatesAutoresizingMaskIntoConstraints = NO;
    button.backgroundColor = color;
    button.layer.cornerRadius = 12;
    button.clipsToBounds = YES;

    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:17];

    [button addTarget:self action:action
     forControlEvents:UIControlEventTouchUpInside];

    return button;
}

- (void)openTelegram {
    [self openLink:@"https://t.me/AhmedAlawad_811"];
}

- (void)openCertificate {
    [self openLink:@"https://t.me/Anmed001"];
}

- (void)openLink:(NSString *)url {
    NSURL *link = [NSURL URLWithString:url];
    if (link) {
        [[UIApplication sharedApplication]
            openURL:link options:@{} completionHandler:nil];
    }
}

- (void)closeWelcome {
    welcomeWindow.hidden = YES;
    welcomeWindow = nil;
}

@end

// تشغيل شاشة الترحيب عند فتح التطبيق
static void showWelcome(void) {

    if (welcomeShown) return;

    UIApplication *app = [UIApplication sharedApplication];

    UIWindowScene *scene = nil;

    for (UIScene *connectedScene in app.connectedScenes) {
        if ([connectedScene isKindOfClass:[UIWindowScene class]] &&
            connectedScene.activationState == UISceneActivationStateForegroundActive) {
            scene = (UIWindowScene *)connectedScene;
            break;
        }
    }

    if (!scene) return;

    welcomeShown = YES;

    welcomeWindow = [[UIWindow alloc] initWithWindowScene:scene];
    welcomeWindow.frame = scene.coordinateSpace.bounds;
    welcomeWindow.windowLevel = UIWindowLevelAlert + 1;
    welcomeWindow.rootViewController = [WelcomeController new];
    welcomeWindow.hidden = NO;
    [welcomeWindow makeKeyAndVisible];
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

        // محاولة الظهور فور جاهزية التطبيق
        showWelcome();
    });
}
