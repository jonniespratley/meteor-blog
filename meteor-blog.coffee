#///////////////////////////
# Client
#///////////////////////////
Client = () ->	

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
	
	# Views
	Template.blog.created = () ->
		console.log('Template created', this)

	Template.blog.rendered = () ->
		console.log('Template rendered', this)
	
	Template.blog.destroyed = () ->
		console.log('Template destroyed', this)
	
	#Inject posts to the blog template, this calls the fetch function on the Posts collection.
	Template.blog.posts = () ->
		return Posts.find().fetch()
		
	Template.blog.post = (id) ->
		return Posts.find({_id: id}).fetch() if id

	#Inject tags into the menu template, this calls the fetch function on the Tags collection.
	Template.blog.tags = () ->
		return Tags.find().fetch()
	
			
	# Controllers
	Template.blog.events({
		#Handle adding a post
		'click #addBtn' : () ->
			post  = {
				title: $('#postTitle').val(),
				body: $('#postBody').val(),
				image: $('#postImage').val(),
				tags: ['New']
			}
			console.log('Insert post', post)
			$('#addBtnModal').modal('toggle')
			Posts.insert(post)
	})
	
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
			editView = Meteor.render(() ->
				return "Edit view #{@title}"
			)
			$('#edit').html(editView).toggleClass('hidden')
	})
	
	#Start the application
	new Router()
	Backbone.history.start({pushState: true})

	

#///////////////////////////
# Server
#///////////////////////////
#Init the database with data
Database = () ->
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
	
Server = () ->
	#Models
	Posts = new Meteor.Collection('posts')
	Tags = new Meteor.Collection('tags')	

	#Start the application
	Meteor.startup(() ->
		console.log('meteor-blog:startup()', Posts)
	)
	
	
Client() if Meteor.isClient
Server() if Meteor.isServer