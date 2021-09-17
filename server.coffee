# node libraries
path = require 'path'

# web server
express = require 'express'
server = express()

# views and templating
server.set 'views', path.join __dirname, 'templates'
server.set 'view engine', 'jade'

# static assets path
server.use express.static path.join __dirname, '/static'

# routes
server.get '/', (req, res) ->
    res.render 'index'

# startup
PORT = process.env.PORT or 1234
server.listen PORT
console.log 'Express server started on port %s', PORT