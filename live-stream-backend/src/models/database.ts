import { firestore } from "firebase-admin"
import { Connection, EditProfileInput } from "./profile"
import { Comment, Media } from "./media"
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
        get: async (uid: string, skipConnection: boolean = false) => {
            const user = (await firestore().collection('users').doc(uid).get()).data() as User
            if(!skipConnection) {
                user.followers = await database.connection.followers(uid)
                user.following = await database.connection.following(uid)
            }
            return user
            // return {
            //     ...user,
            //     followers: await database.connection.followers(uid)
            // }
        },
        update: async (uid: string, editData: EditProfileInput) => {
            const filtered = Object.fromEntries(
                Object.entries(editData).filter(([_, value]) => !!value)
              )
            if (Object.keys(filtered).length > 0) {
                await firestore().collection('users').doc(uid).update(filtered)
            }
            return (await firestore().collection('users').doc(uid).get()).data()
        },
        getAll: async () => {
            const query = await firestore().collection('users').get()
            const users: User[] = []
            query.forEach((doc) => {
                const data = doc.data()
                users.push({
                    uid: doc.id,
                    firstname: data['firstname'],
                    lastname: data['lastname'],
                    dob: data['dob'],
                    username: data['username'],
                    phone: data['phone'],
                    email: data['email']
                })
            })
            return users
        },
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
    },
    comments: {
        add: async (mediaId: string, uid: string, comment: string) => {
            const createdAt = firestore.Timestamp.now().seconds
            await firestore().collection('medias').doc(mediaId).collection('comments').add({
                createdAt: createdAt,
                postedBy: uid,
                comment: comment
            })
        },
        getAll: async (mediaId: string) => {
            const query = await firestore().collection('medias').doc(mediaId).collection('comments').orderBy('createdAt', 'desc').get()
            let raw:any[] = []
            query.forEach(q => {
                const data = q.data()
                raw.push({
                    id: q.id,
                    comment: data['comment'],
                    postedBy: data['postedBy'],
                    createdAt: data['createdAt']
                })
            })
            const comments = await Promise.all(raw.map(async (r) => {
                const postedBy = await database.users.get(r.postedBy, true)
                return {
                    id: r.id,
                    postedBy: postedBy,
                    createdAt: r.createdAt,
                    comment: r.comment
                } as Comment
            }))
            return comments
        }
    },
    connection: {
        add: async (by: string, to: string) => {
            const createdAt = firestore.Timestamp.now().seconds
            const result = await firestore().collection('connections').add({
                createdAt: createdAt,
                followedBy: by,
                followedTo: to,
            })
            
            return {
                id: result.id,
                followedBy: by,
                followedTo: to,
                createdAt: createdAt
            } 
        },
        remove: async (by: string, to: string) => {
            const query = await firestore().collection('connections').where('followedBy', '==', by).where('followedTo', '==', to).get()
            if (query.docs.length > 0) {
                await firestore().collection('connections').doc(query.docs[0].id).delete()
            }
        },
        followers: async (uid: string) => {
            const query = await firestore().collection('connections').where('followedTo', '==', uid).get()
            let results: Connection[] = []
            query.forEach((r) => {
                const data = r.data()
                results.push({
                    id: r.id,
                    followedBy: data['followedBy'],
                    followedTo: data['followedTo'],
                    createdAt: data['createdAt']
                })
            })
            // const r = await Promise.all(results.map(async connection => {
            //     let u = await database.users.get(connection.followedBy)
            //     u.followers = undefined
            //     return u
            // }))
            return results
        },
        following: async (uid: string) => {
            try {
                const query = await firestore().collection('connections').where('followedBy', '==', uid).get()
                let results: Connection[] = []
                query.forEach((r) => {
                    const data = r.data()
                    results.push({
                        id: r.id,
                        followedBy: data['followedBy'],
                        followedTo: data['followedTo'],
                        createdAt: data['createdAt']
                    })
                })
                // const r = await Promise.all(results.map(async connection => {
                //     let u = await database.users.get(connection.followedBy)
                //     u.followers = undefined
                //     return u
                // }))
            return results
            } catch(e) {
                return []
            }
        }
    }
}