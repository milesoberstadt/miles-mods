<template lang="pug">
  //- Single article display
  div(v-if="$route.params.id != null")
    p {{test}} {{$route.params.id}}
  //- List all articles
  div(v-else='')
    div(v-if="articles.length")
      div(v-for='ar in articles')
        div.well.well-lg
          h2 {{ar.title}}
          p {{ar.body.trim(0,200)}}...
  
</template>

<script lang="coffee"> # https://github.com/vuejs/vueify/issues/117
  module.exports = require './knowledge_base'
</script>

<style></style>
