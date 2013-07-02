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
			"/" : "posts"
			"posts/:id" : "detail"
			"tags/:tag" : "tag"
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
	
	#This gets invoked whenever the template is created.
	Template.blog.created = () ->
		console.log('Template created', this)

	#This gets invoked whenever the template is rendered.
	Template.blog.rendered = () ->
		console.log('Template rendered', this)
	
	#This gets invoked whenever the template is destroyed.
	Template.blog.destroyed = () ->
		console.log('Template destroyed', this)
	
	#Inject posts to the blog template, this calls the fetch function on the Posts collection.
	Template.blog.posts = () ->
		return Posts.find().fetch()
		
	#Inject the post into the template, this calls the findOne function on the Posts collection.
	Template.blog.post = (id) ->
		return Posts.findOne({_id: id}).fetch() if id
		
	#Inject tags into the menu template, this calls the fetch function on the Tags collection.
	Template.blog.tags = () ->
		return Tags.find().fetch()
	
			
	# Controllers
	
	#Blog Events - Attach event listeners to the elements inside of the template and handle accordingly.
	Template.blog.events({

		#Handle adding a post when the element is clicked.
		'click #addBtn' : () ->
			post  = 
				title: $('#postTitle').val()
				body: $('#postBody').val()
				image: $('#postImage').val()
				tags: ['New']
			$('#addBtnModal').modal('toggle')
			Posts.insert(post)
			console.log('Insert post', post)
			
		#Handle adding a tag when the element is clicked.
		'click #addTagBtn' : () ->
			el = $('#postTagsInput')
			tag = 
				slug: el.val()
				title: el.val()
			el.val('')
			Tags.insert(tag);
			console.log('Insert tag', tag)
			
			
		#Handle removing a tag when the element is clicked.
		'click #deleteTagBtn' : () ->
			c = confirm('Are you sure you want to delete this?')
			Tags.remove(this._id) if c
			console.log('Delete this tag', this)
	})
	
	#Post Events - Attach event listeners to the elements inside of the template and handle accordingly.
	Template.post.events({
		
		#Handle removing a post when the element is clicked.
		'click #deletePostBtn' : () ->
			c = confirm('Are you sure you want to delete this?')
			Posts.remove(this._id) if c
			console.log('Delete this post', this)

		#Handle editing a post when the element is clicked.
		'click #editBtn' : () ->
			editView = Meteor.render(() ->
				title = @title;
				return "Edit view #{title}"
			)
			console.log('Edit this post', this)
			$('#edit').html(editView).toggleClass('hidden')
	})
	
	
	
	
	#Start the application
#	new Router()
#	Backbone.history.start({pushState: true})

	

#///////////////////////////
# Server
#///////////////////////////	
Server = () ->
	#Models
	Posts = new Meteor.Collection('posts')
	Tags = new Meteor.Collection('tags')	
	
	#Start the application on server startup, if the database is empty, create some initial data.
	Meteor.startup(() ->
		if Posts.find().count() is 0
			Posts.insert({
				title: 'Hello ' + new Date()
				body: 'In this article we will talk about using Yeoman, which is a client-side stack using three tools and frameworks to help developers quickly build beautiful and scalable web applications, these tools include support for linting, testing, minification and more.'
				image: 'https://dl.dropboxusercontent.com/u/26906414/cdn/img/yeoman-logo.png'
				published: true
				tags: ['News', 'Events']
			})
		if Tags.find().count() is 0
			Tags.insert({id: 1, title: 'News', slug: 'news'})
			Tags.insert({id: 2, title: 'Featured', slug: 'featured'})
			Tags.insert({id: 3, title: 'Events', slug: 'events'})
		
		console.log('meteor-blog:startup()', this)
	)	
	
Client() if Meteor.isClient
Server() if Meteor.isServer