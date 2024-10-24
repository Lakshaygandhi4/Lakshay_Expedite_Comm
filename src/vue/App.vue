<template>
  <div id="app">
    <Home :opportunities="opportunities" />
  </div>
</template>

<script>
import Home from './Home.vue';

export default {
  components: {
    Home,
  },
  props: {
    opportunities: {
      type: Array,
      required: true
    },
  },
};
</script>