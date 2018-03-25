<template lang="pug">
  .container
    h3 Admin Page
    router-link.btn.btn-default(to='/admin/edit') Edit Articles
</template>

<script lang="coffee"> # https://github.com/vuejs/vueify/issues/117
  module.exports = require './admin'
</script>

<style></style>
