ComponentExample = React.createClass
	render: ->
		`<div className="cmp-example">
			<h2>{this.props.name}</h2>
			<div className="cmp-demo">
				<h3>Demo</h3>
				{this.props.children}
			</div>
		</div>`


DropdownExample = React.createClass
	render: ->
		@transferPropsTo `<DropdownButton
			onSelect={this.handleSelect} autoClose={true} />`
	
	handleSelect: (item) ->
		console.log 'selected', item

TooltipExample = React.createClass
	render: ->
		@transferPropsTo `<Tooltip title="a tooltip">{this.props.children}</Tooltip>`
	
	handleSelect: (item) ->
		console.log 'selected', item

PopoverExample = React.createClass
	render: ->
		@transferPropsTo `<PopoverButton autoClose={false}>
			<h2>I'm inside the popover content</h2>
			<p>I can be composed from other components, such a dropdown.
			If you have interactions inside a Popover, you may want to pass
			autoclose=false, so you can interact with it without losing it</p>
				<DropdownButton items={items} autoClose={true} onSelect={this.handleDropdownSelect} title="with a dropdown in it" />
		</PopoverButton>`

	handleDropdownSelect: (item) ->
		console.log 'i got called from the dropdown inside the popver', item


items = [
	{ title: 'item 1' },
	{ title: 'item 2' }, 
	{ title: 'item 3' }
]

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
	}
]

CarouselCustomItem = React.createClass
	render: ->
		`<div>i'm the custom item: {this.props.item.title}</div>`

CarouselExample = React.createClass
	render: ->
		`<Carousel items={carouselItems} itemComponent={CarouselCustomItem} />`

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

		`<div>
			<h1>Components</h1>
			<ComponentExample name="Dropdown" code={dropdownCode}>
				<DropdownExample items={items} placement="down" anchor="right" title="show menu" />
			</ComponentExample>

			<ComponentExample name="Dropup" code={dropupCode}>
				<DropdownExample items={items} placement="up" anchor="left" title="show menu" />
			</ComponentExample>

			<ComponentExample name="Popover" code={popoverCode}>
				<PopoverExample 
					placement="right" 
					title="Lorem ipsum dolor sit amet, consectetur adipisicing elit." />
			</ComponentExample>

			<ComponentExample name="Tooltip" code={popoverCode}>
				<Tooltip title="a tooltip" anchor="center" placement="down">Tooltip content</Tooltip>
			</ComponentExample>

			<ComponentExample name="Carousel" code={popoverCode}>
				<CarouselExample/>
			</ComponentExample>
		</div>`


mountNode = document.getElementById 'content'
React.renderComponent `<Examples />`, mountNode