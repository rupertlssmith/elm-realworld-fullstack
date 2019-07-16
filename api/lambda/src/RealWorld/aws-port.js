if (!process.env.AWS_REGION) {
  process.env.AWS_REGION = 'us-east-1';
}

if (!process.env.DYNAMODB_NAMESPACE) {
  process.env.DYNAMODB_NAMESPACE = 'dev';
}

const AWS = require('aws-sdk');

// In offline mode, use DynamoDB local server
let DocumentClient = null;

if (process.env.IS_OFFLINE) {
  AWS.config.update({
    region: 'localhost',
    endpoint: "http://localhost:8000"
  });
}

DocumentClient = new AWS.DynamoDB.DocumentClient();


module.exports = {

  ping() {
    return {
      pong: new Date(),
      AWS_REGION: process.env.AWS_REGION,
      DYNAMODB_NAMESPACE: process.env.DYNAMODB_NAMESPACE,
    };
  },

  async purgeData() {
    await purgeTable('users', 'username');
    await purgeTable('articles', 'slug');
    await purgeTable('comments', 'id');
    return envelop('Purged all data!');
  },

  getTableName(aName) {
    return `realworld-${process.env.DYNAMODB_NAMESPACE}-${aName}`;
  },

  tokenSecret: process.env.SECRET ? process.env.SECRET : '3ee058420bc2',
  DocumentClient,

};

async function purgeTable(aTable, aKeyName) {
  const tableName = module.exports.getTableName(aTable);

  if (!tableName.includes('dev') && !tableName.includes('test')) {
    console.log(`WARNING: Table name [${tableName}] ` +
      `contains neither dev nor test, not purging`);
    return;
  }

  const allRecords = await DocumentClient
    .scan({ TableName: tableName }).promise();
  const deletePromises = [];
  for (let i = 0; i < allRecords.Items.length; ++i) {
    const recordToDelete = {
      TableName: tableName,
      Key: {},
    };
    recordToDelete.Key[aKeyName] = allRecords.Items[i][aKeyName];
    deletePromises.push(DocumentClient.delete(recordToDelete).promise());
  }
  await Promise.all(deletePromises);
}
