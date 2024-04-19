import { Media } from "../models/media";

const getMedias = async (): Promise<Media[]> => {
  return [
    {
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
    getMedias
}