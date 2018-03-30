<template lang="pug">
  .container
    h3 Article Editor
    div.row
      div.col-xs-12.col-md-6
        button.btn.btn-default(@click="new_article()") Create New Article
        h4 Or
        div.input-field.col.s12.m6
          select.form-control#existing_edit_sel(v-model="selected_article_id", @change="get_article()")
            option(disabled='', selected='') Pick an article to edit
            option(v-for='a in article_names', :value='a._id') {{a.title}}
          label.active(for='existing_edit_sel') Edit Existing Article:
    div.row(v-if="selected_article")
      h4 Edit Article
      div.col.s12
        div.card
          //-
            <div class="input-field col s6">
              <input placeholder="Placeholder" id="first_name" type="text" class="validate">
              <label for="first_name">First Name</label>
            </div>
          div.card-content
            div.row
              span.card-title Article Attributes
              form.col.s12
                div.row
                  div.input-field.col.s6
                    input.form-control#article_title(v-model="selected_article.title", type="text")
                    label.active(for='article_title') Article Title
                  div.input-field.col.s6
                    input.form-control#article_url_editor(v-model="selected_article.url", type="text")
                    label.active(for='article_url_editor') Article URL code
                div.row
                  div.input-field.col.s6
                    input.form-control#article_preview_link(v-if="preview_url", v-model="selected_article.previewImage", type="text")
                    input.form-control#article_preview_link(v-else="", @keyup="useLink('preview', $event)", type="text", placeholder="Using image from database")
                    label.active(for='article_preview_link') Article Thumbnail Preview Image
                  div.input-field.col.s6
                    input.form-control#article_preview_img(type='file', accept="image/png, image/jpeg", @change="uploadImage('preview', $event)", ref="article_preview_img")
                    label.active(for='article_preview_img') Or, upload a preview image
                div.row
                  div.input-field.col.s6
                    input.form-control#article_header_link(v-model="selected_article.headerImage", type="text")
                    label.active(for='article_header_link') Article Header Image (TODO: Add image uploader)
                  div.input-field.col.s6
                    input.form-control#article_header_img(type='file', accept="image/png, image/jpeg", @change="uploadImage('header', $event)")
                    label.active(for='article_header_img') Or, upload a header image
                div.row
                  div.input-field.col.s12
                    textarea.form-control.materialize-textarea#article_body_editor(v-model="selected_article.body", :style='{"min-width": "100%", "min-height": "6rem"}', rows=10)
                    label.active(for="article_body_editor") Article Body
                p TODO: Build a tag selector
      h4 Article Preview
      div.col.s12
        div.card
          div.card-content
            span.card-title {{selected_article.title}}
            p(v-html="markdown_html")

    div.row(v-if="selected_article")
      div.col-xs-12
        button.btn.btn-primary(@click="save_article()") Save Article

</template>

<script lang="coffee"> # https://github.com/vuejs/vueify/issues/117
  module.exports = require './article_editor'
</script>

<style></style>
