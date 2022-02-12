import React from 'react';
import { useState } from "react";
import { changeProfile } from "./service/profile";


function Profile() {
   const [name, setName] = useState(" ");
   const [location, setLocation] = useState(" ");
   const [smsNumber, setSmsNumber] = useState(" ");
   const [threshold, setThreshold] = useState(0);

   const handleSubmit = async (event: any) => {
      event.preventDefault();
      console.log(name, location, smsNumber, threshold);
      const response = await changeProfile({
         sensor_name: name,
         sensor_location: location,
         sms_number: smsNumber,
         threshold: threshold
      })

      console.log(response.data)
   }

   return (
      <div className="Profile">
         <form onSubmit={handleSubmit}>
            <div>
               <label>Sensor Name: </label>
               <input onChange={e => setName(e.target.value)}></input>
            </div>
            <div>
               <label>Sensor Location: </label>
               <input onChange={e => setLocation(e.target.value)}></input>
            </div>
            <div>
               <label>SMS Number: </label>
               <input onChange={e => setSmsNumber(e.target.value)}></input>
            </div>
            <div>
               <label>Threshold: </label>
               <input onChange={e => setThreshold(Number(e.target.value))}></input>
            </div>
            <div>
               <input type="submit" value="Submit" />
            </div>
         </form>
         <a href='/'>Go Back</a>
      </div>
   )
}

export default Profile;