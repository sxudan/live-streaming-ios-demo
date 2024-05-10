import { database } from "../models/database";
import { EditProfileInput } from "../models/profile";

const updateProfile = async (uid: string, editData: EditProfileInput): Promise<any> =>  {
    const data = await database.users.update(uid, editData)
    return data
}

const searchUsers = async (query: string) => {
    const data = await database.users.getAll()
    const results = data.filter((value) => value.firstname.toLowerCase().includes(query) || value.lastname.toLowerCase().includes('lastname'))
    return results
}

const getProfile = async (uid: string): Promise<any> =>  {
    const data = await database.users.get(uid)
    return data
}

const followUser = async (uid: string, to: string) => {
    const data = await database.connection.add(uid, to)
    return data
}

const unfollowUser = async (uid: string, to: string) => {
    await database.connection.remove(uid, to)
}
export {
    updateProfile,
    searchUsers,
    getProfile,
    followUser,
    unfollowUser
}