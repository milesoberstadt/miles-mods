<template lang="pug">
  .container
    h3 Article Editor
    div.row
      div.col-xs-12.col-md-6
        button.btn.btn-default Create New Article
      div.col-xs-12.col-md-6(v-if="article_names.length")
        label(for='existing_edit_sel') Edit Existing Article:
        select.form-control(name='existing_edit_sel', v-model="selected_article_id", @change="get_article()")
          option -
          option(v-for='a in article_names', :value='a._id') {{a.title}}
    div.row(v-if="selected_article")
      div.col-xs-12.col-md-6
        textarea(v-model="selected_article.body")
      div.col-xs-12.col-md-6
        p(v-html="markdown_html")
          
    div.row
      div.col-xs-12
        button.btn.btn-primary(@click="save_article()") Save Article
        
</template>

<script lang="coffee"> # https://github.com/vuejs/vueify/issues/117
  module.exports = require './article_editor'
</script>

<style></style>
