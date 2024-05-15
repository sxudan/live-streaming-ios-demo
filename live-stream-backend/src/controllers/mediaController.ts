import { firestore } from "firebase-admin";
import { database } from "../models/database";
import { Media } from "../models/media";
import { HttpException } from "../models/exception";

const createMedia = async (uid: string) => {
  let streamId = await database.media.create(uid)
  let user = await database.users.get(uid)
  return {
    streamId,
    url: `/${streamId}`,
    createdAt: firestore.Timestamp.now().seconds,
    postedBy: user,
    status: 'PUBLISHING',
  } as Media
}

const updateMediaStatus = async (streamId: string, status: string) => {
  if (status != 'PUBLISHING' && status != 'STOPPED') {
    throw Error('Type Error: use PUBLISHING or STOPPED')
  }
  await database.media.update(streamId, status)
}

const getMedias = async (self: string): Promise<Media[]> => {
  const rawMedias =  await database.media.getAll()
  // const user = await database.users.get(self, false)
  // const filtered = user.following?.map(f => rawMedias.filter(x => x.postedBy.uid == f.followedTo) )
  // console.log('filtered => ',filtered)
  return rawMedias
};

const addComment = async (uid: string, comment: string, streamId: string) => {
  await database.comments.add(streamId, uid, comment)
}

const fetchComments = async (streamId: string) => {
  return await database.comments.getAll(streamId)
}

export {
    getMedias,
    createMedia,
    updateMediaStatus,
    addComment,
    fetchComments
}