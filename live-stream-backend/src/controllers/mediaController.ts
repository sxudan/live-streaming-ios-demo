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
    postedBy: user
  } as Media
}

const updateMediaStatus = async (streamId: string, status: string) => {
  if (status != 'PUBLISHING' && status != 'STOPPED') {
    throw Error('Type Error: use PUBLISHING or STOPPED')
  }
  await database.media.update(streamId, status)
}

const getMedias = async (): Promise<Media[]> => {
  return [
    {
      streamId: "",
      url: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
      createdAt: 1713452526,
      postedBy: {
        firstname: "Sudan",
        lastname: "Suwal",
        uid: "110839611592934017272",
        username: "sxudan",
        dob: 23123123,
        email: "sudosuwal@gmail.com"
      },
    },
    {
        streamId: "",
        url: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4",
        createdAt: 1713452675,
        postedBy: {
          firstname: "Sudan",
          lastname: "Suwal",
          uid: "110839611592934017272",
          username: "sxudan",
          email: "sudosuwal@gmail.com",
          dob: 23123123,
        },
      },
      {
        streamId: "",
        url: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4",
        createdAt: 1713452675,
        postedBy: {
          firstname: "Sudan",
          lastname: "Suwal",
          uid: "110839611592934017272",
          username: "sxudan",
          email: "sudosuwal@gmail.com",
          dob: 23123123,
        },
      },
  ];
};

export {
    getMedias,
    createMedia,
    updateMediaStatus
}