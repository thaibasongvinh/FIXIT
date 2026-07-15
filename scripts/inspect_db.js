const { Client, Databases } = require('node-appwrite');

const CONFIG = {
    endpoint: process.env.APPWRITE_ENDPOINT || 'https://sgp.cloud.appwrite.io/v1',
    projectId: process.env.APPWRITE_PROJECT_ID || '6a145b8d001aa82f4dd5',
    databaseId: process.env.APPWRITE_DATABASE_ID || 'database-default',
    apiKey: process.env.APPWRITE_API_KEY || (() => { throw new Error('APPWRITE_API_KEY is required'); })(),
};

const client = new Client().setEndpoint(CONFIG.endpoint).setProject(CONFIG.projectId).setKey(CONFIG.apiKey);
const databases = new Databases(client);

async function inspect() {
    try {
        console.log('--- PRODUCTS ---');
        const products = await databases.listDocuments(CONFIG.databaseId, 'products');
        products.documents.forEach(doc => {
            console.log(`ID: ${doc.$id}, Name: ${doc.name}, relatedIssueIds: ${JSON.stringify(doc.relatedIssueIds)}`);
        });

        console.log('\n--- SERVICE ISSUES ---');
        const issues = await databases.listDocuments(CONFIG.databaseId, 'service_issues');
        issues.documents.forEach(doc => {
            console.log(`ID: ${doc.$id}, Title: ${doc.title}`);
        });
    } catch (e) {
        console.error(e);
    }
}

inspect();
