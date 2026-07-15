// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get appName => 'FixIt';

  @override
  String get welcome => 'Chào mừng đến với FixIt';

  @override
  String get login => 'Đăng nhập';

  @override
  String get register => 'Đăng ký';

  @override
  String get email => 'Email';

  @override
  String get password => 'Mật khẩu';

  @override
  String get myProfile => 'Hồ sơ của tôi';

  @override
  String get editProfile => 'Chỉnh sửa hồ sơ';

  @override
  String get logout => 'Đăng xuất';

  @override
  String get notifications => 'Thông báo';

  @override
  String get bookings => 'Lịch hẹn của tôi';

  @override
  String get wallet => 'Ví của tôi';

  @override
  String get helpSupport => 'Hỗ trợ & Trợ giúp';

  @override
  String get signIn => 'Đăng nhập';

  @override
  String get forgotPasswordQuery => 'Quên mật khẩu?';

  @override
  String get newToFixit => 'Chưa có tài khoản?';

  @override
  String get adminPanel => 'QUẢN TRỊ VIÊN';

  @override
  String get commandCenter => 'Trung tâm điều hành';

  @override
  String helloAdmin(String name) {
    return 'Xin chào, $name';
  }

  @override
  String get revenue => 'DOANH THU';

  @override
  String get activeJobs => 'VIỆC ĐANG CHẠY';

  @override
  String get newUsers => 'NGƯỜI DÙNG MỚI';

  @override
  String get pendingApps => 'HỒ SƠ CHỜ DUYỆT';

  @override
  String get revenueTrend => 'XU HƯỚNG DOANH THU (7 NGÀY)';

  @override
  String get jobDistribution => 'PHÂN BỔ CÔNG VIỆC';

  @override
  String get quickOperations => 'THAO TÁC NHANH';

  @override
  String get recentApplications => 'HỒ SƠ GẦN ĐÂY';

  @override
  String get approvals => 'Phê duyệt';

  @override
  String get users => 'Người dùng';

  @override
  String get jobs => 'Công việc';

  @override
  String get services => 'Dịch vụ';

  @override
  String get noJobData => 'Không có dữ liệu công việc';

  @override
  String get noPendingApps => 'Không có hồ sơ chờ duyệt';

  @override
  String get banners => 'Băng rôn';

  @override
  String get config => 'Cấu hình';

  @override
  String get broadcast => 'Phát thông báo';

  @override
  String get products => 'Sản phẩm';

  @override
  String get ledger => 'Sổ cái';

  @override
  String get feedback => 'Phản hồi';

  @override
  String get coupons => 'Mã giảm giá';

  @override
  String get liveMap => 'Bản đồ thợ';

  @override
  String get reports => 'Báo cáo';

  @override
  String get staff => 'Nhân sự';

  @override
  String get auditLogs => 'Nhật ký hệ thống';

  @override
  String get bcHistory => 'Lịch sử thông báo';

  @override
  String get partsInventory => 'Kho linh kiện';

  @override
  String get preferences => 'TÙY CHỈNH';

  @override
  String get themeMode => 'Giao diện';

  @override
  String get language => 'Ngôn ngữ';

  @override
  String get system => 'HỆ THỐNG';

  @override
  String get appInfo => 'Thông tin ứng dụng';

  @override
  String get debugLogs => 'Logs hệ thống';

  @override
  String get securityLevel => 'Mức độ bảo mật';

  @override
  String get selectTheme => 'CHỌN GIAO DIỆN';

  @override
  String get selectLanguage => 'CHỌN NGÔN NGỮ';

  @override
  String get home => 'Trang chủ';

  @override
  String get city => 'Thành phố';

  @override
  String get order => 'Đơn hàng';

  @override
  String get profile => 'Hồ sơ';

  @override
  String get logoutConfirmTitle => 'ĐĂNG XUẤT';

  @override
  String get logoutConfirmMessage =>
      'Bạn có chắc chắn muốn kết thúc phiên làm việc này không?';

  @override
  String get logoutButton => 'ĐĂNG XUẤT NGAY';

  @override
  String get cancelButton => 'Ở lại';

  @override
  String get userManagement => 'QUẢN LÝ NGƯỜI DÙNG';

  @override
  String get searchUserHint => 'Tìm kiếm theo tên hoặc email...';

  @override
  String get all => 'Tất cả';

  @override
  String get admins => 'Quản trị viên';

  @override
  String get technicians => 'Thợ sửa chữa';

  @override
  String get customers => 'Khách hàng';

  @override
  String get deleteAccountQuery => 'XÓA TÀI KHOẢN?';

  @override
  String deleteAccountDesc(String name) {
    return 'Bạn có chắc chắn muốn xóa vĩnh viễn tài khoản của $name? Hành động này không thể hoàn tác.';
  }

  @override
  String get deleteNow => 'XÓA NGAY';

  @override
  String get deactivateUserQuery => 'VÔ HIỆU HÓA NGƯỜI DÙNG?';

  @override
  String get activateUserQuery => 'KÍCH HOẠT NGƯỜI DÙNG?';

  @override
  String get deactivateDesc =>
      'Người dùng này sẽ không thể truy cập ứng dụng cho đến khi bạn bật lại.';

  @override
  String get activateDesc =>
      'Người dùng này sẽ có quyền truy cập đầy đủ vào các dịch vụ ứng dụng.';

  @override
  String get cancel => 'Hủy';

  @override
  String get noUsersFound => 'Không tìm thấy người dùng';

  @override
  String get serviceCatalog => 'DANH MỤC DỊCH VỤ';

  @override
  String get searchServicesHint => 'Tìm kiếm dịch vụ...';

  @override
  String get popular => 'Phổ biến';

  @override
  String get regular => 'Các dịch vụ';

  @override
  String get addService => 'Thêm dịch vụ';

  @override
  String get editService => 'Sửa dịch vụ';

  @override
  String get saveChanges => 'LƯU THAY ĐỔI';

  @override
  String get createService => 'TẠO DỊCH VỤ';

  @override
  String get deleteServiceQuery => 'XÓA DỊCH VỤ?';

  @override
  String deleteServiceDesc(String title) {
    return 'Bạn có chắc chắn muốn xóa vĩnh viễn \"$title\"? Hành động này sẽ xóa TẤT CẢ các vấn đề, hướng dẫn và các bước liên quan.';
  }

  @override
  String get deleteEverything => 'XÓA TẤT CẢ';

  @override
  String get identityVerification => 'Xác minh danh tính';

  @override
  String get serviceOffer => 'Dịch vụ cung cấp';

  @override
  String get workingHours => 'Giờ làm việc';

  @override
  String get aboutMe => 'Giới thiệu bản thân';

  @override
  String get next => 'Tiếp theo';

  @override
  String get submit => 'Gửi hồ sơ';

  @override
  String get finish => 'Hoàn tất';

  @override
  String get currentBalance => 'Số dư hiện tại';

  @override
  String get totalEarned => 'Tổng thu nhập';

  @override
  String get transactionHistory => 'Lịch sử giao dịch';

  @override
  String get deposit => 'Nạp tiền';

  @override
  String get withdraw => 'Rút tiền';

  @override
  String get typeMessage => 'Nhập tin nhắn...';

  @override
  String get calling => 'Đang gọi...';

  @override
  String get incomingCall => 'Cuộc gọi đến...';

  @override
  String get mute => 'Tắt tiếng';

  @override
  String get speaker => 'Loa ngoài';

  @override
  String get noNotifications => 'Chưa có thông báo nào';

  @override
  String get markAllAsRead => 'Đánh dấu tất cả đã đọc';

  @override
  String get idNumber => 'Số CMND/CCCD';

  @override
  String get bankName => 'Tên ngân hàng';

  @override
  String get accountNumber => 'Số tài khoản';

  @override
  String get accountHolder => 'Tên chủ tài khoản';

  @override
  String get hourlyRate => 'Giá theo giờ';

  @override
  String get applicationReceived => 'Đã nhận hồ sơ';

  @override
  String get applicationReceivedDesc =>
      'Hồ sơ của bạn đã được gửi đến quản trị viên. Chúng tôi sẽ liên hệ với bạn sớm nhất có thể!';

  @override
  String get rating => 'Đánh giá';

  @override
  String get orders => 'Đơn hàng';

  @override
  String get experience => 'Kinh nghiệm';

  @override
  String get skills => 'Kỹ năng';

  @override
  String get bio => 'Tiểu sử';

  @override
  String get reviews => 'Đánh giá từ khách';

  @override
  String get bookService => 'Đặt dịch vụ ngay';

  @override
  String get years => 'năm';

  @override
  String get noReviews => 'Chưa có đánh giá nào.';

  @override
  String get testKey => 'Kiểm tra';

  @override
  String get systemMode => 'HỆ THỐNG';

  @override
  String get lightMode => 'CHẾ ĐỘ SÁNG';

  @override
  String get darkMode => 'CHẾ ĐỘ TỐI';

  @override
  String get vietnamese => 'TIẾNG VIỆT';

  @override
  String get english => 'TIẾNG ANH';

  @override
  String get support => 'HỖ TRỢ';

  @override
  String get helpCenter => 'Trung tâm hỗ trợ';

  @override
  String get termsConditions => 'Điều khoản & Điều kiện';

  @override
  String get status => 'Trạng thái';

  @override
  String get secure => 'An toàn';

  @override
  String get technician => 'KỸ THUẬT VIÊN';

  @override
  String get customer => 'KHÁCH HÀNG';

  @override
  String get premiumPlatform => 'Nền tảng dịch vụ cao cấp v1.0';

  @override
  String get fixitUser => 'Người dùng FixIt';

  @override
  String get professionalTechnicians => 'THỢ CHUYÊN NGHIỆP';

  @override
  String helloUser(String name) {
    return 'XIN CHÀO, $name';
  }

  @override
  String get todayJobs => 'Hôm nay bạn có những công việc sau';

  @override
  String get todayEarnings => 'Thu nhập hôm nay';

  @override
  String get completedOrders => 'Đơn hoàn thành';

  @override
  String get acceptanceRate => 'Tỉ lệ nhận đơn';

  @override
  String get service => 'DỊCH VỤ';

  @override
  String get technicianSmall => 'THỢ';

  @override
  String get noResultsFound => 'Không tìm thấy kết quả';

  @override
  String get providerList => 'DANH SÁCH THỢ';

  @override
  String get viewAll => 'XEM TẤT CẢ';

  @override
  String get view => 'XEM';

  @override
  String get exportReport => 'Xuất báo cáo tài chính';

  @override
  String get focusModerator =>
      'Trọng tâm: Kiểm duyệt nội dung, Dịch vụ & Phản hồi';

  @override
  String get focusFinance =>
      'Trọng tâm: Quản lý Tài chính, Doanh thu & Coupons';

  @override
  String get focusSupport =>
      'Trọng tâm: Hỗ trợ Khách hàng, Đơn hàng & Vận hành';

  @override
  String applicationCount(Object type) {
    return 'Hồ sơ $type';
  }

  @override
  String error(Object message) {
    return 'Lỗi: $message';
  }

  @override
  String get account => 'TÀI KHOẢN';

  @override
  String get interface => 'Giao diện';

  @override
  String get specialty => 'Chuyên môn';

  @override
  String get verification => 'Xác minh';

  @override
  String get subscriptionAndPayment => 'GÓI CƯỚC & THANH TOÁN';

  @override
  String get upgradeAccount => 'Nâng cấp tài khoản';

  @override
  String get generalPreferences => 'TÙY CHỈNH CHUNG';

  @override
  String get profileInfo => 'THÔNG TIN HỒ SƠ';

  @override
  String get walletAndPayment => 'Ví & Thanh toán';

  @override
  String get loggingOut => 'Đang đăng xuất...';

  @override
  String get changeProfileToSelling => 'Chuyển sang chế độ thợ';

  @override
  String get changeProfileToBuying => 'Chuyển sang chế độ khách';

  @override
  String get wantToManageRepairs => 'Bạn muốn quản lý công việc sửa chữa?';

  @override
  String get tryAgain => 'Thử lại';

  @override
  String get serviceName => 'TÊN DỊCH VỤ';

  @override
  String get enterServiceName => 'Nhập tên dịch vụ';

  @override
  String get imageIdAsset => 'ID ẢNH / ASSET';

  @override
  String get enterIdOrAsset => 'Nhập ID hoặc tên Asset';

  @override
  String get brandColorHex => 'MÀU THƯƠNG HIỆU (HEX)';

  @override
  String get popularServiceQuestion => 'Dịch vụ phổ biến?';

  @override
  String get featuredOnHome => 'Hiển thị trên trang chủ';

  @override
  String get parentServiceRequired => 'DỊCH VỤ CHA (BẮT BUỘC)';

  @override
  String get noPopularServices => 'Không có dịch vụ phổ biến';

  @override
  String get selectParentCategory => 'Chọn một danh mục cha';

  @override
  String get livePreview => 'XEM TRƯỚC TRỰC TIẾP';

  @override
  String get noSubServicesFound => 'Không tìm thấy dịch vụ con';

  @override
  String get serviceUpdated => 'Cập nhật dịch vụ thành công';

  @override
  String get serviceCreated => 'Tạo dịch vụ thành công';

  @override
  String get serviceDeleted => 'Xóa dịch vụ thành công';

  @override
  String get enterIdOrAssetName => 'Nhập ID hoặc tên Asset';

  @override
  String get onboardingTitle1 => 'Chào mừng đến với\nFixIt Pro';

  @override
  String get onboardingDesc1 =>
      'Trải nghiệm dịch vụ gia đình thế hệ mới ngay trong tầm tay bạn.';

  @override
  String get onboardingTitle2 => 'Kỹ thuật viên\nChuyên nghiệp';

  @override
  String get onboardingDesc2 =>
      'Chỉ những chuyên gia được chứng nhận mới xử lý thiết bị quý giá của bạn.';

  @override
  String get onboardingTitle3 => 'Thanh toán\nAn toàn & Nhanh chóng';

  @override
  String get onboardingDesc3 =>
      'Giá cả minh bạch với quy trình thanh toán và theo dõi tức thì.';

  @override
  String get getStarted => 'Bắt đầu ngay';

  @override
  String get skip => 'BỎ QUA';

  @override
  String get launchApp => 'Mở ứng dụng';

  @override
  String get welcomeBack => 'Chào mừng quay lại!';

  @override
  String get loginSubtitle => 'Đăng nhập để tiếp tục hành trình';

  @override
  String get emailAddress => 'Địa chỉ Email';

  @override
  String get emailHint => 'tenban@email.com';

  @override
  String get passwordHint => '••••••••';

  @override
  String get enterEmail => 'Nhập email của bạn';

  @override
  String get min6Chars => 'Tối thiểu 6 ký tự';

  @override
  String get dontHaveAccount => 'Chưa có tài khoản? ';

  @override
  String get signUp => 'Đăng ký';

  @override
  String get orLogInWith => 'HOẶC ĐĂNG NHẬP VỚI';

  @override
  String get createAccount => 'Tạo tài khoản';

  @override
  String get joinFuture => 'Tham gia tương lai của dịch vụ gia đình';

  @override
  String get fullName => 'Họ và tên';

  @override
  String get fullNameHint => 'Nguyễn Văn A';

  @override
  String get enterName => 'Nhập tên của bạn';

  @override
  String get agreeTo => 'Tôi đồng ý với ';

  @override
  String get pleaseAgree => 'Vui lòng đồng ý với Điều khoản & Điều kiện';

  @override
  String get alreadyHaveAccount => 'Đã có tài khoản? ';

  @override
  String get orRegisterWith => 'HOẶC ĐĂNG KÝ VỚI';

  @override
  String get errorInvalidCredentials => 'Email hoặc mật khẩu không chính xác.';

  @override
  String get errorNetwork => 'Lỗi kết nối mạng.';

  @override
  String get errorEmailAlreadyExists => 'Email này đã được đăng ký.';

  @override
  String get errorUnknown => 'Đã xảy ra lỗi không mong muốn. Vui lòng thử lại.';

  @override
  String get emailVerification => 'Email Verification';

  @override
  String get enterEmailToReceiveOTP =>
      'Nhập địa chỉ email của bạn để nhận mã OTP';

  @override
  String get phoneVerification => 'Xác thực điện thoại';

  @override
  String get enterPhoneToReceiveOTP =>
      'Nhập số điện thoại của bạn để nhận mã OTP';

  @override
  String get sendCode => 'GỬI MÃ';

  @override
  String get accountNotRegistered => 'Tài khoản này chưa được đăng ký.';

  @override
  String get verificationCodeSent =>
      'Mã xác minh đã được gửi đến email của bạn.';

  @override
  String get tooManyRequests =>
      'Bạn đã thực hiện quá nhiều yêu cầu. Vui lòng đợi ít phút rồi thử lại.';

  @override
  String waitSeconds(int seconds) {
    return 'ĐỢI ${seconds}S';
  }

  @override
  String get chooseResetMethod => 'Chọn cách bạn muốn đặt lại mật khẩu';

  @override
  String get emailMethodSubtitle => 'Gửi liên kết đến hộp thư của bạn';

  @override
  String get mobileNumber => 'Số điện thoại';

  @override
  String get phoneMethodSubtitle => 'Gửi mã OTP đến điện thoại của bạn';

  @override
  String get otpVerification => 'Xác thực OTP';

  @override
  String get enterCodeSentTo => 'Nhập mã gồm 6 chữ số đã được gửi đến';

  @override
  String get verify => 'XÁC MINH';

  @override
  String get didntReceiveCode => 'Không nhận được mã?';

  @override
  String get resendCode => 'GỬI LẠI MÃ';

  @override
  String resendIn(int seconds) {
    return 'GỬI LẠI SAU ${seconds}s';
  }

  @override
  String get verificationCodeSentSmall => 'Mã xác minh đã được gửi.';

  @override
  String get codeResentSuccess => 'Mã đã được gửi lại thành công.';

  @override
  String get failedToSendCode => 'Gửi mã thất bại.';

  @override
  String get enterAllDigits => 'Vui lòng nhập đủ 6 chữ số';

  @override
  String get verificationSuccessful => 'Xác thực thành công!';

  @override
  String get invalidOTP => 'Mã OTP không chính xác. Vui lòng kiểm tra lại.';

  @override
  String get yourEmail => 'email của bạn';

  @override
  String get yourPhone => 'số điện thoại của bạn';

  @override
  String get settingNewPassword => 'Đang thiết lập mật khẩu mới...';

  @override
  String get success => 'Thành Công!';

  @override
  String get passwordUpdatedSuccess =>
      'Mật khẩu của bạn đã được cập nhật thành công. Vui lòng đăng nhập lại bằng mật khẩu mới.';

  @override
  String get backToLogin => 'QUAY LẠI ĐĂNG NHẬP';

  @override
  String get otpInvalidOrExpired =>
      'Mã OTP không hợp lệ hoặc đã hết hạn. Vui lòng thực hiện lại từ đầu.';

  @override
  String get newPassword => 'Mật khẩu mới';

  @override
  String get confirmPassword => 'Xác nhận mật khẩu';

  @override
  String get createStrongPassword =>
      'Vui lòng tạo mật khẩu mới mạnh mẽ cho tài khoản của bạn';

  @override
  String get passwordMin8 => 'Mật khẩu phải có ít nhất 8 ký tự';

  @override
  String get passwordsDoNotMatch => 'Mật khẩu không khớp';

  @override
  String get savePassword => 'LƯU MẬT KHẨU';

  @override
  String get enterPinSentToPhone =>
      'Nhập mã PIN 6 chữ số đã được gửi đến số điện thoại của bạn';

  @override
  String get stillNotReceiveCode => 'Vẫn chưa nhận được mã? ';

  @override
  String get sendAgain => 'Gửi lại';

  @override
  String sendAgainIn(int seconds) {
    return 'Gửi lại sau (${seconds}s)';
  }

  @override
  String get verificationSuccess => 'Xác thực thành công!';

  @override
  String get setupSuccessLoginAgain =>
      'Thiết lập thành công. Vui lòng đăng nhập lại.';

  @override
  String get iAm => 'Tôi là...';

  @override
  String get selectRoleToStart => 'Chọn vai trò của bạn để bắt đầu';

  @override
  String get techRoleDesc => 'Tôi cung cấp các dịch vụ sửa chữa chuyên nghiệp.';

  @override
  String get customerRoleDesc =>
      'Tôi đang tìm kiếm thợ sửa chữa cho ngôi nhà của mình.';

  @override
  String get accountSetupSuccess => 'Thiết lập tài khoản thành công!';

  @override
  String get startNow => 'BẮT ĐẦU NGAY';

  @override
  String get techOnboardingTitle => 'Thiết lập hồ sơ thợ';

  @override
  String get enableLocationDesc =>
      'Bật định vị để tìm kiếm khách hàng gần bạn nhất';

  @override
  String get fastConnection => 'KẾT NỐI NHANH CHÓNG';

  @override
  String get autoSearchRange => 'Tự động tìm kiếm trong phạm vi của bạn';

  @override
  String get allowMapAccess => 'Cho phép truy cập bản đồ';

  @override
  String get maybeLater => 'Để sau';

  @override
  String get locationPermissionBlocked => 'Quyền vị trí bị chặn';

  @override
  String get locationPermissionBlockedDesc =>
      'Bạn đã từ chối quyền vị trí vĩnh viễn. Để tìm khách hàng gần nhất, vui lòng vào Cài đặt để bật lại.';

  @override
  String get openSettings => 'Mở Cài đặt';

  @override
  String get gpsOff => 'GPS đang tắt. Vui lòng bật vị trí để tiếp tục.';

  @override
  String get needLocationPermission => 'Bạn cần cấp quyền vị trí để tiếp tục.';

  @override
  String get locationCanBeAddedLater =>
      'Bạn có thể bổ sung vị trí sau trong phần Cài đặt để nhận việc.';

  @override
  String get whatIsYourSpecialty => 'Bạn chuyên về lĩnh vực nào?';

  @override
  String get aboutMeHint => 'Mô tả kinh nghiệm của bạn...';

  @override
  String get workingHoursAndRange => 'Giờ làm việc & Phạm vi';

  @override
  String get from => 'Từ';

  @override
  String get to => 'Đến';

  @override
  String get serviceRadius => 'Bán kính phục vụ';

  @override
  String get serviceArea => 'Khu vực phục vụ';

  @override
  String get noAreaSelected => 'Chưa có khu vực nào được chọn';

  @override
  String get tapToAddArea => 'Nhấn để thêm khu vực phục vụ';

  @override
  String get addMoreArea => 'Thêm khu vực khác';

  @override
  String get selectCity => 'Chọn Tỉnh / Thành phố';

  @override
  String get selectDistrict => 'Chọn Quận / Huyện';

  @override
  String get selectWard => 'Chọn Phường / Xã';

  @override
  String get idNumberHint => 'Nhập số CCCD (12 chữ số)';

  @override
  String get frontIdCard => 'Ảnh mặt trước CCCD';

  @override
  String get backIdCard => 'Ảnh mặt sau CCCD';

  @override
  String get tapToUpload => 'Nhấn để tải ảnh lên';

  @override
  String scanningId(String label) {
    return 'Đang quét $label...';
  }

  @override
  String get aiVerifying => 'Hệ thống AI đang xác thực nội dung thẻ...';

  @override
  String get invalidIdFormat =>
      'Không nhận diện được định dạng CCCD. Vui lòng chụp đúng mặt thẻ.';

  @override
  String frontBackMismatch(String side1, String side2) {
    return 'Bạn đang nộp $side1 vào ô $side2. Vui lòng chụp lại.';
  }

  @override
  String validIdConfirmed(String label) {
    return 'Đã xác nhận $label hợp lệ.';
  }

  @override
  String get toolsAndEquipment => 'Dụng cụ & Máy móc';

  @override
  String get addToolSet => 'Thêm bộ dụng cụ sửa chữa';

  @override
  String get toolSetDesc =>
      'Ảnh thực tế các thiết bị bạn đang dùng để sửa chữa';

  @override
  String get professionalCert => 'Chứng nhận tay nghề (nếu có)';

  @override
  String get certDesc => 'Bằng nghề, chứng chỉ hoặc giấy khen chuyên môn';

  @override
  String get paymentMethod => 'Phương thức thanh toán';

  @override
  String get bankTransfer => 'Chuyển khoản ngân hàng';

  @override
  String get momoZalo => 'Ví MoMo / ZaloPay';

  @override
  String get cash => 'Tiền mặt';

  @override
  String get accountInfo => 'Thông tin tài khoản';

  @override
  String get selectBank => 'Chọn Ngân hàng';

  @override
  String get accountNumberHint => 'Số tài khoản / Số điện thoại ví';

  @override
  String get verifyingInfo => 'Đang xác thực thông tin...';

  @override
  String get verifiedAccount => 'Đã xác thực tài khoản';

  @override
  String get retryVerification => 'Thử xác thực lại';

  @override
  String get industryType => 'Lĩnh vực & Kinh nghiệm';

  @override
  String get billingDetails => 'Thông tin thanh toán';

  @override
  String get vdElectrician => 'VD: Thợ điện...';

  @override
  String get enterSpecialty => 'Nhập chuyên môn chính của bạn';

  @override
  String get yearsExperience => 'Số năm kinh nghiệm';

  @override
  String get seniority => 'Thâm niên';

  @override
  String get hourlyRateHint => 'VD: 150,000';

  @override
  String get hourlyRateDesc => 'Mức phí dự kiến cho 1 giờ làm việc (VND)';

  @override
  String get businessAddressHint => 'Địa chỉ cửa hàng (không bắt buộc)';

  @override
  String get nearCustomersDesc => 'Giúp khách hàng ở gần tìm thấy bạn dễ hơn';

  @override
  String get workSchedule => 'Lịch làm việc';

  @override
  String get allWeek => 'Cả tuần (T2 - CN)';

  @override
  String get officeHours => 'Giờ hành chính';

  @override
  String get weekendsOnly => 'Chỉ cuối tuần';

  @override
  String get selectScheduleDesc => 'Chọn thời gian bạn có thể nhận việc';

  @override
  String get pleaseEnterRequiredFields =>
      'Vui lòng nhập đầy đủ các thông tin bắt buộc.';

  @override
  String get submittingApplication => 'ĐANG XỬ LÝ DỮ LIỆU';

  @override
  String get optimizingImages => 'Đang tối ưu hóa hình ảnh...';

  @override
  String get encryptingProfile => 'Hệ thống đang mã hóa hồ sơ của bạn...';

  @override
  String get applicationSentSuccess => 'Gửi hồ sơ thành công!';

  @override
  String get applicationSentDesc =>
      'Hồ sơ của bạn đã được gửi đi. Vui lòng chờ hệ thống phê duyệt trong vòng 24h tới.';

  @override
  String get pendingApprovalTitle => 'ĐANG XÉT DUYỆT';

  @override
  String get pendingApprovalDesc =>
      'Hệ thống đang xác thực thông tin chuyên môn của bạn. Quy trình này thường mất từ 2-24 giờ.';

  @override
  String get approved => 'ĐÃ ĐƯỢC DUYỆT';

  @override
  String get approvedDesc =>
      'Chúc mừng! Hồ sơ của bạn đã được thông qua. Đang chuẩn bị vào trang chủ...';

  @override
  String get rejected => 'TỪ CHỐI';

  @override
  String get rejectedDesc =>
      'Rất tiếc, hồ sơ của bạn chưa phù hợp. Vui lòng kiểm tra lại thông tin hoặc liên hệ hỗ trợ.';

  @override
  String get applicationStatus => 'TRẠNG THÁI HỒ SƠ';

  @override
  String get waitingForApproval => 'Đang chờ phê duyệt';

  @override
  String get logoutAccount => 'ĐĂNG XUẤT TÀI KHOẢN';

  @override
  String get commonIssues => 'Vấn đề thường gặp';

  @override
  String get tapToSeeGuide =>
      'Nhấn vào một vấn đề để xem hướng dẫn sửa chữa và công cụ.';

  @override
  String get needAnExpert => 'Cần chuyên gia?';

  @override
  String get bookVerifiedPro => 'Đặt một chuyên gia uy tín để xử lý giúp bạn.';

  @override
  String get findTechnician => 'Tìm kỹ thuật viên';

  @override
  String get recommendedTools => 'Công cụ khuyên dùng';

  @override
  String get repairInstructions => 'Hướng dẫn sửa chữa';

  @override
  String get stillCantFixIt => 'Vẫn không sửa được?';

  @override
  String get techAtDoorDesc =>
      'Kỹ thuật viên của chúng tôi sẽ có mặt trong 30 phút.';

  @override
  String get bookAProfessional => 'Đặt chuyên gia';

  @override
  String get buy => 'Mua';

  @override
  String get expertSupport => 'Hỗ trợ Chuyên gia';

  @override
  String get allServices => 'Tất cả dịch vụ';

  @override
  String items(int count) {
    return '$count dịch vụ';
  }

  @override
  String reliableServices(String service) {
    return 'Dịch vụ\n$service Uy tín';
  }

  @override
  String get banner_quality_work_title => 'Dịch vụ Chất lượng';

  @override
  String get banner_quality_work_desc => 'Chuyên gia uy tín cho mọi việc';

  @override
  String get banner_fast_repair_title => 'Sửa chữa Nhanh';

  @override
  String get banner_fast_repair_desc =>
      'Kỹ thuật viên chuyên nghiệp đến tận nơi';

  @override
  String get svc_plumbers => 'Thợ ống nước';

  @override
  String get svc_electric_work => 'Điện dân dụng';

  @override
  String get svc_solars => 'Năng lượng mặt trời';

  @override
  String get svc_ac_ventilation => 'Máy lạnh & Thông gió';

  @override
  String get svc_car_washer => 'Rửa xe tại nhà';

  @override
  String get svc_laundry => 'Giặt ủi';

  @override
  String get svc_paintings => 'Sơn sửa';

  @override
  String get svc_floorings => 'Lát sàn';

  @override
  String get svc_cameras => 'Lắp đặt Camera';

  @override
  String get svc_locksmiths => 'Thợ khóa';

  @override
  String get svc_cleaning => 'Dịch vụ Vệ sinh';

  @override
  String get svc_security => 'Dịch vụ Bảo vệ';

  @override
  String get svc_mover => 'Dịch vụ Chuyển nhà';

  @override
  String get svc_carpenter => 'Dịch vụ Thợ mộc';

  @override
  String get sub_car_wash => 'Rửa xe';

  @override
  String get sub_car_waxing => 'Đánh bóng xe';

  @override
  String get sub_oil_change => 'Thay dầu nhớt';

  @override
  String get sub_car_battery => 'Ắc quy xe';

  @override
  String get sub_interior_cleaning => 'Vệ sinh nội thất';

  @override
  String get sub_tire_repair => 'Sửa lốp xe';

  @override
  String get sub_wiring_install => 'Lắp đặt dây điện';

  @override
  String get sub_electrical_repairs => 'Sửa chữa điện';

  @override
  String get sub_lighting_install => 'Lắp đặt đèn';

  @override
  String get sub_fixture_install => 'Lắp đặt thiết bị';

  @override
  String get sub_house_cleaning => 'Vệ sinh nhà ở';

  @override
  String get sub_office_cleaning => 'Vệ sinh văn phòng';

  @override
  String get sub_deep_cleaning => 'Vệ sinh chuyên sâu';

  @override
  String get sub_kitchen_cleaning => 'Vệ sinh bếp';

  @override
  String get sub_ac_repairing => 'Sửa máy lạnh';

  @override
  String get sub_ac_installation => 'Lắp đặt máy lạnh';

  @override
  String get sub_ac_uninstallation => 'Tháo máy lạnh';

  @override
  String get sub_ac_service => 'Bảo trì máy lạnh';

  @override
  String get sub_pipe_leakage => 'Rò rỉ ống nước';

  @override
  String get sub_tap_repair => 'Sửa vòi nước';

  @override
  String get sub_toilet_repair => 'Sửa bồn cầu';

  @override
  String get sub_drain_cleaning => 'Thông cống';

  @override
  String get sub_plumber => 'Thợ sửa ống nước';

  @override
  String get sub_pipe_wrench => 'Mỏ lết';

  @override
  String get sub_water_tap => 'Vòi nước';

  @override
  String get sub_plier => 'Kìm';

  @override
  String get sub_multimeter => 'Đồng hồ vạn năng';

  @override
  String get sub_electricity_meter => 'Công tơ điện';

  @override
  String get sub_drill => 'Máy khoan';

  @override
  String get sub_solar_panel => 'Tấm pin mặt trời';

  @override
  String get sub_cctv_install => 'Lắp đặt CCTV';

  @override
  String get sub_alarm_system => 'Hệ thống báo động';

  @override
  String get sub_lock_repair => 'Sửa khóa cửa';

  @override
  String get sub_biometric_access => 'Kiểm soát vân tay';

  @override
  String get sub_house_moving => 'Chuyển nhà';

  @override
  String get sub_office_moving => 'Chuyển văn phòng';

  @override
  String get sub_furniture_moving => 'Chuyển đồ đạc';

  @override
  String get sub_local_moving => 'Chuyển nội thành';

  @override
  String get sub_furniture_repair => 'Sửa đồ gỗ';

  @override
  String get sub_door_installation => 'Lắp đặt cửa';

  @override
  String get sub_cabinet_repair => 'Sửa tủ gỗ';

  @override
  String get sub_wood_polishing => 'Đánh bóng gỗ';

  @override
  String get sub_house_painting => 'Sơn nhà';

  @override
  String get sub_exterior_painting => 'Sơn ngoại thất';

  @override
  String get sub_interior_painting => 'Sơn nội thất';

  @override
  String get sub_wall_stenciling => 'Sơn trang trí';
}
