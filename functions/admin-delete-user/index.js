const https = require('https');

module.exports = async function (context) {
    const endpoint = 'https://sgp.cloud.appwrite.io/v1';
    const projectId = process.env.APPWRITE_FUNCTION_PROJECT_ID;
    const apiKey = process.env.APPWRITE_API_KEY;

    let payload;
    try {
        payload = typeof context.req.body === 'string' ? JSON.parse(context.req.body) : context.req.body;
    } catch (e) {
        payload = {};
    }

    const email = payload.email; // Sử dụng email thay vì userId
    if (!email) {
        return context.res.json({ status: 'error', message: 'Missing email' }, 400);
    }

    context.log(`🚀 DELETION REQUEST FOR EMAIL: ${email}`);

    const headers = {
        'Content-Type': 'application/json',
        'X-Appwrite-Project': projectId,
        'X-Appwrite-Key': apiKey
    };

    // BƯỚC 1: TÌM USER ID DỰA TRÊN EMAIL
    const findUser = () => new Promise((resolve) => {
        // Query tìm kiếm theo email
        const url = `${endpoint}/users?search=${encodeURIComponent(email)}`;
        const req = https.get(url, { headers }, (res) => {
            let data = '';
            res.on('data', (chunk) => data += chunk);
            res.on('end', () => {
                try {
                    const result = JSON.parse(data);
                    if (result.users && result.users.length > 0) {
                        // Trả về ID của user đầu tiên khớp email
                        resolve(result.users[0].$id);
                    } else {
                        resolve(null);
                    }
                } catch (e) {
                    resolve(null);
                }
            });
        });
        req.on('error', () => resolve(null));
    });

    // BƯỚC 2: XÓA USER THEO ID ĐÃ TÌM ĐƯỢC
    const deleteUser = (id) => new Promise((resolve) => {
        const url = `${endpoint}/users/${id}`;
        const req = https.request(url, { method: 'DELETE', headers }, (res) => {
            res.on('data', () => {});
            res.on('end', () => resolve(res.statusCode));
        });
        req.on('error', () => resolve(500));
        req.end();
    });

    try {
        const userId = await findUser();

        if (!userId) {
            context.log(`⚠️ User with email ${email} not found in Auth.`);
            return context.res.json({ status: 'success', message: 'User not found in Auth, but proceeding.' });
        }

        context.log(`🎯 Found User ID: ${userId}. Deleting...`);
        const statusCode = await deleteUser(userId);

        if (statusCode === 204 || statusCode === 404) {
            context.log(`✅ Successfully deleted user with email: ${email}`);
            return context.res.json({ status: 'success', message: 'User deleted' });
        } else {
            return context.res.json({ status: 'error', message: `Failed to delete. Code: ${statusCode}` }, statusCode);
        }
    } catch (e) {
        return context.res.json({ status: 'error', message: e.message }, 500);
    }
};
