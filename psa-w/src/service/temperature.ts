import axios from 'axios';
const eci = "ckzhkjhhw000r72pf8qj5dpv4"
const rid = "temperature_store"
const baseUrl = "http://localhost:3000/sky/cloud"

async function getTemperatures() {
   const url = `${baseUrl}/${eci}/${rid}/temperatures`
   const response = await axios.get(url)
   console.log("temp")

   console.log(response.data)

   return response.data

}

async function getViolatedTemperatures() {
   const url = `${baseUrl}/${eci}/${rid}/threshold_violations`
   const response = await axios.get(url)
   console.log("temps")

   console.log(response.data)

   return response.data
}


export {getTemperatures, getViolatedTemperatures}