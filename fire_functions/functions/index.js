
const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

exports.scheduledFunctionCrontab = functions.pubsub.schedule('0 12,18 * * *')
  .timeZone('Asia/Yekaterinburg') // Users can choose timezone - default is America/Los_Angeles
  .onRun(async (context) => {
    const photo_collection = await  admin.firestore().collection('current_set').get();
    if(photo_collection.empty){
        console.log('No matching documents');
        return; 
    }

    photo_array = photo_collection.docs;
    random_index = Math.floor(Math.random()*photo_array.length);  

const current_index_doc =  admin.firestore().collection('functional_data').doc('current_index');
current_index_doc.set({index:random_index});

  console.log('new current_index value'+random_index);
});