import Head from 'next/head';
import Image from 'next/image';
import { useEffect, useState } from 'react';
import styles from '../styles/Home.module.css';
import Web3 from 'web3';
import artifact from '../../smart-contracts/build/contracts/Counter.json';

export default function Home() {
  const [contract, setContract] = useState(null);
  const [counter, setCounter] = useState(0);

  useEffect(() => {
    console.log('osdf')

    const setup = async () => {
      const web3 = new Web3('http://localhost:7545/');
      const accounts = await web3.eth.getAccounts();
      const networkId = await web3.eth.net.getId();
      const contractAddress = artifact.networks[networkId].address;

      setContract(new web3.eth.Contract(artifact.abi, contractAddress, {
        from: accounts[0],
      }));

      console.log('accoounts', accounts)
    }

    setup();
  }, []);

  useEffect(() => {
    console.log(contract)
  }, [contract])

  const increment = async () => {
    contract.methods.increment().send();
    setCounter(await contract.methods.getCount().call())
  }

  return (
    <div className={styles.container}>
      <Head>
        <title>Web3.js next app</title>
        <meta name="description" content="Generated by create next app" />
        <meta name="title" content="app web3js next" />
        <link rel="icon" href="/favicon.ico" />
      </Head>

      <main className={styles.main}>
        <button onClick={increment}>increment</button>
        <p>{counter}</p>
        <Image src="/vercel.svg" alt="logo" width={72} height={16} />
      </main>
    </div>
  )
}