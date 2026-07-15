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
        console.log('--- TRANSACTIONS SAMPLE ---');
        const transactions = await databases.listDocuments(CONFIG.databaseId, 'transactions', [], 1);
        if (transactions.documents.length > 0) {
            console.log('Keys found in document:', Object.keys(transactions.documents[0]));
            console.log('Sample data:', transactions.documents[0]);
        } else {
            console.log('No documents found in transactions collection.');
        }
    } catch (e) {
        console.error(e);
    }
}

inspect();
