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
			"/" : "posts"
			"posts/:id" : "detail"
			"tags/:tag" : "tag"
		help: () ->
			console.log('Render help view')
		posts: () ->
			console.log('Render posts view')
		detail: (id) ->
			Template.blog.post(id) if id
			console.log(id, 'Render post detail view') if id
		tag: (tag) ->
			console.log(tag, 'Render tags view')
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
		
	
	#Inject breadcrumbs template data
	Template.blog.breadcrumbs = () ->
		return currentView = 'Posts'	
	
		
	#Attach event listeners to the elements inside of the template and handle accordingly.
	Template.post.events({

		#Handle removing a post
		'click #deleteBtn' : () ->
			c = confirm('Are you sure you want to delete this?')
			Posts.remove(this._id) if c
			console.log('Delete this post', this)

		#Handle editing a post
		'click #editBtn' : () ->
			console.log('Edit this post', this)
			#Render edit view
			editView = Meteor.render(() ->
				return "Edit view #{@title}"
			)
			$('#edit').html(editView).toggleClass('hidden')
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