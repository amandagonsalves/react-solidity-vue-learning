<template>
  <div>
    <button @click="increment">increment</button>
    <p>{{ state.counter }}</p>
  </div>
</template>

<script>
import artifact from '../../smart-contracts/build/contracts/Counter.json';
import Web3 from 'web3';
import { onMounted, reactive } from 'vue';

export default {
  name: 'App',
  components: {},
  setup() {
    const state = reactive({
      contract: null,
      counter: null,
    });

    onMounted(async () => {
      const web3 = new Web3('http://127.0.0.1:7545');
      const accounts = await web3.eth.getAccounts();
      const networkId = await web3.eth.net.getId();
      const contractAddress = artifact.networks[networkId].address;

      state.contract = new web3.eth.Contract(artifact.abi, contractAddress, {
        from: accounts[0],
      });
    });

    const increment = async () => {
      await state.contract.methods.increment().send();

      state.counter = await state.contract.methods.getCount().call();
    }

    return {
      state,
      increment,
    }
  },
};
</script>

<style>
#app {
  font-family: Avenir, Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
  margin-top: 60px;
}
</style>
