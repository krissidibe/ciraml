import AxiosRequest from './axios';




const postsAllGet = "/posts"
const avisAllGet = "/avis"
const loginEnq = "/enquser"
const loginMembre = "/membre"
const postAllAdhesion = "/adhesion"
const postComBase = "/combase"
const postCoorCom = "/coorcom"
const postCoorCercle = "/coorcercle"
const postCoorRegion = "/coorregion"
const getAllRegions = "/regions"
const getCercle = "/cercles"
const getCommune = "/communes"



export const FetchDataParam = (url, value) => {
  
  
   const data = AxiosRequest.get(`${url}/${value}`,{headers: {
                 'Content-Type': 'multipart/form-data'
               
            }
   })
   
    return data;
 }
export const FetchData = (url) => {
   const data = AxiosRequest.get(url,{headers: {
                 'Content-Type': 'multipart/form-data'
               
            }
   })
   
    return data;
 }
export const PostData = (url, datas) => {
  
   const data = AxiosRequest.post(url,datas,{headers: {
                "Content-Type" : "application/json",
               
            }
   })
   
    return data;
 }

export default API = {
    postsAllGet,
    avisAllGet,
    postAllAdhesion,
    postComBase,
    postCoorCom,
    postCoorCercle,
    postCoorRegion,
    getAllRegions,
    getCercle,
    getCommune,
   loginEnq,
    loginMembre
}