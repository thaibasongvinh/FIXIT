const https = require('https');

const CONFIG = {
    endpoint: 'sgp.cloud.appwrite.io',
    projectId: '6a145b8d001aa82f4dd5',
    databaseId: 'database-default',
    apiKey: 'standard_6de4d38760a772bd4006cc26d99353ed12f03e1e9f1a743be083627ec864bb7cb9e58478865c1b8823f1f3793dcde25baaeba78244b8a8e8a5530da6412db68a1c00d329da03c6d19f57718c4714d6950d3218a33d2db9ba5001f12cd6f83352314888399d0cd72648989495cc06535781e57585cf7fc28b830f4e2a194f495b',
};

function fetchAttributes(collectionId) {
    return new Promise((resolve, reject) => {
        const options = {
            hostname: CONFIG.endpoint,
            path: `/v1/databases/${CONFIG.databaseId}/collections/${collectionId}/attributes`,
            method: 'GET',
            headers: {
                'X-Appwrite-Project': CONFIG.projectId,
                'X-Appwrite-Key': CONFIG.apiKey
            }
        };

        const req = https.request(options, (res) => {
            let data = '';
            res.on('data', (chunk) => data += chunk);
            res.on('end', () => {
                if (res.statusCode === 200) {
                    resolve(JSON.parse(data));
                } else {
                    reject(new Error(`Status ${res.statusCode}: ${data}`));
                }
            });
        });

        req.on('error', (e) => reject(e));
        req.end();
    });
}

const COLLECTIONS = [
    'users', 'technicians', 'bookings', 'reviews', 'wallets',
    'transactions', 'payment_methods', 'services', 'popular_services',
    'banners', 'favorites', 'app_config', 'technician_applications',
    'service_issues', 'products', 'guides', 'guide_steps',
    'guide_bookmarks', 'guide_ratings', 'chat_rooms', 'chat_messages',
    'user_settings', 'address_book', 'notifications', 'calls', 'coupons', 'audit_logs'
];

async function runAudit() {
    console.log('🔍 [COLUMN AUDIT] Đang sao kê các CỘT (Attributes) của 27 bảng...\n');

    for (const colId of COLLECTIONS) {
        try {
            const response = await fetchAttributes(colId);
            const attrs = response.attributes.map(a => a.key).join(', ');
            console.log(`📦 [${colId.padEnd(25)}] -> ${attrs || '(Trống)'}`);
        } catch (e) {
            console.log(`❌ Lỗi [${colId}]: ${e.message.substring(0, 50)}`);
        }
    }
}

runAudit();
