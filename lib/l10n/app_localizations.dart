import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_vi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('vi')
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'FixIt'**
  String get appName;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome to FixIt'**
  String get welcome;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @myProfile.
  ///
  /// In en, this message translates to:
  /// **'My Profile'**
  String get myProfile;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @bookings.
  ///
  /// In en, this message translates to:
  /// **'My Bookings'**
  String get bookings;

  /// No description provided for @wallet.
  ///
  /// In en, this message translates to:
  /// **'My Wallet'**
  String get wallet;

  /// No description provided for @helpSupport.
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get helpSupport;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// No description provided for @forgotPasswordQuery.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPasswordQuery;

  /// No description provided for @newToFixit.
  ///
  /// In en, this message translates to:
  /// **'New to FixIt?'**
  String get newToFixit;

  /// No description provided for @adminPanel.
  ///
  /// In en, this message translates to:
  /// **'ADMIN PANEL'**
  String get adminPanel;

  /// No description provided for @commandCenter.
  ///
  /// In en, this message translates to:
  /// **'Command Center'**
  String get commandCenter;

  /// No description provided for @helloAdmin.
  ///
  /// In en, this message translates to:
  /// **'Hello, {name}'**
  String helloAdmin(String name);

  /// No description provided for @revenue.
  ///
  /// In en, this message translates to:
  /// **'REVENUE'**
  String get revenue;

  /// No description provided for @activeJobs.
  ///
  /// In en, this message translates to:
  /// **'ACTIVE JOBS'**
  String get activeJobs;

  /// No description provided for @newUsers.
  ///
  /// In en, this message translates to:
  /// **'NEW USERS'**
  String get newUsers;

  /// No description provided for @pendingApps.
  ///
  /// In en, this message translates to:
  /// **'PENDING APPS'**
  String get pendingApps;

  /// No description provided for @revenueTrend.
  ///
  /// In en, this message translates to:
  /// **'REVENUE TREND (7 DAYS)'**
  String get revenueTrend;

  /// No description provided for @jobDistribution.
  ///
  /// In en, this message translates to:
  /// **'JOB DISTRIBUTION'**
  String get jobDistribution;

  /// No description provided for @quickOperations.
  ///
  /// In en, this message translates to:
  /// **'QUICK OPERATIONS'**
  String get quickOperations;

  /// No description provided for @recentApplications.
  ///
  /// In en, this message translates to:
  /// **'RECENT APPLICATIONS'**
  String get recentApplications;

  /// No description provided for @approvals.
  ///
  /// In en, this message translates to:
  /// **'Approvals'**
  String get approvals;

  /// No description provided for @users.
  ///
  /// In en, this message translates to:
  /// **'Users'**
  String get users;

  /// No description provided for @jobs.
  ///
  /// In en, this message translates to:
  /// **'Jobs'**
  String get jobs;

  /// No description provided for @services.
  ///
  /// In en, this message translates to:
  /// **'Services'**
  String get services;

  /// No description provided for @noJobData.
  ///
  /// In en, this message translates to:
  /// **'No job data available'**
  String get noJobData;

  /// No description provided for @noPendingApps.
  ///
  /// In en, this message translates to:
  /// **'No pending applications'**
  String get noPendingApps;

  /// No description provided for @banners.
  ///
  /// In en, this message translates to:
  /// **'Banners'**
  String get banners;

  /// No description provided for @config.
  ///
  /// In en, this message translates to:
  /// **'Config'**
  String get config;

  /// No description provided for @broadcast.
  ///
  /// In en, this message translates to:
  /// **'Broadcast'**
  String get broadcast;

  /// No description provided for @products.
  ///
  /// In en, this message translates to:
  /// **'Products'**
  String get products;

  /// No description provided for @ledger.
  ///
  /// In en, this message translates to:
  /// **'Ledger'**
  String get ledger;

  /// No description provided for @feedback.
  ///
  /// In en, this message translates to:
  /// **'Feedback'**
  String get feedback;

  /// No description provided for @coupons.
  ///
  /// In en, this message translates to:
  /// **'Coupons'**
  String get coupons;

  /// No description provided for @liveMap.
  ///
  /// In en, this message translates to:
  /// **'Live Map'**
  String get liveMap;

  /// No description provided for @reports.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get reports;

  /// No description provided for @staff.
  ///
  /// In en, this message translates to:
  /// **'Staff'**
  String get staff;

  /// No description provided for @auditLogs.
  ///
  /// In en, this message translates to:
  /// **'Audit Logs'**
  String get auditLogs;

  /// No description provided for @bcHistory.
  ///
  /// In en, this message translates to:
  /// **'BC History'**
  String get bcHistory;

  /// No description provided for @partsInventory.
  ///
  /// In en, this message translates to:
  /// **'Parts Inventory'**
  String get partsInventory;

  /// No description provided for @preferences.
  ///
  /// In en, this message translates to:
  /// **'PREFERENCES'**
  String get preferences;

  /// No description provided for @themeMode.
  ///
  /// In en, this message translates to:
  /// **'Theme Mode'**
  String get themeMode;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @system.
  ///
  /// In en, this message translates to:
  /// **'SYSTEM'**
  String get system;

  /// No description provided for @appInfo.
  ///
  /// In en, this message translates to:
  /// **'App Info'**
  String get appInfo;

  /// No description provided for @debugLogs.
  ///
  /// In en, this message translates to:
  /// **'Debug Logs'**
  String get debugLogs;

  /// No description provided for @securityLevel.
  ///
  /// In en, this message translates to:
  /// **'Security Level'**
  String get securityLevel;

  /// No description provided for @selectTheme.
  ///
  /// In en, this message translates to:
  /// **'SELECT THEME'**
  String get selectTheme;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'SELECT LANGUAGE'**
  String get selectLanguage;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @city.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get city;

  /// No description provided for @order.
  ///
  /// In en, this message translates to:
  /// **'Order'**
  String get order;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @logoutConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'LOGOUT'**
  String get logoutConfirmTitle;

  /// No description provided for @logoutConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to end this session?'**
  String get logoutConfirmMessage;

  /// No description provided for @logoutButton.
  ///
  /// In en, this message translates to:
  /// **'LOGOUT NOW'**
  String get logoutButton;

  /// No description provided for @cancelButton.
  ///
  /// In en, this message translates to:
  /// **'Stay'**
  String get cancelButton;

  /// No description provided for @userManagement.
  ///
  /// In en, this message translates to:
  /// **'USER MANAGEMENT'**
  String get userManagement;

  /// No description provided for @searchUserHint.
  ///
  /// In en, this message translates to:
  /// **'Find users by name or email...'**
  String get searchUserHint;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @admins.
  ///
  /// In en, this message translates to:
  /// **'Admins'**
  String get admins;

  /// No description provided for @technicians.
  ///
  /// In en, this message translates to:
  /// **'Technicians'**
  String get technicians;

  /// No description provided for @customers.
  ///
  /// In en, this message translates to:
  /// **'Customers'**
  String get customers;

  /// No description provided for @deleteAccountQuery.
  ///
  /// In en, this message translates to:
  /// **'DELETE ACCOUNT?'**
  String get deleteAccountQuery;

  /// No description provided for @deleteAccountDesc.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to permanently delete the account of {name}? This action cannot be undone.'**
  String deleteAccountDesc(String name);

  /// No description provided for @deleteNow.
  ///
  /// In en, this message translates to:
  /// **'DELETE NOW'**
  String get deleteNow;

  /// No description provided for @deactivateUserQuery.
  ///
  /// In en, this message translates to:
  /// **'DEACTIVATE USER?'**
  String get deactivateUserQuery;

  /// No description provided for @activateUserQuery.
  ///
  /// In en, this message translates to:
  /// **'ACTIVATE USER?'**
  String get activateUserQuery;

  /// No description provided for @deactivateDesc.
  ///
  /// In en, this message translates to:
  /// **'This user will no longer be able to access the app until you re-enable them.'**
  String get deactivateDesc;

  /// No description provided for @activateDesc.
  ///
  /// In en, this message translates to:
  /// **'This user will regain full access to the application services.'**
  String get activateDesc;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @noUsersFound.
  ///
  /// In en, this message translates to:
  /// **'No users found'**
  String get noUsersFound;

  /// No description provided for @serviceCatalog.
  ///
  /// In en, this message translates to:
  /// **'SERVICE CATALOG'**
  String get serviceCatalog;

  /// No description provided for @searchServicesHint.
  ///
  /// In en, this message translates to:
  /// **'Search services...'**
  String get searchServicesHint;

  /// No description provided for @popular.
  ///
  /// In en, this message translates to:
  /// **'Popular'**
  String get popular;

  /// No description provided for @regular.
  ///
  /// In en, this message translates to:
  /// **'Services'**
  String get regular;

  /// No description provided for @addService.
  ///
  /// In en, this message translates to:
  /// **'Add Service'**
  String get addService;

  /// No description provided for @editService.
  ///
  /// In en, this message translates to:
  /// **'Edit Service'**
  String get editService;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'SAVE CHANGES'**
  String get saveChanges;

  /// No description provided for @createService.
  ///
  /// In en, this message translates to:
  /// **'CREATE SERVICE'**
  String get createService;

  /// No description provided for @deleteServiceQuery.
  ///
  /// In en, this message translates to:
  /// **'DELETE SERVICE?'**
  String get deleteServiceQuery;

  /// No description provided for @deleteServiceDesc.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to permanently delete \"{title}\"? This will also delete ALL related issues, guides, and steps.'**
  String deleteServiceDesc(String title);

  /// No description provided for @deleteEverything.
  ///
  /// In en, this message translates to:
  /// **'DELETE EVERYTHING'**
  String get deleteEverything;

  /// No description provided for @identityVerification.
  ///
  /// In en, this message translates to:
  /// **'Identity Verification'**
  String get identityVerification;

  /// No description provided for @serviceOffer.
  ///
  /// In en, this message translates to:
  /// **'Service Offer'**
  String get serviceOffer;

  /// No description provided for @workingHours.
  ///
  /// In en, this message translates to:
  /// **'Working Hours'**
  String get workingHours;

  /// No description provided for @aboutMe.
  ///
  /// In en, this message translates to:
  /// **'About Me'**
  String get aboutMe;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit Application'**
  String get submit;

  /// No description provided for @finish.
  ///
  /// In en, this message translates to:
  /// **'Finish'**
  String get finish;

  /// No description provided for @currentBalance.
  ///
  /// In en, this message translates to:
  /// **'Current Balance'**
  String get currentBalance;

  /// No description provided for @totalEarned.
  ///
  /// In en, this message translates to:
  /// **'Total Earned'**
  String get totalEarned;

  /// No description provided for @transactionHistory.
  ///
  /// In en, this message translates to:
  /// **'Transaction History'**
  String get transactionHistory;

  /// No description provided for @deposit.
  ///
  /// In en, this message translates to:
  /// **'Deposit'**
  String get deposit;

  /// No description provided for @withdraw.
  ///
  /// In en, this message translates to:
  /// **'Withdraw'**
  String get withdraw;

  /// No description provided for @typeMessage.
  ///
  /// In en, this message translates to:
  /// **'Type a message...'**
  String get typeMessage;

  /// No description provided for @calling.
  ///
  /// In en, this message translates to:
  /// **'Calling...'**
  String get calling;

  /// No description provided for @incomingCall.
  ///
  /// In en, this message translates to:
  /// **'Incoming Call...'**
  String get incomingCall;

  /// No description provided for @mute.
  ///
  /// In en, this message translates to:
  /// **'Mute'**
  String get mute;

  /// No description provided for @speaker.
  ///
  /// In en, this message translates to:
  /// **'Speaker'**
  String get speaker;

  /// No description provided for @noNotifications.
  ///
  /// In en, this message translates to:
  /// **'No notifications yet'**
  String get noNotifications;

  /// No description provided for @markAllAsRead.
  ///
  /// In en, this message translates to:
  /// **'Mark all as read'**
  String get markAllAsRead;

  /// No description provided for @idNumber.
  ///
  /// In en, this message translates to:
  /// **'ID Number'**
  String get idNumber;

  /// No description provided for @bankName.
  ///
  /// In en, this message translates to:
  /// **'Bank Name'**
  String get bankName;

  /// No description provided for @accountNumber.
  ///
  /// In en, this message translates to:
  /// **'Account Number'**
  String get accountNumber;

  /// No description provided for @accountHolder.
  ///
  /// In en, this message translates to:
  /// **'Account Holder'**
  String get accountHolder;

  /// No description provided for @hourlyRate.
  ///
  /// In en, this message translates to:
  /// **'Hourly Rate'**
  String get hourlyRate;

  /// No description provided for @applicationReceived.
  ///
  /// In en, this message translates to:
  /// **'Application Received'**
  String get applicationReceived;

  /// No description provided for @applicationReceivedDesc.
  ///
  /// In en, this message translates to:
  /// **'Your application has been sent to the administrator. We will contact you soon!'**
  String get applicationReceivedDesc;

  /// No description provided for @rating.
  ///
  /// In en, this message translates to:
  /// **'Rating'**
  String get rating;

  /// No description provided for @orders.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get orders;

  /// No description provided for @experience.
  ///
  /// In en, this message translates to:
  /// **'Experience'**
  String get experience;

  /// No description provided for @skills.
  ///
  /// In en, this message translates to:
  /// **'Skills'**
  String get skills;

  /// No description provided for @bio.
  ///
  /// In en, this message translates to:
  /// **'Bio'**
  String get bio;

  /// No description provided for @reviews.
  ///
  /// In en, this message translates to:
  /// **'Reviews'**
  String get reviews;

  /// No description provided for @bookService.
  ///
  /// In en, this message translates to:
  /// **'Book Service'**
  String get bookService;

  /// No description provided for @years.
  ///
  /// In en, this message translates to:
  /// **'years'**
  String get years;

  /// No description provided for @noReviews.
  ///
  /// In en, this message translates to:
  /// **'No reviews yet.'**
  String get noReviews;

  /// No description provided for @testKey.
  ///
  /// In en, this message translates to:
  /// **'Test'**
  String get testKey;

  /// No description provided for @systemMode.
  ///
  /// In en, this message translates to:
  /// **'SYSTEM'**
  String get systemMode;

  /// No description provided for @lightMode.
  ///
  /// In en, this message translates to:
  /// **'LIGHT MODE'**
  String get lightMode;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'DARK MODE'**
  String get darkMode;

  /// No description provided for @vietnamese.
  ///
  /// In en, this message translates to:
  /// **'VIETNAMESE'**
  String get vietnamese;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'ENGLISH'**
  String get english;

  /// No description provided for @support.
  ///
  /// In en, this message translates to:
  /// **'SUPPORT'**
  String get support;

  /// No description provided for @helpCenter.
  ///
  /// In en, this message translates to:
  /// **'Help Center'**
  String get helpCenter;

  /// No description provided for @termsConditions.
  ///
  /// In en, this message translates to:
  /// **'Terms & Conditions'**
  String get termsConditions;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @secure.
  ///
  /// In en, this message translates to:
  /// **'Secure'**
  String get secure;

  /// No description provided for @technician.
  ///
  /// In en, this message translates to:
  /// **'TECHNICIAN'**
  String get technician;

  /// No description provided for @customer.
  ///
  /// In en, this message translates to:
  /// **'CUSTOMER'**
  String get customer;

  /// No description provided for @premiumPlatform.
  ///
  /// In en, this message translates to:
  /// **'Premium Service Platform v1.0'**
  String get premiumPlatform;

  /// No description provided for @fixitUser.
  ///
  /// In en, this message translates to:
  /// **'FixIt User'**
  String get fixitUser;

  /// No description provided for @professionalTechnicians.
  ///
  /// In en, this message translates to:
  /// **'PROFESSIONAL TECHNICIANS'**
  String get professionalTechnicians;

  /// No description provided for @helloUser.
  ///
  /// In en, this message translates to:
  /// **'HELLO, {name}'**
  String helloUser(String name);

  /// No description provided for @todayJobs.
  ///
  /// In en, this message translates to:
  /// **'Here are your jobs for today'**
  String get todayJobs;

  /// No description provided for @todayEarnings.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Earnings'**
  String get todayEarnings;

  /// No description provided for @completedOrders.
  ///
  /// In en, this message translates to:
  /// **'Completed Orders'**
  String get completedOrders;

  /// No description provided for @acceptanceRate.
  ///
  /// In en, this message translates to:
  /// **'Acceptance Rate'**
  String get acceptanceRate;

  /// No description provided for @service.
  ///
  /// In en, this message translates to:
  /// **'SERVICE'**
  String get service;

  /// No description provided for @technicianSmall.
  ///
  /// In en, this message translates to:
  /// **'TECHNICIAN'**
  String get technicianSmall;

  /// No description provided for @noResultsFound.
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get noResultsFound;

  /// No description provided for @providerList.
  ///
  /// In en, this message translates to:
  /// **'PROVIDER LIST'**
  String get providerList;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'VIEW ALL'**
  String get viewAll;

  /// No description provided for @view.
  ///
  /// In en, this message translates to:
  /// **'VIEW'**
  String get view;

  /// No description provided for @exportReport.
  ///
  /// In en, this message translates to:
  /// **'Export Financial Report'**
  String get exportReport;

  /// No description provided for @focusModerator.
  ///
  /// In en, this message translates to:
  /// **'Focus: Content Moderation, Services & Feedback'**
  String get focusModerator;

  /// No description provided for @focusFinance.
  ///
  /// In en, this message translates to:
  /// **'Focus: Finance Management, Revenue & Coupons'**
  String get focusFinance;

  /// No description provided for @focusSupport.
  ///
  /// In en, this message translates to:
  /// **'Focus: Customer Support, Orders & Operations'**
  String get focusSupport;

  /// No description provided for @applicationCount.
  ///
  /// In en, this message translates to:
  /// **'{type} Application'**
  String applicationCount(Object type);

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error: {message}'**
  String error(Object message);

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'ACCOUNT'**
  String get account;

  /// No description provided for @interface.
  ///
  /// In en, this message translates to:
  /// **'Interface'**
  String get interface;

  /// No description provided for @specialty.
  ///
  /// In en, this message translates to:
  /// **'Specialty'**
  String get specialty;

  /// No description provided for @verification.
  ///
  /// In en, this message translates to:
  /// **'Verification'**
  String get verification;

  /// No description provided for @subscriptionAndPayment.
  ///
  /// In en, this message translates to:
  /// **'SUBSCRIPTION & PAYMENTS'**
  String get subscriptionAndPayment;

  /// No description provided for @upgradeAccount.
  ///
  /// In en, this message translates to:
  /// **'Upgrade Account'**
  String get upgradeAccount;

  /// No description provided for @generalPreferences.
  ///
  /// In en, this message translates to:
  /// **'GENERAL PREFERENCES'**
  String get generalPreferences;

  /// No description provided for @profileInfo.
  ///
  /// In en, this message translates to:
  /// **'PROFILE INFORMATION'**
  String get profileInfo;

  /// No description provided for @walletAndPayment.
  ///
  /// In en, this message translates to:
  /// **'Wallet & Payment'**
  String get walletAndPayment;

  /// No description provided for @loggingOut.
  ///
  /// In en, this message translates to:
  /// **'Logging out...'**
  String get loggingOut;

  /// No description provided for @changeProfileToSelling.
  ///
  /// In en, this message translates to:
  /// **'Switch to selling mode'**
  String get changeProfileToSelling;

  /// No description provided for @changeProfileToBuying.
  ///
  /// In en, this message translates to:
  /// **'Switch to buying mode'**
  String get changeProfileToBuying;

  /// No description provided for @wantToManageRepairs.
  ///
  /// In en, this message translates to:
  /// **'Want to manage repair jobs?'**
  String get wantToManageRepairs;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get tryAgain;

  /// No description provided for @serviceName.
  ///
  /// In en, this message translates to:
  /// **'SERVICE NAME'**
  String get serviceName;

  /// No description provided for @enterServiceName.
  ///
  /// In en, this message translates to:
  /// **'Enter service name'**
  String get enterServiceName;

  /// No description provided for @imageIdAsset.
  ///
  /// In en, this message translates to:
  /// **'IMAGE ID / ASSET'**
  String get imageIdAsset;

  /// No description provided for @enterIdOrAsset.
  ///
  /// In en, this message translates to:
  /// **'Enter ID or Asset name'**
  String get enterIdOrAsset;

  /// No description provided for @brandColorHex.
  ///
  /// In en, this message translates to:
  /// **'BRAND COLOR (HEX)'**
  String get brandColorHex;

  /// No description provided for @popularServiceQuestion.
  ///
  /// In en, this message translates to:
  /// **'Popular Service?'**
  String get popularServiceQuestion;

  /// No description provided for @featuredOnHome.
  ///
  /// In en, this message translates to:
  /// **'Featured on home screen'**
  String get featuredOnHome;

  /// No description provided for @parentServiceRequired.
  ///
  /// In en, this message translates to:
  /// **'PARENT SERVICE (REQUIRED)'**
  String get parentServiceRequired;

  /// No description provided for @noPopularServices.
  ///
  /// In en, this message translates to:
  /// **'No popular services available'**
  String get noPopularServices;

  /// No description provided for @selectParentCategory.
  ///
  /// In en, this message translates to:
  /// **'Select a parent category'**
  String get selectParentCategory;

  /// No description provided for @livePreview.
  ///
  /// In en, this message translates to:
  /// **'LIVE PREVIEW'**
  String get livePreview;

  /// No description provided for @noSubServicesFound.
  ///
  /// In en, this message translates to:
  /// **'No sub-services found'**
  String get noSubServicesFound;

  /// No description provided for @serviceUpdated.
  ///
  /// In en, this message translates to:
  /// **'Service updated successfully'**
  String get serviceUpdated;

  /// No description provided for @serviceCreated.
  ///
  /// In en, this message translates to:
  /// **'Service created successfully'**
  String get serviceCreated;

  /// No description provided for @serviceDeleted.
  ///
  /// In en, this message translates to:
  /// **'Service deleted successfully'**
  String get serviceDeleted;

  /// No description provided for @enterIdOrAssetName.
  ///
  /// In en, this message translates to:
  /// **'Enter ID or Asset name'**
  String get enterIdOrAssetName;

  /// No description provided for @onboardingTitle1.
  ///
  /// In en, this message translates to:
  /// **'Welcome to\nFixIt Pro'**
  String get onboardingTitle1;

  /// No description provided for @onboardingDesc1.
  ///
  /// In en, this message translates to:
  /// **'Experience the next generation of home services at your fingertips.'**
  String get onboardingDesc1;

  /// No description provided for @onboardingTitle2.
  ///
  /// In en, this message translates to:
  /// **'Expert\nTechnicians'**
  String get onboardingTitle2;

  /// No description provided for @onboardingDesc2.
  ///
  /// In en, this message translates to:
  /// **'Only certified professionals handle your precious home appliances.'**
  String get onboardingDesc2;

  /// No description provided for @onboardingTitle3.
  ///
  /// In en, this message translates to:
  /// **'Secure & Fast\nPayments'**
  String get onboardingTitle3;

  /// No description provided for @onboardingDesc3.
  ///
  /// In en, this message translates to:
  /// **'Transparent pricing with instant secure checkout and tracking.'**
  String get onboardingDesc3;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'SKIP'**
  String get skip;

  /// No description provided for @launchApp.
  ///
  /// In en, this message translates to:
  /// **'Launch App'**
  String get launchApp;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back!'**
  String get welcomeBack;

  /// No description provided for @loginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Login to continue your journey'**
  String get loginSubtitle;

  /// No description provided for @emailAddress.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get emailAddress;

  /// No description provided for @emailHint.
  ///
  /// In en, this message translates to:
  /// **'yourname@email.com'**
  String get emailHint;

  /// No description provided for @passwordHint.
  ///
  /// In en, this message translates to:
  /// **'••••••••'**
  String get passwordHint;

  /// No description provided for @enterEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get enterEmail;

  /// No description provided for @min6Chars.
  ///
  /// In en, this message translates to:
  /// **'Min 6 characters'**
  String get min6Chars;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? '**
  String get dontHaveAccount;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// No description provided for @orLogInWith.
  ///
  /// In en, this message translates to:
  /// **'OR LOG IN WITH'**
  String get orLogInWith;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @joinFuture.
  ///
  /// In en, this message translates to:
  /// **'Join the future of home services'**
  String get joinFuture;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @fullNameHint.
  ///
  /// In en, this message translates to:
  /// **'John Doe'**
  String get fullNameHint;

  /// No description provided for @enterName.
  ///
  /// In en, this message translates to:
  /// **'Enter your name'**
  String get enterName;

  /// No description provided for @agreeTo.
  ///
  /// In en, this message translates to:
  /// **'I agree to the '**
  String get agreeTo;

  /// No description provided for @pleaseAgree.
  ///
  /// In en, this message translates to:
  /// **'Please agree to the Terms & Conditions'**
  String get pleaseAgree;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get alreadyHaveAccount;

  /// No description provided for @orRegisterWith.
  ///
  /// In en, this message translates to:
  /// **'OR REGISTER WITH'**
  String get orRegisterWith;

  /// No description provided for @errorInvalidCredentials.
  ///
  /// In en, this message translates to:
  /// **'Invalid email or password.'**
  String get errorInvalidCredentials;

  /// No description provided for @errorNetwork.
  ///
  /// In en, this message translates to:
  /// **'Network connection error.'**
  String get errorNetwork;

  /// No description provided for @errorEmailAlreadyExists.
  ///
  /// In en, this message translates to:
  /// **'This email is already registered.'**
  String get errorEmailAlreadyExists;

  /// No description provided for @errorUnknown.
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occurred. Please try again.'**
  String get errorUnknown;

  /// No description provided for @emailVerification.
  ///
  /// In en, this message translates to:
  /// **'Email Verification'**
  String get emailVerification;

  /// No description provided for @enterEmailToReceiveOTP.
  ///
  /// In en, this message translates to:
  /// **'Enter your email address to receive OTP'**
  String get enterEmailToReceiveOTP;

  /// No description provided for @phoneVerification.
  ///
  /// In en, this message translates to:
  /// **'Phone Verification'**
  String get phoneVerification;

  /// No description provided for @enterPhoneToReceiveOTP.
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number to receive OTP'**
  String get enterPhoneToReceiveOTP;

  /// No description provided for @sendCode.
  ///
  /// In en, this message translates to:
  /// **'SEND CODE'**
  String get sendCode;

  /// No description provided for @accountNotRegistered.
  ///
  /// In en, this message translates to:
  /// **'This account is not registered.'**
  String get accountNotRegistered;

  /// No description provided for @verificationCodeSent.
  ///
  /// In en, this message translates to:
  /// **'Verification code sent to your email.'**
  String get verificationCodeSent;

  /// No description provided for @tooManyRequests.
  ///
  /// In en, this message translates to:
  /// **'Too many requests. Please wait a few minutes and try again.'**
  String get tooManyRequests;

  /// No description provided for @waitSeconds.
  ///
  /// In en, this message translates to:
  /// **'WAIT {seconds}S'**
  String waitSeconds(int seconds);

  /// No description provided for @chooseResetMethod.
  ///
  /// In en, this message translates to:
  /// **'Choose how you want to reset password'**
  String get chooseResetMethod;

  /// No description provided for @emailMethodSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Send link to your inbox'**
  String get emailMethodSubtitle;

  /// No description provided for @mobileNumber.
  ///
  /// In en, this message translates to:
  /// **'Mobile Number'**
  String get mobileNumber;

  /// No description provided for @phoneMethodSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Send OTP to your phone'**
  String get phoneMethodSubtitle;

  /// No description provided for @otpVerification.
  ///
  /// In en, this message translates to:
  /// **'OTP Verification'**
  String get otpVerification;

  /// No description provided for @enterCodeSentTo.
  ///
  /// In en, this message translates to:
  /// **'Enter the 6-digit code sent to'**
  String get enterCodeSentTo;

  /// No description provided for @verify.
  ///
  /// In en, this message translates to:
  /// **'VERIFY'**
  String get verify;

  /// No description provided for @didntReceiveCode.
  ///
  /// In en, this message translates to:
  /// **'Didn\'t receive the code?'**
  String get didntReceiveCode;

  /// No description provided for @resendCode.
  ///
  /// In en, this message translates to:
  /// **'RESEND CODE'**
  String get resendCode;

  /// No description provided for @resendIn.
  ///
  /// In en, this message translates to:
  /// **'RESEND IN {seconds}s'**
  String resendIn(int seconds);

  /// No description provided for @verificationCodeSentSmall.
  ///
  /// In en, this message translates to:
  /// **'Verification code sent.'**
  String get verificationCodeSentSmall;

  /// No description provided for @codeResentSuccess.
  ///
  /// In en, this message translates to:
  /// **'Code resent successfully.'**
  String get codeResentSuccess;

  /// No description provided for @failedToSendCode.
  ///
  /// In en, this message translates to:
  /// **'Failed to send code.'**
  String get failedToSendCode;

  /// No description provided for @enterAllDigits.
  ///
  /// In en, this message translates to:
  /// **'Please enter all 6 digits'**
  String get enterAllDigits;

  /// No description provided for @verificationSuccessful.
  ///
  /// In en, this message translates to:
  /// **'Verification successful!'**
  String get verificationSuccessful;

  /// No description provided for @invalidOTP.
  ///
  /// In en, this message translates to:
  /// **'Invalid OTP code. Please check again.'**
  String get invalidOTP;

  /// No description provided for @yourEmail.
  ///
  /// In en, this message translates to:
  /// **'your email'**
  String get yourEmail;

  /// No description provided for @yourPhone.
  ///
  /// In en, this message translates to:
  /// **'your phone number'**
  String get yourPhone;

  /// No description provided for @settingNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Setting new password...'**
  String get settingNewPassword;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success!'**
  String get success;

  /// No description provided for @passwordUpdatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Your password has been successfully updated. Please log in again with your new password.'**
  String get passwordUpdatedSuccess;

  /// No description provided for @backToLogin.
  ///
  /// In en, this message translates to:
  /// **'BACK TO LOGIN'**
  String get backToLogin;

  /// No description provided for @otpInvalidOrExpired.
  ///
  /// In en, this message translates to:
  /// **'OTP code is invalid or has expired. Please start over.'**
  String get otpInvalidOrExpired;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get newPassword;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @createStrongPassword.
  ///
  /// In en, this message translates to:
  /// **'Please create a strong new password for your account'**
  String get createStrongPassword;

  /// No description provided for @passwordMin8.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters'**
  String get passwordMin8;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// No description provided for @savePassword.
  ///
  /// In en, this message translates to:
  /// **'SAVE PASSWORD'**
  String get savePassword;

  /// No description provided for @enterPinSentToPhone.
  ///
  /// In en, this message translates to:
  /// **'Enter 6-digit PIN code sent to your phone number'**
  String get enterPinSentToPhone;

  /// No description provided for @stillNotReceiveCode.
  ///
  /// In en, this message translates to:
  /// **'Still not receive code? '**
  String get stillNotReceiveCode;

  /// No description provided for @sendAgain.
  ///
  /// In en, this message translates to:
  /// **'Send again'**
  String get sendAgain;

  /// No description provided for @sendAgainIn.
  ///
  /// In en, this message translates to:
  /// **'Send again ({seconds}s)'**
  String sendAgainIn(int seconds);

  /// No description provided for @verificationSuccess.
  ///
  /// In en, this message translates to:
  /// **'Verification successful!'**
  String get verificationSuccess;

  /// No description provided for @setupSuccessLoginAgain.
  ///
  /// In en, this message translates to:
  /// **'Setup successful. Please log in again.'**
  String get setupSuccessLoginAgain;

  /// No description provided for @iAm.
  ///
  /// In en, this message translates to:
  /// **'I am...'**
  String get iAm;

  /// No description provided for @selectRoleToStart.
  ///
  /// In en, this message translates to:
  /// **'Select your role to start'**
  String get selectRoleToStart;

  /// No description provided for @techRoleDesc.
  ///
  /// In en, this message translates to:
  /// **'I provide professional repair services.'**
  String get techRoleDesc;

  /// No description provided for @customerRoleDesc.
  ///
  /// In en, this message translates to:
  /// **'I am looking for home repair services.'**
  String get customerRoleDesc;

  /// No description provided for @accountSetupSuccess.
  ///
  /// In en, this message translates to:
  /// **'Account setup successful!'**
  String get accountSetupSuccess;

  /// No description provided for @startNow.
  ///
  /// In en, this message translates to:
  /// **'START NOW'**
  String get startNow;

  /// No description provided for @techOnboardingTitle.
  ///
  /// In en, this message translates to:
  /// **'Technician Profile Setup'**
  String get techOnboardingTitle;

  /// No description provided for @enableLocationDesc.
  ///
  /// In en, this message translates to:
  /// **'Enable location to find customers nearest to you'**
  String get enableLocationDesc;

  /// No description provided for @fastConnection.
  ///
  /// In en, this message translates to:
  /// **'FAST CONNECTION'**
  String get fastConnection;

  /// No description provided for @autoSearchRange.
  ///
  /// In en, this message translates to:
  /// **'Automatically search within your range'**
  String get autoSearchRange;

  /// No description provided for @allowMapAccess.
  ///
  /// In en, this message translates to:
  /// **'Allow map access'**
  String get allowMapAccess;

  /// No description provided for @maybeLater.
  ///
  /// In en, this message translates to:
  /// **'Maybe later'**
  String get maybeLater;

  /// No description provided for @locationPermissionBlocked.
  ///
  /// In en, this message translates to:
  /// **'Location permission blocked'**
  String get locationPermissionBlocked;

  /// No description provided for @locationPermissionBlockedDesc.
  ///
  /// In en, this message translates to:
  /// **'You have permanently denied location permission. To find nearby customers, please go to Settings to enable it.'**
  String get locationPermissionBlockedDesc;

  /// No description provided for @openSettings.
  ///
  /// In en, this message translates to:
  /// **'Open Settings'**
  String get openSettings;

  /// No description provided for @gpsOff.
  ///
  /// In en, this message translates to:
  /// **'GPS is off. Please turn on location to continue.'**
  String get gpsOff;

  /// No description provided for @needLocationPermission.
  ///
  /// In en, this message translates to:
  /// **'You need to grant location permission to continue.'**
  String get needLocationPermission;

  /// No description provided for @locationCanBeAddedLater.
  ///
  /// In en, this message translates to:
  /// **'You can add your location later in Settings to receive jobs.'**
  String get locationCanBeAddedLater;

  /// No description provided for @whatIsYourSpecialty.
  ///
  /// In en, this message translates to:
  /// **'What is your specialty?'**
  String get whatIsYourSpecialty;

  /// No description provided for @aboutMeHint.
  ///
  /// In en, this message translates to:
  /// **'Describe your experience...'**
  String get aboutMeHint;

  /// No description provided for @workingHoursAndRange.
  ///
  /// In en, this message translates to:
  /// **'Working Hours & Range'**
  String get workingHoursAndRange;

  /// No description provided for @from.
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get from;

  /// No description provided for @to.
  ///
  /// In en, this message translates to:
  /// **'To'**
  String get to;

  /// No description provided for @serviceRadius.
  ///
  /// In en, this message translates to:
  /// **'Service Radius'**
  String get serviceRadius;

  /// No description provided for @serviceArea.
  ///
  /// In en, this message translates to:
  /// **'Service Area'**
  String get serviceArea;

  /// No description provided for @noAreaSelected.
  ///
  /// In en, this message translates to:
  /// **'No area selected'**
  String get noAreaSelected;

  /// No description provided for @tapToAddArea.
  ///
  /// In en, this message translates to:
  /// **'Tap to add service area'**
  String get tapToAddArea;

  /// No description provided for @addMoreArea.
  ///
  /// In en, this message translates to:
  /// **'Add more area'**
  String get addMoreArea;

  /// No description provided for @selectCity.
  ///
  /// In en, this message translates to:
  /// **'Select City / Province'**
  String get selectCity;

  /// No description provided for @selectDistrict.
  ///
  /// In en, this message translates to:
  /// **'Select District'**
  String get selectDistrict;

  /// No description provided for @selectWard.
  ///
  /// In en, this message translates to:
  /// **'Select Ward'**
  String get selectWard;

  /// No description provided for @idNumberHint.
  ///
  /// In en, this message translates to:
  /// **'Enter ID number (12 digits)'**
  String get idNumberHint;

  /// No description provided for @frontIdCard.
  ///
  /// In en, this message translates to:
  /// **'Front of ID Card'**
  String get frontIdCard;

  /// No description provided for @backIdCard.
  ///
  /// In en, this message translates to:
  /// **'Back of ID Card'**
  String get backIdCard;

  /// No description provided for @tapToUpload.
  ///
  /// In en, this message translates to:
  /// **'Tap to upload image'**
  String get tapToUpload;

  /// No description provided for @scanningId.
  ///
  /// In en, this message translates to:
  /// **'Scanning {label}...'**
  String scanningId(String label);

  /// No description provided for @aiVerifying.
  ///
  /// In en, this message translates to:
  /// **'AI system is verifying card content...'**
  String get aiVerifying;

  /// No description provided for @invalidIdFormat.
  ///
  /// In en, this message translates to:
  /// **'Could not recognize ID format. Please capture correctly.'**
  String get invalidIdFormat;

  /// No description provided for @frontBackMismatch.
  ///
  /// In en, this message translates to:
  /// **'You are submitting {side1} into {side2} slot. Please retake.'**
  String frontBackMismatch(String side1, String side2);

  /// No description provided for @validIdConfirmed.
  ///
  /// In en, this message translates to:
  /// **'{label} confirmed valid.'**
  String validIdConfirmed(String label);

  /// No description provided for @toolsAndEquipment.
  ///
  /// In en, this message translates to:
  /// **'Tools & Equipment'**
  String get toolsAndEquipment;

  /// No description provided for @addToolSet.
  ///
  /// In en, this message translates to:
  /// **'Add repair kit'**
  String get addToolSet;

  /// No description provided for @toolSetDesc.
  ///
  /// In en, this message translates to:
  /// **'Photos of devices you use for repair'**
  String get toolSetDesc;

  /// No description provided for @professionalCert.
  ///
  /// In en, this message translates to:
  /// **'Professional Certification (if any)'**
  String get professionalCert;

  /// No description provided for @certDesc.
  ///
  /// In en, this message translates to:
  /// **'Vocational degree, certificate or professional awards'**
  String get certDesc;

  /// No description provided for @paymentMethod.
  ///
  /// In en, this message translates to:
  /// **'Payment Method'**
  String get paymentMethod;

  /// No description provided for @bankTransfer.
  ///
  /// In en, this message translates to:
  /// **'Bank Transfer'**
  String get bankTransfer;

  /// No description provided for @momoZalo.
  ///
  /// In en, this message translates to:
  /// **'MoMo / ZaloPay Wallet'**
  String get momoZalo;

  /// No description provided for @cash.
  ///
  /// In en, this message translates to:
  /// **'Cash'**
  String get cash;

  /// No description provided for @accountInfo.
  ///
  /// In en, this message translates to:
  /// **'Account Information'**
  String get accountInfo;

  /// No description provided for @selectBank.
  ///
  /// In en, this message translates to:
  /// **'Select Bank'**
  String get selectBank;

  /// No description provided for @accountNumberHint.
  ///
  /// In en, this message translates to:
  /// **'Account number / Wallet phone'**
  String get accountNumberHint;

  /// No description provided for @verifyingInfo.
  ///
  /// In en, this message translates to:
  /// **'Verifying information...'**
  String get verifyingInfo;

  /// No description provided for @verifiedAccount.
  ///
  /// In en, this message translates to:
  /// **'Verified Account'**
  String get verifiedAccount;

  /// No description provided for @retryVerification.
  ///
  /// In en, this message translates to:
  /// **'Retry verification'**
  String get retryVerification;

  /// No description provided for @industryType.
  ///
  /// In en, this message translates to:
  /// **'Industry & Experience'**
  String get industryType;

  /// No description provided for @billingDetails.
  ///
  /// In en, this message translates to:
  /// **'Billing Details'**
  String get billingDetails;

  /// No description provided for @vdElectrician.
  ///
  /// In en, this message translates to:
  /// **'e.g. Electrician...'**
  String get vdElectrician;

  /// No description provided for @enterSpecialty.
  ///
  /// In en, this message translates to:
  /// **'Enter your main specialty'**
  String get enterSpecialty;

  /// No description provided for @yearsExperience.
  ///
  /// In en, this message translates to:
  /// **'Years of experience'**
  String get yearsExperience;

  /// No description provided for @seniority.
  ///
  /// In en, this message translates to:
  /// **'Seniority'**
  String get seniority;

  /// No description provided for @hourlyRateHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 150,000'**
  String get hourlyRateHint;

  /// No description provided for @hourlyRateDesc.
  ///
  /// In en, this message translates to:
  /// **'Expected fee for 1 hour of work (VND)'**
  String get hourlyRateDesc;

  /// No description provided for @businessAddressHint.
  ///
  /// In en, this message translates to:
  /// **'Business address (optional)'**
  String get businessAddressHint;

  /// No description provided for @nearCustomersDesc.
  ///
  /// In en, this message translates to:
  /// **'Helps nearby customers find you more easily'**
  String get nearCustomersDesc;

  /// No description provided for @workSchedule.
  ///
  /// In en, this message translates to:
  /// **'Work Schedule'**
  String get workSchedule;

  /// No description provided for @allWeek.
  ///
  /// In en, this message translates to:
  /// **'Full week (Mon - Sun)'**
  String get allWeek;

  /// No description provided for @officeHours.
  ///
  /// In en, this message translates to:
  /// **'Office hours'**
  String get officeHours;

  /// No description provided for @weekendsOnly.
  ///
  /// In en, this message translates to:
  /// **'Weekends only'**
  String get weekendsOnly;

  /// No description provided for @selectScheduleDesc.
  ///
  /// In en, this message translates to:
  /// **'Select when you can receive jobs'**
  String get selectScheduleDesc;

  /// No description provided for @pleaseEnterRequiredFields.
  ///
  /// In en, this message translates to:
  /// **'Please enter all required fields.'**
  String get pleaseEnterRequiredFields;

  /// No description provided for @submittingApplication.
  ///
  /// In en, this message translates to:
  /// **'SUBMITTING APPLICATION'**
  String get submittingApplication;

  /// No description provided for @optimizingImages.
  ///
  /// In en, this message translates to:
  /// **'Optimizing images...'**
  String get optimizingImages;

  /// No description provided for @encryptingProfile.
  ///
  /// In en, this message translates to:
  /// **'System is encrypting your profile...'**
  String get encryptingProfile;

  /// No description provided for @applicationSentSuccess.
  ///
  /// In en, this message translates to:
  /// **'Application sent successfully!'**
  String get applicationSentSuccess;

  /// No description provided for @applicationSentDesc.
  ///
  /// In en, this message translates to:
  /// **'Your profile has been sent. Please wait for system approval within the next 24 hours.'**
  String get applicationSentDesc;

  /// No description provided for @pendingApprovalTitle.
  ///
  /// In en, this message translates to:
  /// **'PENDING APPROVAL'**
  String get pendingApprovalTitle;

  /// No description provided for @pendingApprovalDesc.
  ///
  /// In en, this message translates to:
  /// **'The system is verifying your professional information. This process usually takes 2-24 hours.'**
  String get pendingApprovalDesc;

  /// No description provided for @approved.
  ///
  /// In en, this message translates to:
  /// **'APPROVED'**
  String get approved;

  /// No description provided for @approvedDesc.
  ///
  /// In en, this message translates to:
  /// **'Congratulations! Your profile has been approved. Preparing to enter home...'**
  String get approvedDesc;

  /// No description provided for @rejected.
  ///
  /// In en, this message translates to:
  /// **'REJECTED'**
  String get rejected;

  /// No description provided for @rejectedDesc.
  ///
  /// In en, this message translates to:
  /// **'Sorry, your profile is not suitable. Please check your information or contact support.'**
  String get rejectedDesc;

  /// No description provided for @applicationStatus.
  ///
  /// In en, this message translates to:
  /// **'APPLICATION STATUS'**
  String get applicationStatus;

  /// No description provided for @waitingForApproval.
  ///
  /// In en, this message translates to:
  /// **'Waiting for approval'**
  String get waitingForApproval;

  /// No description provided for @logoutAccount.
  ///
  /// In en, this message translates to:
  /// **'LOGOUT ACCOUNT'**
  String get logoutAccount;

  /// No description provided for @commonIssues.
  ///
  /// In en, this message translates to:
  /// **'Common Issues'**
  String get commonIssues;

  /// No description provided for @tapToSeeGuide.
  ///
  /// In en, this message translates to:
  /// **'Tap on a problem to see step-by-step repair guide and tools.'**
  String get tapToSeeGuide;

  /// No description provided for @needAnExpert.
  ///
  /// In en, this message translates to:
  /// **'Need an expert?'**
  String get needAnExpert;

  /// No description provided for @bookVerifiedPro.
  ///
  /// In en, this message translates to:
  /// **'Book a verified professional to handle it for you.'**
  String get bookVerifiedPro;

  /// No description provided for @findTechnician.
  ///
  /// In en, this message translates to:
  /// **'Find Technician'**
  String get findTechnician;

  /// No description provided for @recommendedTools.
  ///
  /// In en, this message translates to:
  /// **'Recommended Tools'**
  String get recommendedTools;

  /// No description provided for @repairInstructions.
  ///
  /// In en, this message translates to:
  /// **'Repair Instructions'**
  String get repairInstructions;

  /// No description provided for @stillCantFixIt.
  ///
  /// In en, this message translates to:
  /// **'Still can\'t fix it?'**
  String get stillCantFixIt;

  /// No description provided for @techAtDoorDesc.
  ///
  /// In en, this message translates to:
  /// **'Our certified technicians can be at your door in 30 minutes.'**
  String get techAtDoorDesc;

  /// No description provided for @bookAProfessional.
  ///
  /// In en, this message translates to:
  /// **'Book a Professional'**
  String get bookAProfessional;

  /// No description provided for @buy.
  ///
  /// In en, this message translates to:
  /// **'Buy'**
  String get buy;

  /// No description provided for @expertSupport.
  ///
  /// In en, this message translates to:
  /// **'Expert Support'**
  String get expertSupport;

  /// No description provided for @allServices.
  ///
  /// In en, this message translates to:
  /// **'All Services'**
  String get allServices;

  /// No description provided for @items.
  ///
  /// In en, this message translates to:
  /// **'{count} items'**
  String items(int count);

  /// No description provided for @reliableServices.
  ///
  /// In en, this message translates to:
  /// **'Reliable\n{service} Services'**
  String reliableServices(String service);

  /// No description provided for @banner_quality_work_title.
  ///
  /// In en, this message translates to:
  /// **'Quality Work'**
  String get banner_quality_work_title;

  /// No description provided for @banner_quality_work_desc.
  ///
  /// In en, this message translates to:
  /// **'Verified experts for every task'**
  String get banner_quality_work_desc;

  /// No description provided for @banner_fast_repair_title.
  ///
  /// In en, this message translates to:
  /// **'Fast Repair'**
  String get banner_fast_repair_title;

  /// No description provided for @banner_fast_repair_desc.
  ///
  /// In en, this message translates to:
  /// **'Professional Technicians at your door'**
  String get banner_fast_repair_desc;

  /// No description provided for @svc_plumbers.
  ///
  /// In en, this message translates to:
  /// **'Plumbers'**
  String get svc_plumbers;

  /// No description provided for @svc_electric_work.
  ///
  /// In en, this message translates to:
  /// **'Electric Work'**
  String get svc_electric_work;

  /// No description provided for @svc_solars.
  ///
  /// In en, this message translates to:
  /// **'Solars'**
  String get svc_solars;

  /// No description provided for @svc_ac_ventilation.
  ///
  /// In en, this message translates to:
  /// **'Ac & Ventilation'**
  String get svc_ac_ventilation;

  /// No description provided for @svc_car_washer.
  ///
  /// In en, this message translates to:
  /// **'Car Washer'**
  String get svc_car_washer;

  /// No description provided for @svc_laundry.
  ///
  /// In en, this message translates to:
  /// **'Laundrys'**
  String get svc_laundry;

  /// No description provided for @svc_paintings.
  ///
  /// In en, this message translates to:
  /// **'Paintings'**
  String get svc_paintings;

  /// No description provided for @svc_floorings.
  ///
  /// In en, this message translates to:
  /// **'Floorings'**
  String get svc_floorings;

  /// No description provided for @svc_cameras.
  ///
  /// In en, this message translates to:
  /// **'Cameras'**
  String get svc_cameras;

  /// No description provided for @svc_locksmiths.
  ///
  /// In en, this message translates to:
  /// **'Locksmiths'**
  String get svc_locksmiths;

  /// No description provided for @svc_cleaning.
  ///
  /// In en, this message translates to:
  /// **'Cleaning service'**
  String get svc_cleaning;

  /// No description provided for @svc_security.
  ///
  /// In en, this message translates to:
  /// **'Security service'**
  String get svc_security;

  /// No description provided for @svc_mover.
  ///
  /// In en, this message translates to:
  /// **'Mover service'**
  String get svc_mover;

  /// No description provided for @svc_carpenter.
  ///
  /// In en, this message translates to:
  /// **'Carpenter service'**
  String get svc_carpenter;

  /// No description provided for @sub_car_wash.
  ///
  /// In en, this message translates to:
  /// **'Car Wash'**
  String get sub_car_wash;

  /// No description provided for @sub_car_waxing.
  ///
  /// In en, this message translates to:
  /// **'Car Waxing'**
  String get sub_car_waxing;

  /// No description provided for @sub_oil_change.
  ///
  /// In en, this message translates to:
  /// **'Oil change'**
  String get sub_oil_change;

  /// No description provided for @sub_car_battery.
  ///
  /// In en, this message translates to:
  /// **'Car battery'**
  String get sub_car_battery;

  /// No description provided for @sub_interior_cleaning.
  ///
  /// In en, this message translates to:
  /// **'Interior Cleaning'**
  String get sub_interior_cleaning;

  /// No description provided for @sub_tire_repair.
  ///
  /// In en, this message translates to:
  /// **'Tire Repair'**
  String get sub_tire_repair;

  /// No description provided for @sub_wiring_install.
  ///
  /// In en, this message translates to:
  /// **'Wiring Installation'**
  String get sub_wiring_install;

  /// No description provided for @sub_electrical_repairs.
  ///
  /// In en, this message translates to:
  /// **'Electrical Repairs'**
  String get sub_electrical_repairs;

  /// No description provided for @sub_lighting_install.
  ///
  /// In en, this message translates to:
  /// **'Indoor Lighting Installation'**
  String get sub_lighting_install;

  /// No description provided for @sub_fixture_install.
  ///
  /// In en, this message translates to:
  /// **'Fixture Installation'**
  String get sub_fixture_install;

  /// No description provided for @sub_house_cleaning.
  ///
  /// In en, this message translates to:
  /// **'House Cleaning'**
  String get sub_house_cleaning;

  /// No description provided for @sub_office_cleaning.
  ///
  /// In en, this message translates to:
  /// **'Office Cleaning'**
  String get sub_office_cleaning;

  /// No description provided for @sub_deep_cleaning.
  ///
  /// In en, this message translates to:
  /// **'Deep Cleaning'**
  String get sub_deep_cleaning;

  /// No description provided for @sub_kitchen_cleaning.
  ///
  /// In en, this message translates to:
  /// **'Kitchen Cleaning'**
  String get sub_kitchen_cleaning;

  /// No description provided for @sub_ac_repairing.
  ///
  /// In en, this message translates to:
  /// **'AC Repairing'**
  String get sub_ac_repairing;

  /// No description provided for @sub_ac_installation.
  ///
  /// In en, this message translates to:
  /// **'AC Installation'**
  String get sub_ac_installation;

  /// No description provided for @sub_ac_uninstallation.
  ///
  /// In en, this message translates to:
  /// **'AC Uninstallation'**
  String get sub_ac_uninstallation;

  /// No description provided for @sub_ac_service.
  ///
  /// In en, this message translates to:
  /// **'AC Service'**
  String get sub_ac_service;

  /// No description provided for @sub_pipe_leakage.
  ///
  /// In en, this message translates to:
  /// **'Pipe Leakage'**
  String get sub_pipe_leakage;

  /// No description provided for @sub_tap_repair.
  ///
  /// In en, this message translates to:
  /// **'Tap Repair'**
  String get sub_tap_repair;

  /// No description provided for @sub_toilet_repair.
  ///
  /// In en, this message translates to:
  /// **'Toilet Repair'**
  String get sub_toilet_repair;

  /// No description provided for @sub_drain_cleaning.
  ///
  /// In en, this message translates to:
  /// **'Drain Cleaning'**
  String get sub_drain_cleaning;

  /// No description provided for @sub_plumber.
  ///
  /// In en, this message translates to:
  /// **'Plumber'**
  String get sub_plumber;

  /// No description provided for @sub_pipe_wrench.
  ///
  /// In en, this message translates to:
  /// **'Pipe Wrench'**
  String get sub_pipe_wrench;

  /// No description provided for @sub_water_tap.
  ///
  /// In en, this message translates to:
  /// **'Water Tap'**
  String get sub_water_tap;

  /// No description provided for @sub_plier.
  ///
  /// In en, this message translates to:
  /// **'Plier'**
  String get sub_plier;

  /// No description provided for @sub_multimeter.
  ///
  /// In en, this message translates to:
  /// **'Multimeter'**
  String get sub_multimeter;

  /// No description provided for @sub_electricity_meter.
  ///
  /// In en, this message translates to:
  /// **'Electricity Meter'**
  String get sub_electricity_meter;

  /// No description provided for @sub_drill.
  ///
  /// In en, this message translates to:
  /// **'Drill'**
  String get sub_drill;

  /// No description provided for @sub_solar_panel.
  ///
  /// In en, this message translates to:
  /// **'Solar Panel'**
  String get sub_solar_panel;

  /// No description provided for @sub_cctv_install.
  ///
  /// In en, this message translates to:
  /// **'CCTV Installation'**
  String get sub_cctv_install;

  /// No description provided for @sub_alarm_system.
  ///
  /// In en, this message translates to:
  /// **'Alarm System'**
  String get sub_alarm_system;

  /// No description provided for @sub_lock_repair.
  ///
  /// In en, this message translates to:
  /// **'Door Lock Repair'**
  String get sub_lock_repair;

  /// No description provided for @sub_biometric_access.
  ///
  /// In en, this message translates to:
  /// **'Biometric Access'**
  String get sub_biometric_access;

  /// No description provided for @sub_house_moving.
  ///
  /// In en, this message translates to:
  /// **'House Moving'**
  String get sub_house_moving;

  /// No description provided for @sub_office_moving.
  ///
  /// In en, this message translates to:
  /// **'Office Moving'**
  String get sub_office_moving;

  /// No description provided for @sub_furniture_moving.
  ///
  /// In en, this message translates to:
  /// **'Furniture Moving'**
  String get sub_furniture_moving;

  /// No description provided for @sub_local_moving.
  ///
  /// In en, this message translates to:
  /// **'Local Moving'**
  String get sub_local_moving;

  /// No description provided for @sub_furniture_repair.
  ///
  /// In en, this message translates to:
  /// **'Furniture Repair'**
  String get sub_furniture_repair;

  /// No description provided for @sub_door_installation.
  ///
  /// In en, this message translates to:
  /// **'Door Installation'**
  String get sub_door_installation;

  /// No description provided for @sub_cabinet_repair.
  ///
  /// In en, this message translates to:
  /// **'Cabinet Repair'**
  String get sub_cabinet_repair;

  /// No description provided for @sub_wood_polishing.
  ///
  /// In en, this message translates to:
  /// **'Wood Polishing'**
  String get sub_wood_polishing;

  /// No description provided for @sub_house_painting.
  ///
  /// In en, this message translates to:
  /// **'House Painting'**
  String get sub_house_painting;

  /// No description provided for @sub_exterior_painting.
  ///
  /// In en, this message translates to:
  /// **'Exterior Painting'**
  String get sub_exterior_painting;

  /// No description provided for @sub_interior_painting.
  ///
  /// In en, this message translates to:
  /// **'Interior Painting'**
  String get sub_interior_painting;

  /// No description provided for @sub_wall_stenciling.
  ///
  /// In en, this message translates to:
  /// **'Wall Stenciling'**
  String get sub_wall_stenciling;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'vi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'vi':
      return AppLocalizationsVi();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
