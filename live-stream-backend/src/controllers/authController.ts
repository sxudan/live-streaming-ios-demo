import admin from "firebase-admin"
import { googleClient } from "../utils/google"
import { JwtPayload, decode } from "jsonwebtoken";
import { UserRecord } from "firebase-admin/lib/auth/user-record";
import { ErrorCode, HttpException, HttpStatusCode } from "../models/exception";
import { database } from "../models/database";
import { SignupInputType } from '../models/signup.input'

const login = async (token: string | undefined): Promise<any> => {
    if (token == undefined) {
        throw new HttpException(HttpStatusCode.UNAUTHORIZED, ErrorCode.INVALID_CREDENTIALS, 'Invalid token')
    }

    let decoded = decode(token)
    let googleToken: string | undefined;
    if (decoded) {
        /// Google token
        if ((decoded as JwtPayload).iss == 'https://accounts.google.com') {
            googleToken = token
        }
    }

    if (googleToken) {
        const ticket = await googleClient.verifyIdToken({
            idToken: googleToken,
        });
        
        const payload = ticket.getPayload();

        if (payload) {
            const userId = payload.sub;
            console.log(userId)
            var user: any
             // Verify user exists in Firebase Auth
            try {
                const userRecord = await admin.auth().getUser(userId);
                user = await database.users.get(userId)
                console.log(userId, user)
            } catch(e) {
                // userRecord = await admin.auth().createUser({
                //     email: payload.email,
                // })
                throw new HttpException(HttpStatusCode.UNAUTHORIZED, ErrorCode.NOT_FOUND, 'User doesnot exist')
            }

            // Generate JWT token
            // const jwtToken = sign({ userId }, process.env.SECRET_KEY!, { expiresIn: '1h' });
            
            return {
                user: user,
                access_token: googleToken
            }
        } else {
            throw new HttpException(HttpStatusCode.UNAUTHORIZED, ErrorCode.INVALID_CREDENTIALS, 'Invalid token')
        }
        
    } else {
        throw new HttpException(HttpStatusCode.UNAUTHORIZED, ErrorCode.INVALID_CREDENTIALS, 'Invalid token')
    }
    
}

const signup = async (input: SignupInputType): Promise<any> => {
    if (input.token == undefined) {
        throw new HttpException(HttpStatusCode.UNAUTHORIZED, ErrorCode.INVALID_CREDENTIALS, 'Invalid token')
    }

    let decoded = decode(input.token)
    let googleToken: string | undefined ;
    if (decoded) {
        /// Google token
        if ((decoded as JwtPayload).iss == 'https://accounts.google.com') {
            googleToken = input.token
        }
    }

    if (googleToken) {
        const ticket = await googleClient.verifyIdToken({
            idToken: googleToken,
        });
        
        const payload = ticket.getPayload();

        if (payload) {
            const userId = payload.sub;
            console.log(userId)
           
            var user: any;
             // Verify user exists in Firebase Auth
             try {
                const userRecord = await admin.auth().getUser(userId);
                // exists
                throw new HttpException(HttpStatusCode.INTERNAL_SERVER_ERROR, ErrorCode.CONNECTION_EXISTS, 'User Already Exist')
             } catch(e) {

             }
            try {
                let userRecord = await admin.auth().createUser({
                    email: payload.email,
                    displayName: `${input.firstname} ${input.lastname}`,
                    uid: userId
                })
                await database.users.add(userRecord.uid,input.username, input.firstname, input.lastname, payload.email!, input.dob, input.phone)
                user = await database.users.get(userId)
            } catch(e) {
                throw new HttpException(HttpStatusCode.INTERNAL_SERVER_ERROR, ErrorCode.INVALID_DATA, (e as Error).message)
            }

            // Generate JWT token
            // const jwtToken = sign({ userId }, process.env.SECRET_KEY!, { expiresIn: '1h' });
            
            return {
                user: user,
                access_token: googleToken
            }
        } else {
            throw new HttpException(HttpStatusCode.UNAUTHORIZED, ErrorCode.INVALID_CREDENTIALS, 'Invalid token')
        }
        
    } else {
        throw new HttpException(HttpStatusCode.UNAUTHORIZED, ErrorCode.INVALID_CREDENTIALS, 'Invalid token')
    }
    
}

export {
    login,
    signup
}