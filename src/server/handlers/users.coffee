Handler = require 'provide-handler'
{ Users } =  require '../models'
monk = require 'monk'

class UsersHandler
  get_with_id: (id, callback) ->
    Users.find_by_id(id).then (user) =>
      callback(user)
  get_with_username: (username, callback) ->
    Users.find_by_username(username).then (user) =>
      callback(user)

module.exports = new UsersHandler
