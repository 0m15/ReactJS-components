`/** @jsx React.DOM */`

React = require "react/addons"
DropdownButton = require "../dropdown/dropdown"
#Carousel = require "../carousel/carousel"
#Modal = require "../modal/modal"

ComponentExample = React.createClass
	render: ->
		`<div className="cmp-example">
			<h2>{this.props.name}</h2>
			<div className="cmp-demo">
				<h3>Demo</h3>
				{this.props.children}
			</div>
		</div>`

FixedExample = React.createClass
	render: ->
		style =
			position: 'fixed'
			top: 0
			width: '100%'
			height: 50

		`<div style={style}>
			<DropdownButton title="title" ref="dropdown" position="fixed" placement="down">
					<li><a href="" onClick={this.handleClick}>item</a></li>
					<li><a href="" onClick={this.handleClick}>item1</a></li>
				</DropdownButton>
		</div>`

DropdownExample = React.createClass
	render: ->
		@transferPropsTo `
		<DropdownButton anchor={this.props.anchor} placement={this.props.placement} ref="dropdown" title="title" onSelect={this.handleSelect} autoClose={true}>
			<div className="dropdown-content">
				<h2>I'm a popover</h2>
				<p>I'm a componible ReactJS component</p>
				<DropdownButton title="title" ref="dropdown" placement="left">
					<li><a href="" onClick={this.handleClick}>item</a></li>
					<li><a href="" onClick={this.handleClick}>item1</a></li>
				</DropdownButton>
			</div>
		</DropdownButton>`
	
	handleClick: (e) ->
		console.log '========== handleClick'
		e.preventDefault()
		@refs.dropdown.handleToggle(e)

	handleSelect: (item) ->
		console.log 'selected', item

DropdownApiExample = React.createClass

	render: ->
		`<p>
			Lorem ipsum dolor sit amet, consectetur adipisicing elit. 
			Hic, reiciendis ab sint ut vitae earum necessitatibus 
			excepturi nemo odio nisi quod quaerat porro voluptas 
			itaque odit officiis rem labore commodi.
		</p>`
	
	handleClick: (e) ->
		console.log '========== handleClick'
		e.preventDefault()
		@refs.dropdown.handleToggle(e)

	handleSelect: (item) ->
		console.log 'selected', item

carouselItems = [
	{
		'title': 'item 1',
		'img': 'http://placehold.it/400x400',
		'key': 1
	},
	{
		'title': 'item 2',
		'img': 'http://placehold.it/400x400',
		'key': 2
	},
	{
		'title': 'item 3',
		'img': 'http://placehold.it/400x400',
		'key': 3
	},
	{
		'title': 'item 4',
		'img': 'http://placehold.it/400x400',
		'key': 4
	}
]

CarouselCustomItem = React.createClass
	render: ->
		`<div>i'm the custom item: {this.props.item.title}</div>`

CarouselExample = React.createClass
	render: ->
		`<Carousel items={carouselItems} itemComponent={CarouselCustomItem} />`

#
# MODAL
#

ModalExample = React.createClass
	render: ->
		`<ModalLink ref="modal" title="login">
			<h2>Please login</h2>
			<input type="text" placeholder="username" />
			<input type="password" placeholder="password" />
		</ModalLink>`

#
# ALL EXAMPLES
#

ButtonExample = React.createClass
	render: ->
		@transferPropsTo `<Button>I'm a default button</Button>`

Examples = React.createClass
	render: ->
		dropdownCode = "var items = [\n
				{ title: 'item 1' },\n
				{ title: 'item 2' },\n
		  	{ title: 'item 3' }\n
		]\n\n
		<DropdownExample items={items} title='show menu' placement='down' anchor='right' />
		"

		dropupCode = "var items = [\n
				{ title: 'item 1' },\n
				{ title: 'item 2' },\n
		  	{ title: 'item 3' }\n]\n\n
			<DropdownExample items={items} title='show menu' placement='up' anchor='left' />
		"


		popoverCode = "<PopoverButton title='lorem' placement='right'>\n
			<h2>I'm inside the popover content</h2>\n</PopoverButton>"

		return `<div>
			<h1 data-tooltip="i'm a tooltip?">Components</h1>
			<ComponentExample name="Dropdown" code={dropdownCode}>
				<FixedExample />
			</ComponentExample>
			<ComponentExample name="Dropdown" code={dropdownCode}>
				<DropdownExample placement="down" anchor="center" title="show menu" />
			</ComponentExample>
		</div>`

		# 		<ComponentExample name="Modal" code={popoverCode}>
		# 	<ModalExample />
		# </ComponentExample>
		# <ComponentExample name="Carousel" code="">
		# 	<CarouselExample/>
		# </ComponentExample>



console.log 'init', document, document.body
window.onload = ->
	mountNode = document.body
	React.renderComponent `<Examples />`, mountNode