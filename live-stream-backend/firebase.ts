var admin = require("firebase-admin");

const setupFirebase = async () => {
    var serviceAccount = require("./credential.json");

    admin.initializeApp({
    credential: admin.credential.cert(serviceAccount),
    databaseURL: "https://new-project-1557054001172.firebaseio.com"
    });
}

export default setupFirebase;