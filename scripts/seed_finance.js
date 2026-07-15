const { Client, Databases, ID, Permission, Role } = require('node-appwrite');

const CONFIG = {
    endpoint: process.env.APPWRITE_ENDPOINT || 'https://sgp.cloud.appwrite.io/v1',
    projectId: process.env.APPWRITE_PROJECT_ID || '6a145b8d001aa82f4dd5',
    databaseId: process.env.APPWRITE_DATABASE_ID || 'database-default',
    apiKey: process.env.APPWRITE_API_KEY || (() => { throw new Error('APPWRITE_API_KEY is required'); })(),
};

const client = new Client().setEndpoint(CONFIG.endpoint).setProject(CONFIG.projectId).setKey(CONFIG.apiKey);
const databases = new Databases(client);

async function seedFinance() {
    console.log('💰 Đang nạp dữ liệu tài chính mẫu...');

    const transactions = [
        {
            walletId: 'system_main',
            amount: 450000,
            type: 'payment',
            status: 'success',
            createdAt: new Date().toISOString()
        },
        {
            walletId: 'tech_001',
            amount: 200000,
            type: 'refund',
            status: 'pending',
            createdAt: new Date().toISOString()
        },
        {
            walletId: 'user_007',
            amount: 1000000,
            type: 'topup',
            status: 'success',
            createdAt: new Date().toISOString()
        }
    ];

    const perms = [Permission.read(Role.any()), Permission.write(Role.any())];

    for (const tx of transactions) {
        try {
            await databases.createDocument(CONFIG.databaseId, 'transactions', ID.unique(), tx, perms);
            console.log(`  ✅ Created transaction: ${tx.amount} (${tx.type})`);
        } catch (e) {
            console.log(`  ❌ Error: ${e.message}`);
            // Nếu lỗi do thiếu attribute, chúng ta sẽ biết ngay
        }
    }

    console.log('\n✨ XONG! Dữ liệu tài chính đã sẵn sàng.');
}

seedFinance();
