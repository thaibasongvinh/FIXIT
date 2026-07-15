const { Client, Databases } = require('node-appwrite');

const CONFIG = {
    endpoint: process.env.APPWRITE_ENDPOINT || 'https://sgp.cloud.appwrite.io/v1',
    projectId: process.env.APPWRITE_PROJECT_ID || '6a145b8d001aa82f4dd5',
    databaseId: process.env.APPWRITE_DATABASE_ID || 'database-default',
    apiKey: process.env.APPWRITE_API_KEY || (() => { throw new Error('APPWRITE_API_KEY is required'); })(),
};

const client = new Client().setEndpoint(CONFIG.endpoint).setProject(CONFIG.projectId).setKey(CONFIG.apiKey);
const databases = new Databases(client);

async function listAttributes() {
    try {
        const collections = ['transactions', 'products', 'banners'];
        for (const collId of collections) {
            console.log(`\n--- Collection: ${collId} ---`);
            const coll = await databases.getCollection(CONFIG.databaseId, collId);
            coll.attributes.forEach(attr => {
                console.log(`  - Key: ${attr.key}, Type: ${attr.type}, Required: ${attr.required}`);
            });
        }
    } catch (e) {
        console.error(e);
    }
}

listAttributes();
