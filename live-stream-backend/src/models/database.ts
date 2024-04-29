import { firestore } from "firebase-admin"
import { EditProfileInput } from "./profile"

export const database = {
    users: {
        add: async (uid: string, username: string, firstname: string, lastname: string, email: string, dob: number, phone?: string) => {
            await firestore().collection('users').doc(uid).set({
                uid,
                firstname,
                lastname,
                email,
                dob,
                username,
                phone
            })
        },
        get: async (uid: string) => {
            return (await firestore().collection('users').doc(uid).get()).data()
        },
        update: async (uid: string, editData: EditProfileInput) => {
            const filtered = Object.fromEntries(
                Object.entries(editData).filter(([_, value]) => !!value)
              )
            if (Object.keys(filtered).length > 0) {
                await firestore().collection('users').doc(uid).update(filtered)
            }
            return (await firestore().collection('users').doc(uid).get()).data()
        }
    },
    media: {
        create: async (uid: string): Promise<string> => {
            let user = await database.users.get(uid)
  
            const result = await firestore().collection('medias').add({
                createdBy: uid,
                createdAt: firestore.Timestamp.now().seconds,
                publishing_status: 'CREATED'
            })
            return result.id
        },
        update: async (streamId: string, status: 'PUBLISHING' | 'STOPPED') => {
            await firestore().collection('medias').doc(streamId).update({
                publishing_status: status
            })
        }
    }
}