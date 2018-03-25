<template lang="pug">
  .container
    h3 Article Editor
    div.row
      div.col-xs-12.col-md-6
        button.btn.btn-default(@click="new_article()") Create New Article
        h4 Or
        div.input-field.col.s12.m4
          select.form-control(id='existing_edit_sel', v-model="selected_article_id", @change="get_article()")
            option -
            option(v-for='a in article_names', :value='a._id') {{a.title}}
          label(for='existing_edit_sel') Edit Existing Article:
    div.row(v-if="selected_article")
      div.col-xs-12.col-md-6
        label(for="article_title_editor") Article Title
        input.form-control(v-model="selected_article.title")
        label(for="article_url_editor") Article URL code
        input.form-control(v-model="selected_article.url")
        label(for="article_body_editor") Article Body
        textarea.form-control(v-model="selected_article.body", style='min-width: 100%', rows=10)
        label TODO: Build a tag selector
      div.col-xs-12.col-md-6
        p(v-html="markdown_html")
          
    div.row(v-if="selected_article")
      div.col-xs-12
        button.btn.btn-primary(@click="save_article()") Save Article
        
</template>

<script lang="coffee"> # https://github.com/vuejs/vueify/issues/117
  module.exports = require './article_editor'
</script>

<style></style>
