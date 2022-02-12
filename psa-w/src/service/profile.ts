import axios from 'axios';
const eci = "ckzhkjhhw000r72pf8qj5dpv4"
const rid = "sensor"
const baseUrl = "http://localhost:3000/sky/event"

async function changeProfile(params: Object) {
   const url = `${baseUrl}/${eci}/1556/${rid}/profile_updated`
   const response = await axios.post(url, params)

   return response
}


export {changeProfile};