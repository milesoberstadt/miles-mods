<template lang="pug">
  div.container
    //- Single article display
    div(v-if="$route.params.url != null && article != null")
      div.row
        div.col.s12
          div.card
            div.card-image
              img(:src="article.headerImage")
              span.card-title {{article.title}}
            div.card-content
              div(v-html="article.body")
    //- List all articles
    div(v-else-if='articles.length')
      div(v-if="articles.length")
        div.sm12.m8
          div.card.horizontal(v-for='ar in articles')
            div.card-image
              img(:src='ar.previewImage')
            div.card-stacked
              div.card-content
                router-link.article-title(:to="'/projects/'+ ar.url")
                  span.card-title {{ar.title}}
                p(v-html="ar.preview")
              div.card-action
                router-link.article-title(:to="'/projects/'+ ar.url") Read more...
        //-div(v-for='ar in articles')
          div.well.well-lg
            h2
              a(:href="'/kb/'+ ar.url") {{ar.title}}
            p(v-html="ar.body")
    div(v-else='')
      h2 Loading...

</template>

<script lang="coffee"> # https://github.com/vuejs/vueify/issues/117
  module.exports = require './projects'
</script>

<style></style>
