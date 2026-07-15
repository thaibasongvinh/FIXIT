const sdk = require('node-appwrite');

/**
 * Appwrite Function: reset-password-admin
 * This function allows resetting a user's password using Admin privileges.
 * It expects a JSON body with 'email' and 'newPassword'.
 */
module.exports = async (context) => {
  const { req, res, log, error } = context;

  // 1. Parse and validate payload
  let payload;
  try {
    payload = typeof req.body === 'string' ? JSON.parse(req.body) : req.body;
  } catch (err) {
    error('Failed to parse request body: ' + err.message);
    return res.json({ success: false, message: 'Invalid JSON body.' });
  }

  if (!payload || !payload.email || !payload.newPassword) {
    error('Missing required fields: email or newPassword');
    return res.json({
      success: false,
      message: 'Email and newPassword are required.'
    });
  }

  const { email, newPassword } = payload;

  // 2. Initialize SDK
  // Use environment variables provided by Appwrite, with fallbacks if necessary
  const endpoint = process.env.APPWRITE_FUNCTION_ENDPOINT || 'https://sgp.cloud.appwrite.io/v1';
  const projectId = process.env.APPWRITE_FUNCTION_PROJECT_ID || '6a145b8d001aa82f4dd5';
  const apiKey = process.env.APPWRITE_API_KEY;

  log(`Endpoint: ${endpoint}, Project: ${projectId}`);

  const client = new sdk.Client()
    .setEndpoint(endpoint)
    .setProject(projectId)
    .setKey(apiKey);

  const users = new sdk.Users(client);

  try {
    log(`Attempting to reset password for: ${email}`);

    // 3. Find user by email
    log(`Searching for user with email: ${email}`);
    const userList = await users.list([
      sdk.Query.equal('email', email)
    ]);

    if (userList.total === 0 || userList.users.length === 0) {
      log(`User not found: ${email}`);
      return res.json({
        success: false,
        message: 'Không tìm thấy tài khoản với email này.'
      });
    }

    const userId = userList.users[0].$id;

    // Security check: If executed by a user, ensure they are changing their own password
    const executorId = req.headers['x-appwrite-user-id'];
    log(`Executor ID: ${executorId}, Target User ID: ${userId}`);

    if (executorId && executorId !== userId) {
      log(`Security Alert: User ${executorId} tried to reset password for ${email} (${userId})`);
      return res.json({
        success: false,
        message: 'Bạn không có quyền thay đổi mật khẩu cho tài khoản này.'
      });
    }

    log(`Updating password for user ID: ${userId}...`);

    // 4. Update password
    // Note: This requires the API Key to have 'users.write' permission
    await users.updatePassword(userId, newPassword);

    log(`Successfully updated password for ${email}`);
    return res.json({
      success: true,
      message: 'Mật khẩu đã được cập nhật thành công.'
    });

  } catch (err) {
    error(`Error resetting password for ${email}: ${err.message}`);

    // Provide a more user-friendly error message if it's a known error
    let friendlyMessage = err.message;
    if (err.message.includes('password') && err.message.includes('characters')) {
      friendlyMessage = 'Mật khẩu phải có ít nhất 8 ký tự.';
    } else if (err.code === 401) {
      friendlyMessage = 'Lỗi xác thực: Vui lòng kiểm tra API Key của Function.';
    }

    return res.json({
      success: false,
      message: friendlyMessage
    });
  }
};
