// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'FixIt';

  @override
  String get welcome => 'Welcome to FixIt';

  @override
  String get login => 'Login';

  @override
  String get register => 'Register';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get myProfile => 'My Profile';

  @override
  String get editProfile => 'Edit Profile';

  @override
  String get logout => 'Logout';

  @override
  String get notifications => 'Notifications';

  @override
  String get bookings => 'My Bookings';

  @override
  String get wallet => 'My Wallet';

  @override
  String get helpSupport => 'Help & Support';

  @override
  String get signIn => 'Sign In';

  @override
  String get forgotPasswordQuery => 'Forgot Password?';

  @override
  String get newToFixit => 'New to FixIt?';

  @override
  String get adminPanel => 'ADMIN PANEL';

  @override
  String get commandCenter => 'Command Center';

  @override
  String helloAdmin(String name) {
    return 'Hello, $name';
  }

  @override
  String get revenue => 'REVENUE';

  @override
  String get activeJobs => 'ACTIVE JOBS';

  @override
  String get newUsers => 'NEW USERS';

  @override
  String get pendingApps => 'PENDING APPS';

  @override
  String get revenueTrend => 'REVENUE TREND (7 DAYS)';

  @override
  String get jobDistribution => 'JOB DISTRIBUTION';

  @override
  String get quickOperations => 'QUICK OPERATIONS';

  @override
  String get recentApplications => 'RECENT APPLICATIONS';

  @override
  String get approvals => 'Approvals';

  @override
  String get users => 'Users';

  @override
  String get jobs => 'Jobs';

  @override
  String get services => 'Services';

  @override
  String get noJobData => 'No job data available';

  @override
  String get noPendingApps => 'No pending applications';

  @override
  String get banners => 'Banners';

  @override
  String get config => 'Config';

  @override
  String get broadcast => 'Broadcast';

  @override
  String get products => 'Products';

  @override
  String get ledger => 'Ledger';

  @override
  String get feedback => 'Feedback';

  @override
  String get coupons => 'Coupons';

  @override
  String get liveMap => 'Live Map';

  @override
  String get reports => 'Reports';

  @override
  String get staff => 'Staff';

  @override
  String get auditLogs => 'Audit Logs';

  @override
  String get bcHistory => 'BC History';

  @override
  String get partsInventory => 'Parts Inventory';

  @override
  String get preferences => 'PREFERENCES';

  @override
  String get themeMode => 'Theme Mode';

  @override
  String get language => 'Language';

  @override
  String get system => 'SYSTEM';

  @override
  String get appInfo => 'App Info';

  @override
  String get debugLogs => 'Debug Logs';

  @override
  String get securityLevel => 'Security Level';

  @override
  String get selectTheme => 'SELECT THEME';

  @override
  String get selectLanguage => 'SELECT LANGUAGE';

  @override
  String get home => 'Home';

  @override
  String get city => 'City';

  @override
  String get order => 'Order';

  @override
  String get profile => 'Profile';

  @override
  String get logoutConfirmTitle => 'LOGOUT';

  @override
  String get logoutConfirmMessage =>
      'Are you sure you want to end this session?';

  @override
  String get logoutButton => 'LOGOUT NOW';

  @override
  String get cancelButton => 'Stay';

  @override
  String get userManagement => 'USER MANAGEMENT';

  @override
  String get searchUserHint => 'Find users by name or email...';

  @override
  String get all => 'All';

  @override
  String get admins => 'Admins';

  @override
  String get technicians => 'Technicians';

  @override
  String get customers => 'Customers';

  @override
  String get deleteAccountQuery => 'DELETE ACCOUNT?';

  @override
  String deleteAccountDesc(String name) {
    return 'Are you sure you want to permanently delete the account of $name? This action cannot be undone.';
  }

  @override
  String get deleteNow => 'DELETE NOW';

  @override
  String get deactivateUserQuery => 'DEACTIVATE USER?';

  @override
  String get activateUserQuery => 'ACTIVATE USER?';

  @override
  String get deactivateDesc =>
      'This user will no longer be able to access the app until you re-enable them.';

  @override
  String get activateDesc =>
      'This user will regain full access to the application services.';

  @override
  String get cancel => 'Cancel';

  @override
  String get noUsersFound => 'No users found';

  @override
  String get serviceCatalog => 'SERVICE CATALOG';

  @override
  String get searchServicesHint => 'Search services...';

  @override
  String get popular => 'Popular';

  @override
  String get regular => 'Services';

  @override
  String get addService => 'Add Service';

  @override
  String get editService => 'Edit Service';

  @override
  String get saveChanges => 'SAVE CHANGES';

  @override
  String get createService => 'CREATE SERVICE';

  @override
  String get deleteServiceQuery => 'DELETE SERVICE?';

  @override
  String deleteServiceDesc(String title) {
    return 'Are you sure you want to permanently delete \"$title\"? This will also delete ALL related issues, guides, and steps.';
  }

  @override
  String get deleteEverything => 'DELETE EVERYTHING';

  @override
  String get identityVerification => 'Identity Verification';

  @override
  String get serviceOffer => 'Service Offer';

  @override
  String get workingHours => 'Working Hours';

  @override
  String get aboutMe => 'About Me';

  @override
  String get next => 'Next';

  @override
  String get submit => 'Submit Application';

  @override
  String get finish => 'Finish';

  @override
  String get currentBalance => 'Current Balance';

  @override
  String get totalEarned => 'Total Earned';

  @override
  String get transactionHistory => 'Transaction History';

  @override
  String get deposit => 'Deposit';

  @override
  String get withdraw => 'Withdraw';

  @override
  String get typeMessage => 'Type a message...';

  @override
  String get calling => 'Calling...';

  @override
  String get incomingCall => 'Incoming Call...';

  @override
  String get mute => 'Mute';

  @override
  String get speaker => 'Speaker';

  @override
  String get noNotifications => 'No notifications yet';

  @override
  String get markAllAsRead => 'Mark all as read';

  @override
  String get idNumber => 'ID Number';

  @override
  String get bankName => 'Bank Name';

  @override
  String get accountNumber => 'Account Number';

  @override
  String get accountHolder => 'Account Holder';

  @override
  String get hourlyRate => 'Hourly Rate';

  @override
  String get applicationReceived => 'Application Received';

  @override
  String get applicationReceivedDesc =>
      'Your application has been sent to the administrator. We will contact you soon!';

  @override
  String get rating => 'Rating';

  @override
  String get orders => 'Orders';

  @override
  String get experience => 'Experience';

  @override
  String get skills => 'Skills';

  @override
  String get bio => 'Bio';

  @override
  String get reviews => 'Reviews';

  @override
  String get bookService => 'Book Service';

  @override
  String get years => 'years';

  @override
  String get noReviews => 'No reviews yet.';

  @override
  String get testKey => 'Test';

  @override
  String get systemMode => 'SYSTEM';

  @override
  String get lightMode => 'LIGHT MODE';

  @override
  String get darkMode => 'DARK MODE';

  @override
  String get vietnamese => 'VIETNAMESE';

  @override
  String get english => 'ENGLISH';

  @override
  String get support => 'SUPPORT';

  @override
  String get helpCenter => 'Help Center';

  @override
  String get termsConditions => 'Terms & Conditions';

  @override
  String get status => 'Status';

  @override
  String get secure => 'Secure';

  @override
  String get technician => 'TECHNICIAN';

  @override
  String get customer => 'CUSTOMER';

  @override
  String get premiumPlatform => 'Premium Service Platform v1.0';

  @override
  String get fixitUser => 'FixIt User';

  @override
  String get professionalTechnicians => 'PROFESSIONAL TECHNICIANS';

  @override
  String helloUser(String name) {
    return 'HELLO, $name';
  }

  @override
  String get todayJobs => 'Here are your jobs for today';

  @override
  String get todayEarnings => 'Today\'s Earnings';

  @override
  String get completedOrders => 'Completed Orders';

  @override
  String get acceptanceRate => 'Acceptance Rate';

  @override
  String get service => 'SERVICE';

  @override
  String get technicianSmall => 'TECHNICIAN';

  @override
  String get noResultsFound => 'No results found';

  @override
  String get providerList => 'PROVIDER LIST';

  @override
  String get viewAll => 'VIEW ALL';

  @override
  String get view => 'VIEW';

  @override
  String get exportReport => 'Export Financial Report';

  @override
  String get focusModerator => 'Focus: Content Moderation, Services & Feedback';

  @override
  String get focusFinance => 'Focus: Finance Management, Revenue & Coupons';

  @override
  String get focusSupport => 'Focus: Customer Support, Orders & Operations';

  @override
  String applicationCount(Object type) {
    return '$type Application';
  }

  @override
  String error(Object message) {
    return 'Error: $message';
  }

  @override
  String get account => 'ACCOUNT';

  @override
  String get interface => 'Interface';

  @override
  String get specialty => 'Specialty';

  @override
  String get verification => 'Verification';

  @override
  String get subscriptionAndPayment => 'SUBSCRIPTION & PAYMENTS';

  @override
  String get upgradeAccount => 'Upgrade Account';

  @override
  String get generalPreferences => 'GENERAL PREFERENCES';

  @override
  String get profileInfo => 'PROFILE INFORMATION';

  @override
  String get walletAndPayment => 'Wallet & Payment';

  @override
  String get loggingOut => 'Logging out...';

  @override
  String get changeProfileToSelling => 'Switch to selling mode';

  @override
  String get changeProfileToBuying => 'Switch to buying mode';

  @override
  String get wantToManageRepairs => 'Want to manage repair jobs?';

  @override
  String get tryAgain => 'Try Again';

  @override
  String get serviceName => 'SERVICE NAME';

  @override
  String get enterServiceName => 'Enter service name';

  @override
  String get imageIdAsset => 'IMAGE ID / ASSET';

  @override
  String get enterIdOrAsset => 'Enter ID or Asset name';

  @override
  String get brandColorHex => 'BRAND COLOR (HEX)';

  @override
  String get popularServiceQuestion => 'Popular Service?';

  @override
  String get featuredOnHome => 'Featured on home screen';

  @override
  String get parentServiceRequired => 'PARENT SERVICE (REQUIRED)';

  @override
  String get noPopularServices => 'No popular services available';

  @override
  String get selectParentCategory => 'Select a parent category';

  @override
  String get livePreview => 'LIVE PREVIEW';

  @override
  String get noSubServicesFound => 'No sub-services found';

  @override
  String get serviceUpdated => 'Service updated successfully';

  @override
  String get serviceCreated => 'Service created successfully';

  @override
  String get serviceDeleted => 'Service deleted successfully';

  @override
  String get enterIdOrAssetName => 'Enter ID or Asset name';

  @override
  String get onboardingTitle1 => 'Welcome to\nFixIt Pro';

  @override
  String get onboardingDesc1 =>
      'Experience the next generation of home services at your fingertips.';

  @override
  String get onboardingTitle2 => 'Expert\nTechnicians';

  @override
  String get onboardingDesc2 =>
      'Only certified professionals handle your precious home appliances.';

  @override
  String get onboardingTitle3 => 'Secure & Fast\nPayments';

  @override
  String get onboardingDesc3 =>
      'Transparent pricing with instant secure checkout and tracking.';

  @override
  String get getStarted => 'Get Started';

  @override
  String get skip => 'SKIP';

  @override
  String get launchApp => 'Launch App';

  @override
  String get welcomeBack => 'Welcome Back!';

  @override
  String get loginSubtitle => 'Login to continue your journey';

  @override
  String get emailAddress => 'Email Address';

  @override
  String get emailHint => 'yourname@email.com';

  @override
  String get passwordHint => '••••••••';

  @override
  String get enterEmail => 'Enter your email';

  @override
  String get min6Chars => 'Min 6 characters';

  @override
  String get dontHaveAccount => 'Don\'t have an account? ';

  @override
  String get signUp => 'Sign Up';

  @override
  String get orLogInWith => 'OR LOG IN WITH';

  @override
  String get createAccount => 'Create Account';

  @override
  String get joinFuture => 'Join the future of home services';

  @override
  String get fullName => 'Full Name';

  @override
  String get fullNameHint => 'John Doe';

  @override
  String get enterName => 'Enter your name';

  @override
  String get agreeTo => 'I agree to the ';

  @override
  String get pleaseAgree => 'Please agree to the Terms & Conditions';

  @override
  String get alreadyHaveAccount => 'Already have an account? ';

  @override
  String get orRegisterWith => 'OR REGISTER WITH';

  @override
  String get errorInvalidCredentials => 'Invalid email or password.';

  @override
  String get errorNetwork => 'Network connection error.';

  @override
  String get errorEmailAlreadyExists => 'This email is already registered.';

  @override
  String get errorUnknown => 'An unexpected error occurred. Please try again.';

  @override
  String get emailVerification => 'Email Verification';

  @override
  String get enterEmailToReceiveOTP =>
      'Enter your email address to receive OTP';

  @override
  String get phoneVerification => 'Phone Verification';

  @override
  String get enterPhoneToReceiveOTP => 'Enter your phone number to receive OTP';

  @override
  String get sendCode => 'SEND CODE';

  @override
  String get accountNotRegistered => 'This account is not registered.';

  @override
  String get verificationCodeSent => 'Verification code sent to your email.';

  @override
  String get tooManyRequests =>
      'Too many requests. Please wait a few minutes and try again.';

  @override
  String waitSeconds(int seconds) {
    return 'WAIT ${seconds}S';
  }

  @override
  String get chooseResetMethod => 'Choose how you want to reset password';

  @override
  String get emailMethodSubtitle => 'Send link to your inbox';

  @override
  String get mobileNumber => 'Mobile Number';

  @override
  String get phoneMethodSubtitle => 'Send OTP to your phone';

  @override
  String get otpVerification => 'OTP Verification';

  @override
  String get enterCodeSentTo => 'Enter the 6-digit code sent to';

  @override
  String get verify => 'VERIFY';

  @override
  String get didntReceiveCode => 'Didn\'t receive the code?';

  @override
  String get resendCode => 'RESEND CODE';

  @override
  String resendIn(int seconds) {
    return 'RESEND IN ${seconds}s';
  }

  @override
  String get verificationCodeSentSmall => 'Verification code sent.';

  @override
  String get codeResentSuccess => 'Code resent successfully.';

  @override
  String get failedToSendCode => 'Failed to send code.';

  @override
  String get enterAllDigits => 'Please enter all 6 digits';

  @override
  String get verificationSuccessful => 'Verification successful!';

  @override
  String get invalidOTP => 'Invalid OTP code. Please check again.';

  @override
  String get yourEmail => 'your email';

  @override
  String get yourPhone => 'your phone number';

  @override
  String get settingNewPassword => 'Setting new password...';

  @override
  String get success => 'Success!';

  @override
  String get passwordUpdatedSuccess =>
      'Your password has been successfully updated. Please log in again with your new password.';

  @override
  String get backToLogin => 'BACK TO LOGIN';

  @override
  String get otpInvalidOrExpired =>
      'OTP code is invalid or has expired. Please start over.';

  @override
  String get newPassword => 'New Password';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get createStrongPassword =>
      'Please create a strong new password for your account';

  @override
  String get passwordMin8 => 'Password must be at least 8 characters';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match';

  @override
  String get savePassword => 'SAVE PASSWORD';

  @override
  String get enterPinSentToPhone =>
      'Enter 6-digit PIN code sent to your phone number';

  @override
  String get stillNotReceiveCode => 'Still not receive code? ';

  @override
  String get sendAgain => 'Send again';

  @override
  String sendAgainIn(int seconds) {
    return 'Send again (${seconds}s)';
  }

  @override
  String get verificationSuccess => 'Verification successful!';

  @override
  String get setupSuccessLoginAgain => 'Setup successful. Please log in again.';

  @override
  String get iAm => 'I am...';

  @override
  String get selectRoleToStart => 'Select your role to start';

  @override
  String get techRoleDesc => 'I provide professional repair services.';

  @override
  String get customerRoleDesc => 'I am looking for home repair services.';

  @override
  String get accountSetupSuccess => 'Account setup successful!';

  @override
  String get startNow => 'START NOW';

  @override
  String get techOnboardingTitle => 'Technician Profile Setup';

  @override
  String get enableLocationDesc =>
      'Enable location to find customers nearest to you';

  @override
  String get fastConnection => 'FAST CONNECTION';

  @override
  String get autoSearchRange => 'Automatically search within your range';

  @override
  String get allowMapAccess => 'Allow map access';

  @override
  String get maybeLater => 'Maybe later';

  @override
  String get locationPermissionBlocked => 'Location permission blocked';

  @override
  String get locationPermissionBlockedDesc =>
      'You have permanently denied location permission. To find nearby customers, please go to Settings to enable it.';

  @override
  String get openSettings => 'Open Settings';

  @override
  String get gpsOff => 'GPS is off. Please turn on location to continue.';

  @override
  String get needLocationPermission =>
      'You need to grant location permission to continue.';

  @override
  String get locationCanBeAddedLater =>
      'You can add your location later in Settings to receive jobs.';

  @override
  String get whatIsYourSpecialty => 'What is your specialty?';

  @override
  String get aboutMeHint => 'Describe your experience...';

  @override
  String get workingHoursAndRange => 'Working Hours & Range';

  @override
  String get from => 'From';

  @override
  String get to => 'To';

  @override
  String get serviceRadius => 'Service Radius';

  @override
  String get serviceArea => 'Service Area';

  @override
  String get noAreaSelected => 'No area selected';

  @override
  String get tapToAddArea => 'Tap to add service area';

  @override
  String get addMoreArea => 'Add more area';

  @override
  String get selectCity => 'Select City / Province';

  @override
  String get selectDistrict => 'Select District';

  @override
  String get selectWard => 'Select Ward';

  @override
  String get idNumberHint => 'Enter ID number (12 digits)';

  @override
  String get frontIdCard => 'Front of ID Card';

  @override
  String get backIdCard => 'Back of ID Card';

  @override
  String get tapToUpload => 'Tap to upload image';

  @override
  String scanningId(String label) {
    return 'Scanning $label...';
  }

  @override
  String get aiVerifying => 'AI system is verifying card content...';

  @override
  String get invalidIdFormat =>
      'Could not recognize ID format. Please capture correctly.';

  @override
  String frontBackMismatch(String side1, String side2) {
    return 'You are submitting $side1 into $side2 slot. Please retake.';
  }

  @override
  String validIdConfirmed(String label) {
    return '$label confirmed valid.';
  }

  @override
  String get toolsAndEquipment => 'Tools & Equipment';

  @override
  String get addToolSet => 'Add repair kit';

  @override
  String get toolSetDesc => 'Photos of devices you use for repair';

  @override
  String get professionalCert => 'Professional Certification (if any)';

  @override
  String get certDesc =>
      'Vocational degree, certificate or professional awards';

  @override
  String get paymentMethod => 'Payment Method';

  @override
  String get bankTransfer => 'Bank Transfer';

  @override
  String get momoZalo => 'MoMo / ZaloPay Wallet';

  @override
  String get cash => 'Cash';

  @override
  String get accountInfo => 'Account Information';

  @override
  String get selectBank => 'Select Bank';

  @override
  String get accountNumberHint => 'Account number / Wallet phone';

  @override
  String get verifyingInfo => 'Verifying information...';

  @override
  String get verifiedAccount => 'Verified Account';

  @override
  String get retryVerification => 'Retry verification';

  @override
  String get industryType => 'Industry & Experience';

  @override
  String get billingDetails => 'Billing Details';

  @override
  String get vdElectrician => 'e.g. Electrician...';

  @override
  String get enterSpecialty => 'Enter your main specialty';

  @override
  String get yearsExperience => 'Years of experience';

  @override
  String get seniority => 'Seniority';

  @override
  String get hourlyRateHint => 'e.g. 150,000';

  @override
  String get hourlyRateDesc => 'Expected fee for 1 hour of work (VND)';

  @override
  String get businessAddressHint => 'Business address (optional)';

  @override
  String get nearCustomersDesc => 'Helps nearby customers find you more easily';

  @override
  String get workSchedule => 'Work Schedule';

  @override
  String get allWeek => 'Full week (Mon - Sun)';

  @override
  String get officeHours => 'Office hours';

  @override
  String get weekendsOnly => 'Weekends only';

  @override
  String get selectScheduleDesc => 'Select when you can receive jobs';

  @override
  String get pleaseEnterRequiredFields => 'Please enter all required fields.';

  @override
  String get submittingApplication => 'SUBMITTING APPLICATION';

  @override
  String get optimizingImages => 'Optimizing images...';

  @override
  String get encryptingProfile => 'System is encrypting your profile...';

  @override
  String get applicationSentSuccess => 'Application sent successfully!';

  @override
  String get applicationSentDesc =>
      'Your profile has been sent. Please wait for system approval within the next 24 hours.';

  @override
  String get pendingApprovalTitle => 'PENDING APPROVAL';

  @override
  String get pendingApprovalDesc =>
      'The system is verifying your professional information. This process usually takes 2-24 hours.';

  @override
  String get approved => 'APPROVED';

  @override
  String get approvedDesc =>
      'Congratulations! Your profile has been approved. Preparing to enter home...';

  @override
  String get rejected => 'REJECTED';

  @override
  String get rejectedDesc =>
      'Sorry, your profile is not suitable. Please check your information or contact support.';

  @override
  String get applicationStatus => 'APPLICATION STATUS';

  @override
  String get waitingForApproval => 'Waiting for approval';

  @override
  String get logoutAccount => 'LOGOUT ACCOUNT';

  @override
  String get commonIssues => 'Common Issues';

  @override
  String get tapToSeeGuide =>
      'Tap on a problem to see step-by-step repair guide and tools.';

  @override
  String get needAnExpert => 'Need an expert?';

  @override
  String get bookVerifiedPro =>
      'Book a verified professional to handle it for you.';

  @override
  String get findTechnician => 'Find Technician';

  @override
  String get recommendedTools => 'Recommended Tools';

  @override
  String get repairInstructions => 'Repair Instructions';

  @override
  String get stillCantFixIt => 'Still can\'t fix it?';

  @override
  String get techAtDoorDesc =>
      'Our certified technicians can be at your door in 30 minutes.';

  @override
  String get bookAProfessional => 'Book a Professional';

  @override
  String get buy => 'Buy';

  @override
  String get expertSupport => 'Expert Support';

  @override
  String get allServices => 'All Services';

  @override
  String items(int count) {
    return '$count items';
  }

  @override
  String reliableServices(String service) {
    return 'Reliable\n$service Services';
  }

  @override
  String get banner_quality_work_title => 'Quality Work';

  @override
  String get banner_quality_work_desc => 'Verified experts for every task';

  @override
  String get banner_fast_repair_title => 'Fast Repair';

  @override
  String get banner_fast_repair_desc => 'Professional Technicians at your door';

  @override
  String get svc_plumbers => 'Plumbers';

  @override
  String get svc_electric_work => 'Electric Work';

  @override
  String get svc_solars => 'Solars';

  @override
  String get svc_ac_ventilation => 'Ac & Ventilation';

  @override
  String get svc_car_washer => 'Car Washer';

  @override
  String get svc_laundry => 'Laundrys';

  @override
  String get svc_paintings => 'Paintings';

  @override
  String get svc_floorings => 'Floorings';

  @override
  String get svc_cameras => 'Cameras';

  @override
  String get svc_locksmiths => 'Locksmiths';

  @override
  String get svc_cleaning => 'Cleaning service';

  @override
  String get svc_security => 'Security service';

  @override
  String get svc_mover => 'Mover service';

  @override
  String get svc_carpenter => 'Carpenter service';

  @override
  String get sub_car_wash => 'Car Wash';

  @override
  String get sub_car_waxing => 'Car Waxing';

  @override
  String get sub_oil_change => 'Oil change';

  @override
  String get sub_car_battery => 'Car battery';

  @override
  String get sub_interior_cleaning => 'Interior Cleaning';

  @override
  String get sub_tire_repair => 'Tire Repair';

  @override
  String get sub_wiring_install => 'Wiring Installation';

  @override
  String get sub_electrical_repairs => 'Electrical Repairs';

  @override
  String get sub_lighting_install => 'Indoor Lighting Installation';

  @override
  String get sub_fixture_install => 'Fixture Installation';

  @override
  String get sub_house_cleaning => 'House Cleaning';

  @override
  String get sub_office_cleaning => 'Office Cleaning';

  @override
  String get sub_deep_cleaning => 'Deep Cleaning';

  @override
  String get sub_kitchen_cleaning => 'Kitchen Cleaning';

  @override
  String get sub_ac_repairing => 'AC Repairing';

  @override
  String get sub_ac_installation => 'AC Installation';

  @override
  String get sub_ac_uninstallation => 'AC Uninstallation';

  @override
  String get sub_ac_service => 'AC Service';

  @override
  String get sub_pipe_leakage => 'Pipe Leakage';

  @override
  String get sub_tap_repair => 'Tap Repair';

  @override
  String get sub_toilet_repair => 'Toilet Repair';

  @override
  String get sub_drain_cleaning => 'Drain Cleaning';

  @override
  String get sub_plumber => 'Plumber';

  @override
  String get sub_pipe_wrench => 'Pipe Wrench';

  @override
  String get sub_water_tap => 'Water Tap';

  @override
  String get sub_plier => 'Plier';

  @override
  String get sub_multimeter => 'Multimeter';

  @override
  String get sub_electricity_meter => 'Electricity Meter';

  @override
  String get sub_drill => 'Drill';

  @override
  String get sub_solar_panel => 'Solar Panel';

  @override
  String get sub_cctv_install => 'CCTV Installation';

  @override
  String get sub_alarm_system => 'Alarm System';

  @override
  String get sub_lock_repair => 'Door Lock Repair';

  @override
  String get sub_biometric_access => 'Biometric Access';

  @override
  String get sub_house_moving => 'House Moving';

  @override
  String get sub_office_moving => 'Office Moving';

  @override
  String get sub_furniture_moving => 'Furniture Moving';

  @override
  String get sub_local_moving => 'Local Moving';

  @override
  String get sub_furniture_repair => 'Furniture Repair';

  @override
  String get sub_door_installation => 'Door Installation';

  @override
  String get sub_cabinet_repair => 'Cabinet Repair';

  @override
  String get sub_wood_polishing => 'Wood Polishing';

  @override
  String get sub_house_painting => 'House Painting';

  @override
  String get sub_exterior_painting => 'Exterior Painting';

  @override
  String get sub_interior_painting => 'Interior Painting';

  @override
  String get sub_wall_stenciling => 'Wall Stenciling';
}
