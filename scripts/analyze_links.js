const { Client, Databases } = require('node-appwrite');

const CONFIG = {
    endpoint: process.env.APPWRITE_ENDPOINT || 'https://sgp.cloud.appwrite.io/v1',
    projectId: process.env.APPWRITE_PROJECT_ID || '6a145b8d001aa82f4dd5',
    databaseId: process.env.APPWRITE_DATABASE_ID || 'database-default',
    apiKey: process.env.APPWRITE_API_KEY,
};

if (!CONFIG.apiKey) {
    console.error('APPWRITE_API_KEY is required');
    process.exit(1);
}

const client = new Client().setEndpoint(CONFIG.endpoint).setProject(CONFIG.projectId).setKey(CONFIG.apiKey);
const databases = new Databases(client);

const COLLECTIONS = [
    'address_book', 'app_config', 'audit_logs', 'banners', 'bookings', 'calls',
    'chat_messages', 'chat_rooms', 'coupons', 'favorites', 'guide_bookmarks',
    'guide_ratings', 'guide_steps', 'guides', 'notifications', 'payment_methods',
    'popular_services', 'products', 'reviews', 'service_issues', 'services',
    'technician_applications', 'technicians', 'transactions', 'user_settings',
    'users', 'wallets'
];

async function analyze() {
    console.log('🔍 [ANALYSIS] Đang phân tích liên kết giữa các bảng...\n');

    let report = [];

    for (const colId of COLLECTIONS) {
        try {
            const col = await databases.getCollection(CONFIG.databaseId, colId);
            const links = col.attributes
                .filter(attr => attr.key.toLowerCase().endsWith('id') || attr.key.toLowerCase().endsWith('uid'))
                .map(attr => attr.key);

            report.push({
                collection: colId,
                links: links,
                attributes: col.attributes.map(a => a.key)
            });
        } catch (e) {
            console.log(`❌ Lỗi truy cập bảng [${colId}]: ${e.message}`);
        }
    }

    console.log('--- HIỆN TRẠNG LIÊN KẾT (Foreign Keys detected) ---');
    report.forEach(r => {
        console.log(`📦 [${r.collection.padEnd(25)}] -> ${r.links.length > 0 ? r.links.join(', ') : '(Không có liên kết)'}`);
    });

    console.log('\n--- GỢI Ý CÁC LIÊN KẾT CẦN BỔ SUNG (Suggestions) ---');

    const suggestions = {
        'bookings': ['userId', 'technicianId', 'serviceId'],
        'reviews': ['userId', 'technicianId', 'bookingId'],
        'chat_rooms': ['customerId', 'technicianId'],
        'chat_messages': ['senderId', 'roomId'],
        'technician_applications': ['userId'],
        'technicians': ['userId'],
        'wallets': ['userId'],
        'transactions': ['walletId', 'userId', 'bookingId'],
        'favorites': ['userId', 'technicianId', 'serviceId'],
        'guide_bookmarks': ['userId', 'guideId'],
        'guide_ratings': ['userId', 'guideId'],
        'guide_steps': ['guideId'],
        'guides': ['serviceId', 'issueId'],
        'service_issues': ['serviceId'],
        'user_settings': ['userId'],
        'notifications': ['userId']
    };

    for (const [col, expected] of Object.entries(suggestions)) {
        const found = report.find(r => r.collection === col);
        if (found) {
            const missing = expected.filter(e => !found.attributes.includes(e));
            if (missing.length > 0) {
                console.log(`⚠️ [${col.padEnd(25)}] THIẾU: ${missing.join(', ')}`);
            } else {
                // console.log(`✅ [${col.padEnd(25)}] Đầy đủ liên kết.`);
            }
        }
    }
}

analyze();
