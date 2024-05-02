import { firestore } from "firebase-admin"
import { EditProfileInput } from "./profile"
import { Media } from "./media"
import {User} from '../models/user'

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
        },
        getAll: async () => {
            const query = await firestore().collection('medias').get()
            let medias: Media[] = []
           
            let datas: {'id': string, 'createdBy': string, 'createdAt': number, 'status': string}[] = []
            query.forEach(doc => {
                if (doc.data()['publishing_status'] != 'CREATED') {
                    datas.push({
                        id: doc.id,
                        createdBy: doc.data()['createdBy'],
                        createdAt: doc.data()['createdAt'],
                        status: doc.data()['publishing_status']
                    })
                }
            })

            await Promise.all(datas.map(async (d) => {
                let user = await database.users.get(d['createdBy'])
                medias.push({
                    streamId: d.id,
                    createdAt: d['createdAt'],
                    url: `http://192.168.1.100:3000/medias/${d.id}`,
                    postedBy: user as User,
                    status: d.status as 'PUBLISHING' | 'STOPPED'
                })
            }))
            // await Promise.all(query.forEach(async doc => {
                // let data = doc.data()
                // console.log(data)
                // let user = await database.users.get(data['createdBy'])
                // media.push({
                //     streamId: doc.id,
                //     createdAt: data['createdAt'],
                //     url: `http://192.168.1.100:8554/${doc.id}`,
                //     postedBy: user as User
                // })
            // }))
            return medias
        }
    }
}