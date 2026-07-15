const { Client, Databases, Permission, Role, Query } = require('node-appwrite');

const CONFIG = {
    endpoint: process.env.APPWRITE_ENDPOINT || 'https://sgp.cloud.appwrite.io/v1',
    projectId: process.env.APPWRITE_PROJECT_ID || '6a145b8d001aa82f4dd5',
    databaseId: process.env.APPWRITE_DATABASE_ID || 'database-default',
    apiKey: process.env.APPWRITE_API_KEY || (() => { throw new Error('APPWRITE_API_KEY is required'); })(),
};

const client = new Client().setEndpoint(CONFIG.endpoint).setProject(CONFIG.projectId).setKey(CONFIG.apiKey);
const databases = new Databases(client);

// Danh sách ID rác cực lớn để đảm bảo dọn sạch
const GARBAGE_IDS = [
    'p_keo_pvc_new', 'p_pipe_pvc_new', 'p_drain_cleaner', 'p_pl_pump', 'p_wrench_new',
    'prod_l_tape', 'prod_ex_spray', 'prod_wrench', 'prod_p_drill', 'prod_multimeter',
    'p_drill1', 'p_multimeter', 'p_tape', 'p_keo_pvc_old', 'p_pipe_old',
    'p_keo_pvc', 'p_tape_pvc', 'p_pipe_pvc', 'p_wrench_pro', 'p_multimeter', 'p_drill', 'p_pliers', 'p_lock',
    'p_drain_cleaner_new', 'p_pl_pump_new'
];

async function wipeAndSeed() {
    console.log('🧹 Đang dọn sạch database...');

    for (const id of GARBAGE_IDS) {
        await databases.deleteDocument(CONFIG.databaseId, 'products', id).catch(() => {});
    }

    console.log('📦 Đang nạp dữ liệu chuẩn...');

    // Đồng bộ cả issue "Tắc bồn cầu" để đảm bảo khớp ID
    const issues = [
        { id: 'iss_pl_clog', serviceId: 'svc_plumber_con', title: 'Tắc bồn cầu/cống', description: 'Thông tắc đường ống thoát nước.', imagePath: 'Water Tap.png' },
        { id: 'iss_pl_4', serviceId: 'svc_plumber_con', title: 'Lắp hệ thống mới', description: 'Thi công mới toàn bộ đường nước.', imagePath: 'Plumbing Pipe.png' }
    ];

    const products = [
        { id: 'p_keo_pvc', name: 'Keo dán ống nhựa PVC', price: 15000, imagePath: 'Water Tap.png', description: 'Keo chuyên dụng dán ống PVC.', relatedIssueIds: ['iss_pl_4', 'iss_pl_clog'] },
        { id: 'p_tape_pvc', name: 'Băng tan ống nhựa', price: 12000, imagePath: 'Water Tap.png', description: 'Băng keo chống rò rỉ nước.', relatedIssueIds: ['iss_pl_4', 'iss_pl_clog'] },
        { id: 'p_pipe_pvc', name: 'Nhựa PVC Tiền Phong', price: 45000, imagePath: 'Pipe Wrench.png', description: 'Ống nhựa chất lượng cao.', relatedIssueIds: ['iss_pl_4'] },
        { id: 'p_drain_cleaner', name: 'Bột thông cống Hando', price: 35000, imagePath: 'Water Tap.png', description: 'Phân hủy chất thải hữu cơ.', relatedIssueIds: ['iss_pl_clog'] },
        { id: 'p_pl_pump', name: 'Cây thụt bồn cầu', price: 65000, imagePath: 'Pipe Wrench.png', description: 'Thông tắc bồn cầu hiệu quả.', relatedIssueIds: ['iss_pl_clog'] },
    ];

    const perms = [Permission.read(Role.any()), Permission.write(Role.any())];

    for (const i of issues) {
        const { id, ...data } = i;
        await databases.deleteDocument(CONFIG.databaseId, 'service_issues', id).catch(() => {});
        await databases.createDocument(CONFIG.databaseId, 'service_issues', id, data, perms).catch(() => {});
    }

    for (const p of products) {
        const { id, ...data } = p;
        await databases.createDocument(CONFIG.databaseId, 'products', id, data, perms)
            .then(() => console.log(`  ✅ Synced: ${id}`))
            .catch(e => console.log(`  ❌ Error ${id}: ${e.message}`));
    }

    console.log('\n✨ XONG! Dữ liệu đã sạch 100%.');
}

wipeAndSeed();
