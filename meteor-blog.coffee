### 
Init the app
###


###
Init the client
###
initClient = () ->	
	#Models
	Tags = new Meteor.Collection('tags')
	Posts = new Meteor.Collection('posts')

	#Client-side router
	Router = Backbone.Router.extend({
		routes: 
			"help" : "help"
			"posts" : "posts"
			"posts/:id" : "detail"
		help: () ->
			console.log('help')
		posts: () ->
			console.log('posts')
		detail: (id) ->
			Template.blog.post(id) if id
			console.log(id) if id
	})
	
	#Meteor.subscribe('tags')
	#Meteor.subscribe('posts')
	
	#Inject posts to the blog template, this calls the fetch function on the Posts collection.
	Template.blog.posts = () ->
		posts = Posts.find().fetch()
		return posts
		
	Template.blog.post = (id) ->
		post = Posts.find({_id: id}).fetch() if id
		return post

	#Inject tags into the menu template, this calls the fetch function on the Tags collection.
	Template.blog.tags = () ->
		tags = Tags.find().fetch()
		return tags
		
	#Attach event listeners to the elements inside of the template and handle accordingly.
	Template.blog.events({
		'click input' : () ->
			console.log('You clicked the button')
	})
	
	new Router()
	Backbone.history.start({pushState: true})


###
Init the database with data
###
initDatabase = () ->
	Posts.insert({
		title: 'Hello ' + new Date()
		body: 'This is an example post created at app startup.'
		image: 'http://placehold.it/64x64'
		published: true
		tags: ['News', 'Events']
	})
	Tags.insert({id: 1, title: 'News', slug: 'news'})
	Tags.insert({id: 2, title: 'Featured', slug: 'featured'})
	Tags.insert({id: 3, title: 'Events', slug: 'events'})
	


###
Init the server
###
initServer = () ->
	#Models
	Posts = new Meteor.Collection('posts')
	Tags = new Meteor.Collection('tags')	
	#Kick off the application
	Meteor.startup(() ->
		console.log('meteor-blog:startup()', Posts)
	)
	
	
initClient() if Meteor.isClient
initServer() if Meteor.isServer