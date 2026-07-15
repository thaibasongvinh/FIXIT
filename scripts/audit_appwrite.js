const https = require('https');
const fs = require('fs');
const path = require('path');

const CONFIG = {
    endpoint: process.env.APPWRITE_ENDPOINT_HOST || 'sgp.cloud.appwrite.io',
    projectId: process.env.APPWRITE_PROJECT_ID || '6a145b8d001aa82f4dd5',
    databaseId: process.env.APPWRITE_DATABASE_ID || 'database-default',
    apiKey: process.env.APPWRITE_API_KEY || 'standard_6de4d38760a772bd4006cc26d99353ed12f03e1e9f1a743be083627ec864bb7cb9e58478865c1b8823f1f3793dcde25baaeba78244b8a8e8a5530da6412db68a1c00d329da03c6d19f57718c4714d6950d3218a33d2db9ba5001f12cd6f83352314888399d0cd72648989495cc06535781e57585cf7fc28b830f4e2a194f495b',
};

function fetchAppwrite(collectionId) {
    return new Promise((resolve, reject) => {
        const options = {
            hostname: CONFIG.endpoint,
            path: `/v1/databases/${CONFIG.databaseId}/collections/${collectionId}/documents?limit=100`,
            method: 'GET',
            headers: {
                'Content-Type': 'application/json',
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

async function runAudit() {
    console.log('🔍 [FULL AUDIT] Bắt đầu sao kê TOÀN BỘ 27 BẢNG dữ liệu...');

    const collections = [
        'address_book',
        'app_config',
        'audit_logs',
        'banners',
        'bookings',
        'calls',
        'chat_messages',
        'chat_rooms',
        'coupons',
        'favorites',
        'guide_bookmarks',
        'guide_ratings',
        'guide_steps',
        'guides',
        'notifications',
        'payment_methods',
        'popular_services',
        'products',
        'reviews',
        'service_issues',
        'services',
        'technician_applications',
        'technicians',
        'transactions',
        'user_settings',
        'users',
        'wallets'
    ];

    let fullBackup = {};

    for (const colId of collections) {
        process.stdout.write(`  📦 [${colId.padEnd(25)}] `);
        try {
            const response = await fetchAppwrite(colId);
            fullBackup[colId] = {
                status: 'OK',
                total: response.total,
                data: response.documents.map(doc => {
                    const { $id, $permissions, $collectionId, $databaseId, ...cleanData } = doc;
                    return { id: $id, ...cleanData };
                })
            };
            console.log(`✅ [${response.total} bản ghi]`);
        } catch (e) {
            console.log(`❌ Lỗi: ${e.message.substring(0, 30)}...`);
            fullBackup[colId] = { status: 'ERROR', message: e.message };
        }
    }

    const outputPath = path.join(__dirname, 'appwrite_data_audit.json');
    fs.writeFileSync(outputPath, JSON.stringify(fullBackup, null, 4), 'utf8');
    console.log(`\n✨ XONG! Đã sao kê đầy đủ 27 bảng.`);
    console.log(`📂 File sao kê: ${outputPath}`);
}

runAudit();
