import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 's_ar.dart';
import 's_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of S
/// returned by `S.of(context)`.
///
/// Applications need to include `S.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'localization/s.dart';
///
/// return MaterialApp(
///   localizationsDelegates: S.localizationsDelegates,
///   supportedLocales: S.supportedLocales,
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
/// be consistent with the languages listed in the S.supportedLocales
/// property.
abstract class S {
  S(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static S? of(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  static const LocalizationsDelegate<S> delegate = _SDelegate();

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
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @lang.
  ///
  /// In en, this message translates to:
  /// **'العربية'**
  String get lang;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @onboard1.
  ///
  /// In en, this message translates to:
  /// **'Juggling multiple systems that don’t talk to each other drains time & rescoures'**
  String get onboard1;

  /// No description provided for @onboard2.
  ///
  /// In en, this message translates to:
  /// **'We create creative,functional & secure systems that unify your operations & data'**
  String get onboard2;

  /// No description provided for @onboard3.
  ///
  /// In en, this message translates to:
  /// **'Explore our services or chat with an expert today'**
  String get onboard3;

  /// No description provided for @exploreOurWork.
  ///
  /// In en, this message translates to:
  /// **'Explore Our Work'**
  String get exploreOurWork;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? Sign in'**
  String get alreadyHaveAccount;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get signUp;

  /// No description provided for @companyName.
  ///
  /// In en, this message translates to:
  /// **'Company Name'**
  String get companyName;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @jobTitle.
  ///
  /// In en, this message translates to:
  /// **'Job Title'**
  String get jobTitle;

  /// No description provided for @department.
  ///
  /// In en, this message translates to:
  /// **'Department'**
  String get department;

  /// No description provided for @joinOurServices.
  ///
  /// In en, this message translates to:
  /// **'Join our services platform'**
  String get joinOurServices;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create an account'**
  String get createAccount;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don’t have an account? Sign up'**
  String get dontHaveAccount;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get signIn;

  /// No description provided for @forgetPassword.
  ///
  /// In en, this message translates to:
  /// **'Forget password'**
  String get forgetPassword;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get confirmPassword;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePassword;

  /// No description provided for @currentPassword.
  ///
  /// In en, this message translates to:
  /// **'Current Password'**
  String get currentPassword;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get newPassword;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @signInAccessOurServices.
  ///
  /// In en, this message translates to:
  /// **'Sign in to access our services'**
  String get signInAccessOurServices;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get welcomeBack;

  /// No description provided for @featuredServices.
  ///
  /// In en, this message translates to:
  /// **'Featured Services'**
  String get featuredServices;

  /// No description provided for @quickAccessToOurMostPopularServices.
  ///
  /// In en, this message translates to:
  /// **'Quick access to our most popular services'**
  String get quickAccessToOurMostPopularServices;

  /// No description provided for @meetings.
  ///
  /// In en, this message translates to:
  /// **'Meetings'**
  String get meetings;

  /// No description provided for @weSendVerificationCodeToYourEmail.
  ///
  /// In en, this message translates to:
  /// **'we send verification code to your email, you can check your email.'**
  String get weSendVerificationCodeToYourEmail;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @resetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset password'**
  String get resetPassword;

  /// No description provided for @verificationCode.
  ///
  /// In en, this message translates to:
  /// **'Verification code'**
  String get verificationCode;

  /// No description provided for @sendAgain.
  ///
  /// In en, this message translates to:
  /// **'Send again'**
  String get sendAgain;

  /// No description provided for @verify.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get verify;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @weProvideIntegratedDigitalSolutions.
  ///
  /// In en, this message translates to:
  /// **'We provide integrated digital solutions for companies and institutions.'**
  String get weProvideIntegratedDigitalSolutions;

  /// No description provided for @companyDescription.
  ///
  /// In en, this message translates to:
  /// **'Company description'**
  String get companyDescription;

  /// No description provided for @ourPartners.
  ///
  /// In en, this message translates to:
  /// **'Our Partners'**
  String get ourPartners;

  /// No description provided for @pioneerCompanyInDigitalSolutionsField.
  ///
  /// In en, this message translates to:
  /// **'Pioneer company in digital solutions field'**
  String get pioneerCompanyInDigitalSolutionsField;

  /// No description provided for @companyOverview.
  ///
  /// In en, this message translates to:
  /// **'Company overview'**
  String get companyOverview;

  /// No description provided for @companyProfile.
  ///
  /// In en, this message translates to:
  /// **'Company profile'**
  String get companyProfile;

  /// No description provided for @chooseNotificationPreferences.
  ///
  /// In en, this message translates to:
  /// **'Choose how you want to be notified about updates and activities'**
  String get chooseNotificationPreferences;

  /// No description provided for @notificationPreferences.
  ///
  /// In en, this message translates to:
  /// **'Notification Preferences'**
  String get notificationPreferences;

  /// No description provided for @submitTicket.
  ///
  /// In en, this message translates to:
  /// **'Submit Ticket'**
  String get submitTicket;

  /// No description provided for @describeYourIssue.
  ///
  /// In en, this message translates to:
  /// **'Describe your issue & we will help you resolve it'**
  String get describeYourIssue;

  /// No description provided for @createSupportTicket.
  ///
  /// In en, this message translates to:
  /// **'Create support ticket'**
  String get createSupportTicket;

  /// No description provided for @stepByStepVideoGuides.
  ///
  /// In en, this message translates to:
  /// **'Step by step video guides'**
  String get stepByStepVideoGuides;

  /// No description provided for @videoTutorials.
  ///
  /// In en, this message translates to:
  /// **'Video Tutorials'**
  String get videoTutorials;

  /// No description provided for @getImmediateAssistanceFromOurSupportTeam.
  ///
  /// In en, this message translates to:
  /// **'Get immediate assistance from our support team'**
  String get getImmediateAssistanceFromOurSupportTeam;

  /// No description provided for @quickContact.
  ///
  /// In en, this message translates to:
  /// **'Quick Contact'**
  String get quickContact;

  /// No description provided for @past.
  ///
  /// In en, this message translates to:
  /// **'Past'**
  String get past;

  /// No description provided for @scheduleNew.
  ///
  /// In en, this message translates to:
  /// **'Schedule new'**
  String get scheduleNew;

  /// No description provided for @upcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get upcoming;

  /// No description provided for @recentProjects.
  ///
  /// In en, this message translates to:
  /// **'Recent Projects'**
  String get recentProjects;

  /// No description provided for @allServices.
  ///
  /// In en, this message translates to:
  /// **'All Services'**
  String get allServices;

  /// No description provided for @exploreOurCompleteRangeOfSolutions.
  ///
  /// In en, this message translates to:
  /// **'Explore our complete range of solutions'**
  String get exploreOurCompleteRangeOfSolutions;

  /// No description provided for @loadingDetails.
  ///
  /// In en, this message translates to:
  /// **'Loading details...'**
  String get loadingDetails;

  /// No description provided for @contactSales.
  ///
  /// In en, this message translates to:
  /// **'Contact sales'**
  String get contactSales;

  /// No description provided for @serviceOverview.
  ///
  /// In en, this message translates to:
  /// **'Service Overview'**
  String get serviceOverview;

  /// No description provided for @keyFeatures.
  ///
  /// In en, this message translates to:
  /// **'Key Features'**
  String get keyFeatures;

  /// No description provided for @typicalProcess.
  ///
  /// In en, this message translates to:
  /// **'Typical Process'**
  String get typicalProcess;

  /// No description provided for @errorLoadingServices.
  ///
  /// In en, this message translates to:
  /// **'Error loading services'**
  String get errorLoadingServices;

  /// No description provided for @noServicesToShow.
  ///
  /// In en, this message translates to:
  /// **'No services to display.'**
  String get noServicesToShow;

  /// No description provided for @enterprise.
  ///
  /// In en, this message translates to:
  /// **'Enterprise'**
  String get enterprise;

  /// No description provided for @learnMore.
  ///
  /// In en, this message translates to:
  /// **'Learn more'**
  String get learnMore;

  /// No description provided for @start.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get start;

  /// No description provided for @fastSolutionsBot.
  ///
  /// In en, this message translates to:
  /// **'Fast solutions with our chat bot'**
  String get fastSolutionsBot;

  /// No description provided for @meetSitMind.
  ///
  /// In en, this message translates to:
  /// **'Meet SIT mind'**
  String get meetSitMind;

  /// No description provided for @clients.
  ///
  /// In en, this message translates to:
  /// **'Clients'**
  String get clients;

  /// No description provided for @visits.
  ///
  /// In en, this message translates to:
  /// **'Visits'**
  String get visits;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @onboard1Title.
  ///
  /// In en, this message translates to:
  /// **'View all your medical test results securely in one place.'**
  String get onboard1Title;

  /// No description provided for @onboard1Desc.
  ///
  /// In en, this message translates to:
  /// **'Discover our amazing features and ease of use.'**
  String get onboard1Desc;

  /// No description provided for @onboard2Title.
  ///
  /// In en, this message translates to:
  /// **'Receive instant notifications when new lab results are available.'**
  String get onboard2Title;

  /// No description provided for @onboard2Desc.
  ///
  /// In en, this message translates to:
  /// **'Easily connect with your friends and family.'**
  String get onboard2Desc;

  /// No description provided for @onboard3Title.
  ///
  /// In en, this message translates to:
  /// **'Easily track your lab history with clear organization for each test type.'**
  String get onboard3Title;

  /// No description provided for @onboard3Desc.
  ///
  /// In en, this message translates to:
  /// **'Sign up and start your journey with us today!'**
  String get onboard3Desc;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'My Account'**
  String get profile;

  /// No description provided for @services.
  ///
  /// In en, this message translates to:
  /// **'Services'**
  String get services;

  /// No description provided for @testResults.
  ///
  /// In en, this message translates to:
  /// **'Lab Results'**
  String get testResults;

  /// No description provided for @support.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get support;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get welcome;

  /// No description provided for @mobileNumber.
  ///
  /// In en, this message translates to:
  /// **'Mobile Number'**
  String get mobileNumber;

  /// No description provided for @enterMobileNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter mobile number'**
  String get enterMobileNumber;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @enterYourPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get enterYourPassword;

  /// No description provided for @required.
  ///
  /// In en, this message translates to:
  /// **'Field is required'**
  String get required;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Log In'**
  String get login;

  /// No description provided for @latestResults.
  ///
  /// In en, this message translates to:
  /// **'Latest Results'**
  String get latestResults;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get viewAll;

  /// No description provided for @welcomeGreeting.
  ///
  /// In en, this message translates to:
  /// **'Welcome 👋'**
  String get welcomeGreeting;

  /// No description provided for @trackYourTestResults.
  ///
  /// In en, this message translates to:
  /// **'Track your test results'**
  String get trackYourTestResults;

  /// No description provided for @viewLabResultsInstantly.
  ///
  /// In en, this message translates to:
  /// **'You can now view your lab test results as soon as they are released.'**
  String get viewLabResultsInstantly;

  /// No description provided for @searchByVisitNumber.
  ///
  /// In en, this message translates to:
  /// **'Search by visit number...'**
  String get searchByVisitNumber;

  /// No description provided for @fromTo.
  ///
  /// In en, this message translates to:
  /// **'From - To'**
  String get fromTo;

  /// No description provided for @dateSelected.
  ///
  /// In en, this message translates to:
  /// **'Date selected'**
  String get dateSelected;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @filterResults.
  ///
  /// In en, this message translates to:
  /// **'Filter results'**
  String get filterResults;

  /// No description provided for @visitNumber.
  ///
  /// In en, this message translates to:
  /// **'Visit Number'**
  String get visitNumber;

  /// No description provided for @visitDate.
  ///
  /// In en, this message translates to:
  /// **'Visit Date'**
  String get visitDate;

  /// No description provided for @tests.
  ///
  /// In en, this message translates to:
  /// **'Tests'**
  String get tests;

  /// No description provided for @viewDetailsAndResults.
  ///
  /// In en, this message translates to:
  /// **'View details and results'**
  String get viewDetailsAndResults;

  /// No description provided for @visitDetails.
  ///
  /// In en, this message translates to:
  /// **'Visit Details'**
  String get visitDetails;

  /// No description provided for @viewResults.
  ///
  /// In en, this message translates to:
  /// **'View Results'**
  String get viewResults;

  /// No description provided for @downloadResultsPdf.
  ///
  /// In en, this message translates to:
  /// **'Download & Print Results'**
  String get downloadResultsPdf;

  /// No description provided for @more.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get more;

  /// No description provided for @appSettings.
  ///
  /// In en, this message translates to:
  /// **'App Settings'**
  String get appSettings;

  /// No description provided for @supportAndHelp.
  ///
  /// In en, this message translates to:
  /// **'Support & Help'**
  String get supportAndHelp;

  /// No description provided for @appLanguage.
  ///
  /// In en, this message translates to:
  /// **'App Language'**
  String get appLanguage;

  /// No description provided for @aboutUs.
  ///
  /// In en, this message translates to:
  /// **'About Us'**
  String get aboutUs;

  /// No description provided for @callUs.
  ///
  /// In en, this message translates to:
  /// **'Call Us'**
  String get callUs;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @logOut.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get logOut;

  /// No description provided for @changeLanguage.
  ///
  /// In en, this message translates to:
  /// **'Change Language'**
  String get changeLanguage;

  /// No description provided for @analysisRequestNumber.
  ///
  /// In en, this message translates to:
  /// **'Analysis Request No.'**
  String get analysisRequestNumber;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// No description provided for @noResults.
  ///
  /// In en, this message translates to:
  /// **'No results'**
  String get noResults;

  /// No description provided for @cancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get cancelled;

  /// No description provided for @booking.
  ///
  /// In en, this message translates to:
  /// **'Booking'**
  String get booking;

  /// No description provided for @loadingError.
  ///
  /// In en, this message translates to:
  /// **'An error occurred while loading'**
  String get loadingError;

  /// No description provided for @open.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get open;

  /// No description provided for @downloadSuccess.
  ///
  /// In en, this message translates to:
  /// **'Downloaded successfully'**
  String get downloadSuccess;

  /// No description provided for @noResultLink.
  ///
  /// In en, this message translates to:
  /// **'No result link available'**
  String get noResultLink;

  /// No description provided for @pressAgainToExit.
  ///
  /// In en, this message translates to:
  /// **'Press again to exit the app'**
  String get pressAgainToExit;

  /// No description provided for @poweredBy.
  ///
  /// In en, this message translates to:
  /// **'Powered by'**
  String get poweredBy;

  /// No description provided for @areYouSureLogout.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to log out?'**
  String get areYouSureLogout;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @fileNumber.
  ///
  /// In en, this message translates to:
  /// **'File Number'**
  String get fileNumber;

  /// No description provided for @versionNumber.
  ///
  /// In en, this message translates to:
  /// **'Version Number'**
  String get versionNumber;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @somethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong!'**
  String get somethingWentWrong;

  /// No description provided for @goBack.
  ///
  /// In en, this message translates to:
  /// **'Go Back'**
  String get goBack;

  /// No description provided for @updateStatus.
  ///
  /// In en, this message translates to:
  /// **'Update Status'**
  String get updateStatus;

  /// No description provided for @serverMaintenanceMessage.
  ///
  /// In en, this message translates to:
  /// **'We are currently performing some server updates to improve the service.\nPlease try again later.'**
  String get serverMaintenanceMessage;

  /// No description provided for @underMaintenance.
  ///
  /// In en, this message translates to:
  /// **'Under Maintenance'**
  String get underMaintenance;

  /// No description provided for @reps.
  ///
  /// In en, this message translates to:
  /// **'Representatives'**
  String get reps;

  /// No description provided for @salesTracker.
  ///
  /// In en, this message translates to:
  /// **'Sales Tracker'**
  String get salesTracker;

  /// No description provided for @salesTrackerDescription.
  ///
  /// In en, this message translates to:
  /// **'Organize sales, clients, and field visits'**
  String get salesTrackerDescription;

  /// No description provided for @sitServices.
  ///
  /// In en, this message translates to:
  /// **'SIT Services'**
  String get sitServices;

  /// No description provided for @sitServicesDescription.
  ///
  /// In en, this message translates to:
  /// **'Comprehensive tech services for business growth'**
  String get sitServicesDescription;

  /// No description provided for @goodMorning.
  ///
  /// In en, this message translates to:
  /// **'Good Morning'**
  String get goodMorning;

  /// No description provided for @goodEvening.
  ///
  /// In en, this message translates to:
  /// **'Good Evening'**
  String get goodEvening;

  /// No description provided for @statistics.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get statistics;

  /// No description provided for @numberOfVisits.
  ///
  /// In en, this message translates to:
  /// **'Number Of Visits'**
  String get numberOfVisits;

  /// No description provided for @numberOfClients.
  ///
  /// In en, this message translates to:
  /// **'Number Of Clients'**
  String get numberOfClients;

  /// No description provided for @addClient.
  ///
  /// In en, this message translates to:
  /// **'Add Client'**
  String get addClient;

  /// No description provided for @addVisit.
  ///
  /// In en, this message translates to:
  /// **'Add Visit'**
  String get addVisit;

  /// No description provided for @procedures.
  ///
  /// In en, this message translates to:
  /// **'Procedures'**
  String get procedures;

  /// No description provided for @numberOfReps.
  ///
  /// In en, this message translates to:
  /// **'Number Of Representatives'**
  String get numberOfReps;

  /// No description provided for @clientsSearch.
  ///
  /// In en, this message translates to:
  /// **'Clients Search...'**
  String get clientsSearch;

  /// No description provided for @visitsSearch.
  ///
  /// In en, this message translates to:
  /// **'Visits Search...'**
  String get visitsSearch;

  /// No description provided for @allClients.
  ///
  /// In en, this message translates to:
  /// **'All Clients'**
  String get allClients;

  /// No description provided for @thereIsNoClients.
  ///
  /// In en, this message translates to:
  /// **'There Is No Clients'**
  String get thereIsNoClients;

  /// No description provided for @allVisits.
  ///
  /// In en, this message translates to:
  /// **'All Visits'**
  String get allVisits;

  /// No description provided for @clientInformation.
  ///
  /// In en, this message translates to:
  /// **'Client Information'**
  String get clientInformation;

  /// No description provided for @clientName.
  ///
  /// In en, this message translates to:
  /// **'Client Name'**
  String get clientName;

  /// No description provided for @businessName.
  ///
  /// In en, this message translates to:
  /// **'Business Name'**
  String get businessName;

  /// No description provided for @region.
  ///
  /// In en, this message translates to:
  /// **'Region'**
  String get region;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @attachment.
  ///
  /// In en, this message translates to:
  /// **'Attachment'**
  String get attachment;

  /// No description provided for @imageCanNotBeDownloaded.
  ///
  /// In en, this message translates to:
  /// **'Image Can Not Be Downloaded'**
  String get imageCanNotBeDownloaded;

  /// No description provided for @confirmDelete.
  ///
  /// In en, this message translates to:
  /// **'Confirm Delete'**
  String get confirmDelete;

  /// No description provided for @areYouSureYouWantToDeleteThisVisit.
  ///
  /// In en, this message translates to:
  /// **'Are You Sure You Want To Delete This Visit'**
  String get areYouSureYouWantToDeleteThisVisit;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @am.
  ///
  /// In en, this message translates to:
  /// **'am'**
  String get am;

  /// No description provided for @pm.
  ///
  /// In en, this message translates to:
  /// **'pm'**
  String get pm;

  /// No description provided for @clientDetails.
  ///
  /// In en, this message translates to:
  /// **'Client Details'**
  String get clientDetails;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @mainInformation.
  ///
  /// In en, this message translates to:
  /// **'Main Information'**
  String get mainInformation;

  /// No description provided for @visitName.
  ///
  /// In en, this message translates to:
  /// **'Visit Name'**
  String get visitName;

  /// No description provided for @communicationInformation.
  ///
  /// In en, this message translates to:
  /// **'Communication Information'**
  String get communicationInformation;

  /// No description provided for @clientVisits.
  ///
  /// In en, this message translates to:
  /// **'Client Visits'**
  String get clientVisits;

  /// No description provided for @thereIsNoVisits.
  ///
  /// In en, this message translates to:
  /// **'There Is No Visits'**
  String get thereIsNoVisits;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @doYouWantToPickYourCurrentLocation.
  ///
  /// In en, this message translates to:
  /// **'Do You Want To Pick Your Current Location'**
  String get doYouWantToPickYourCurrentLocation;

  /// No description provided for @locationPickedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Location Picked Successfully'**
  String get locationPickedSuccessfully;

  /// No description provided for @editClient.
  ///
  /// In en, this message translates to:
  /// **'Edit Client'**
  String get editClient;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @enterName.
  ///
  /// In en, this message translates to:
  /// **'Enter Name'**
  String get enterName;

  /// No description provided for @enterBusinessName.
  ///
  /// In en, this message translates to:
  /// **'Enter Business Name'**
  String get enterBusinessName;

  /// No description provided for @enterRegion.
  ///
  /// In en, this message translates to:
  /// **'Enter Region'**
  String get enterRegion;

  /// No description provided for @enterEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter Email'**
  String get enterEmail;

  /// No description provided for @enterPhone.
  ///
  /// In en, this message translates to:
  /// **'Enter Phone'**
  String get enterPhone;

  /// No description provided for @businessDetails.
  ///
  /// In en, this message translates to:
  /// **'Business Details'**
  String get businessDetails;

  /// No description provided for @visit.
  ///
  /// In en, this message translates to:
  /// **'Visit'**
  String get visit;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @clientAddedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Client Added Successfully'**
  String get clientAddedSuccessfully;

  /// No description provided for @pleasePickLocation.
  ///
  /// In en, this message translates to:
  /// **'Please Pick Location'**
  String get pleasePickLocation;

  /// No description provided for @visitAddedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Visit Added Successfully'**
  String get visitAddedSuccessfully;

  /// No description provided for @chooseClient.
  ///
  /// In en, this message translates to:
  /// **'Choose Client'**
  String get chooseClient;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @pleaseEnterAddress.
  ///
  /// In en, this message translates to:
  /// **'Please Enter Address'**
  String get pleaseEnterAddress;

  /// No description provided for @pleaseEnterVisitDetails.
  ///
  /// In en, this message translates to:
  /// **'please Enter Visit Details'**
  String get pleaseEnterVisitDetails;

  /// No description provided for @attachFile.
  ///
  /// In en, this message translates to:
  /// **'Attach File'**
  String get attachFile;

  /// No description provided for @pleaseChooseClient.
  ///
  /// In en, this message translates to:
  /// **'Please Choose Client'**
  String get pleaseChooseClient;

  /// No description provided for @areYouSureYouWantToDeleteThisClient.
  ///
  /// In en, this message translates to:
  /// **'Are You Sure You Want To Delete This Client'**
  String get areYouSureYouWantToDeleteThisClient;

  /// No description provided for @canNotReachToVisitsNow.
  ///
  /// In en, this message translates to:
  /// **'Can Not Reach To Visits Now'**
  String get canNotReachToVisitsNow;

  /// No description provided for @repSearch.
  ///
  /// In en, this message translates to:
  /// **'Representatives Search...'**
  String get repSearch;

  /// No description provided for @thereIsNoReps.
  ///
  /// In en, this message translates to:
  /// **'There Is No Reps'**
  String get thereIsNoReps;

  /// No description provided for @thereIsNoData.
  ///
  /// In en, this message translates to:
  /// **'There Is No Data'**
  String get thereIsNoData;

  /// No description provided for @repDetails.
  ///
  /// In en, this message translates to:
  /// **'Representative Details'**
  String get repDetails;

  /// No description provided for @repVisits.
  ///
  /// In en, this message translates to:
  /// **'Representative Visits'**
  String get repVisits;

  /// No description provided for @areYouSureYouWantToDeleteThisRep.
  ///
  /// In en, this message translates to:
  /// **'Are You Sure You Want To Delete This Representative'**
  String get areYouSureYouWantToDeleteThisRep;

  /// No description provided for @addRep.
  ///
  /// In en, this message translates to:
  /// **'Add Representative'**
  String get addRep;

  /// No description provided for @editRep.
  ///
  /// In en, this message translates to:
  /// **'Edit Representative'**
  String get editRep;

  /// No description provided for @repName.
  ///
  /// In en, this message translates to:
  /// **'Representative Name'**
  String get repName;

  /// No description provided for @enterCorrectEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter Correct Email'**
  String get enterCorrectEmail;

  /// No description provided for @thereIsNoVisitsForThisClient.
  ///
  /// In en, this message translates to:
  /// **'There Is No Visits For This Client'**
  String get thereIsNoVisitsForThisClient;

  /// No description provided for @deleteSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Delete Successfully'**
  String get deleteSuccessfully;

  /// No description provided for @requestCustomService.
  ///
  /// In en, this message translates to:
  /// **'Request Custom Service'**
  String get requestCustomService;

  /// No description provided for @sendRequest.
  ///
  /// In en, this message translates to:
  /// **'Send Request'**
  String get sendRequest;

  /// No description provided for @thisFieldIsRequired.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get thisFieldIsRequired;

  /// No description provided for @writeYourAnswerHere.
  ///
  /// In en, this message translates to:
  /// **'Write your answer here...'**
  String get writeYourAnswerHere;

  /// No description provided for @projectDetails.
  ///
  /// In en, this message translates to:
  /// **'Project Details'**
  String get projectDetails;

  /// No description provided for @serviceMustBeSelected.
  ///
  /// In en, this message translates to:
  /// **'You must select a service'**
  String get serviceMustBeSelected;

  /// No description provided for @selectService.
  ///
  /// In en, this message translates to:
  /// **'Select Service'**
  String get selectService;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @basicInformation.
  ///
  /// In en, this message translates to:
  /// **'Basic Information'**
  String get basicInformation;

  /// No description provided for @serviceRequestDetails.
  ///
  /// In en, this message translates to:
  /// **'Service Request Details'**
  String get serviceRequestDetails;

  /// No description provided for @launchYourIdeaNow.
  ///
  /// In en, this message translates to:
  /// **'Launch your idea now!'**
  String get launchYourIdeaNow;

  /// No description provided for @requestYourTechService.
  ///
  /// In en, this message translates to:
  /// **'Request your tech service: app, website, or full system…'**
  String get requestYourTechService;

  /// No description provided for @executeYourProject.
  ///
  /// In en, this message translates to:
  /// **'Execute your project professionally and in the fastest time.'**
  String get executeYourProject;

  /// No description provided for @orderNow.
  ///
  /// In en, this message translates to:
  /// **'Order Now'**
  String get orderNow;

  /// No description provided for @projectIdeaQuestion.
  ///
  /// In en, this message translates to:
  /// **'What is the general idea of the project and the problem it solves?'**
  String get projectIdeaQuestion;

  /// No description provided for @requiredPlatformsQuestion.
  ///
  /// In en, this message translates to:
  /// **'Which platforms are required (Android, iOS, Web)?'**
  String get requiredPlatformsQuestion;

  /// No description provided for @mainFeaturesQuestion.
  ///
  /// In en, this message translates to:
  /// **'What are the main key features (e.g., payments, maps, chat)?'**
  String get mainFeaturesQuestion;

  /// No description provided for @uiuxDesignQuestion.
  ///
  /// In en, this message translates to:
  /// **'Do you have a ready UI/UX design, or do you want it included in the service?'**
  String get uiuxDesignQuestion;

  /// No description provided for @similarAppQuestion.
  ///
  /// In en, this message translates to:
  /// **'Is there an existing app or website you want us to review?'**
  String get similarAppQuestion;

  /// No description provided for @budgetAndTimelineQuestion.
  ///
  /// In en, this message translates to:
  /// **'What is the expected budget and execution timeline?'**
  String get budgetAndTimelineQuestion;

  /// No description provided for @questionShort.
  ///
  /// In en, this message translates to:
  /// **'Q'**
  String get questionShort;

  /// No description provided for @answerShort.
  ///
  /// In en, this message translates to:
  /// **'A'**
  String get answerShort;

  /// No description provided for @order.
  ///
  /// In en, this message translates to:
  /// **'Order'**
  String get order;

  /// No description provided for @requestSentSuccess.
  ///
  /// In en, this message translates to:
  /// **'Your request has been sent successfully.\nWe will contact you soon.'**
  String get requestSentSuccess;

  /// No description provided for @messageSendFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to send the message\nYou can contact support'**
  String get messageSendFailed;

  /// No description provided for @serverUnderMaintenanceMessage.
  ///
  /// In en, this message translates to:
  /// **'We are currently performing some server updates to improve the service.\nPlease try again later.'**
  String get serverUnderMaintenanceMessage;

  /// No description provided for @enterServiceNow.
  ///
  /// In en, this message translates to:
  /// **'Enter Service Now'**
  String get enterServiceNow;
}

class _SDelegate extends LocalizationsDelegate<S> {
  const _SDelegate();

  @override
  Future<S> load(Locale locale) {
    return SynchronousFuture<S>(lookupS(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_SDelegate old) => false;
}

S lookupS(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return SAr();
    case 'en':
      return SEn();
  }

  throw FlutterError(
    'S.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
