import { database } from "../models/database";
import { EditProfileInput } from "../models/profile";

const updateProfile = async (uid: string, editData: EditProfileInput): Promise<any> =>  {
    const data = await database.users.update(uid, editData)
    return data
}

export {
    updateProfile
}