<template lang="pug">
  .container
    div.row
      div.col-xs-0.col-md-4
      div.col-xs-12.col-md-4
        h3.text-center You know what to do
        form(action="/login", method="post")
          div
            input.form-control(type='text', placeholder='Username', name='username')
          div
            input.form-control(type='password', placeholder='Password', name='password')
          div
            input.form-control.btn.btn-primary(type='submit' value='Go')
      div.col-xs-0.col-md-4

</template>

<script lang="coffee"> # https://github.com/vuejs/vueify/issues/117
  module.exports = require './login'
</script>

<style></style>
