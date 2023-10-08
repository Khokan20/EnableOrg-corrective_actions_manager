import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

admin.initializeApp();

export const deleteUser = functions.firestore.document("/User/{uid}")
    .onDelete(async (snapshot, context) => {        
        const userId = context.params.uid;

        try {
            await admin.auth().deleteUser(userId);
            console.log('User deleted from Authentication:', userId);
        } catch (error) {
            console.error('Error deleting user from Authentication:', error);
        }
    });
