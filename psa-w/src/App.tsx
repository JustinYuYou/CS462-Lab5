import React, { useEffect, useState } from 'react';
import './App.css';
import { getTemperatures, getViolatedTemperatures } from './service/temperature';

function App() {
  const [temperatures, setTemperatures] = useState([]);
  const [violatedTemperatures, setviolatedTemperatures] = useState([]);

  useEffect(() => {
    // getTemperatures().then(res => {
    //   console.log(res.data)
    //   setTemperatures(res.data);
    // })
    // getViolatedTemperatures().then(res => {
    //   console.log(res.data)
    //   setviolatedTemperatures(res.data);
    // })
    async function fetchData() {
      setTemperatures(await getTemperatures())
      setviolatedTemperatures(await getViolatedTemperatures())
    }
    fetchData();
  }, [])


  return (
    <div className="App">
      {temperatures.length !== 0 && <CurrentTemperature currentTemperature={temperatures[0]} />}
      {temperatures.length !== 0 && <TemperaturesResult temperatures={temperatures} />}
      {violatedTemperatures.length !== 0 && <ViolatedTemperatures violatedTemperatures={violatedTemperatures} />}
      <a href="/profile">Go to change profile</a>
    </div>
  );
}

function CurrentTemperature(props: any) {
  const { currentTemperature } = props;
  const { temperature, timestamp } = currentTemperature
  console.log("here is temp", temperature)

  return (
    <>
      <h1>Current Temperature: </h1>
      <p>{timestamp} : {temperature}</p>
    </>

  )
}

function TemperaturesResult(props: any) {
  const { temperatures } = props;
  console.log("here is temps", temperatures)

  const temperaturesResult = temperatures.map((temperature: any) => (<li key={temperature.timestamp}>{temperature.timestamp} : {temperature.temperature}</li>));

  return (
    <>
      <h1>All Temperatures: </h1>
      <ul>
        {temperaturesResult}
      </ul>
    </>
  );
}


function ViolatedTemperatures(props: any) {
  const { violatedTemperatures } = props;
  const violatedTemperaturesResult = violatedTemperatures.map((temperature: any) => (<li key={temperature.timestamp}>{temperature.timestamp} : {temperature.temperature}</li>));

  return (
    <>
      <h1>Violated Temperatures: </h1>
      <ul>
        {violatedTemperaturesResult}
      </ul>
    </>

  );
}
export default App;
