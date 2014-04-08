ReactJS-components
==================

Some reusable ReactJS components I'm writing as I learn the library

# Available components

## Dropdown

    items = [{title: 'one'}, {title: 'two'}, {title: 'three'}]

Right anchored dropdown
    <DropdownExample items={items} title='show menu' placement='down' anchor='right' />
    
Left anchored dropup
    <DropdownExample items={items} title='show menu' placement='up' anchor='left' />
    
Centered dropup
    <DropdownExample items={items} title='show menu' placement='up' anchor='center' />
    
## Popover

A simple popover content

  <PopoverButton placement="right" anchor="center">
		<h2>I'm inside the popover content</h2>
		<p>I'm the popover body</p>
	</PopoverButton>
	
A popover with component inside

  <PopoverButton autoClose={false}>
		<h2>Popover with a dropdon inside</h2>
		<p>I'm a composable component</p>
		<DropdownButton items={items} autoClose={true} onSelect={this.handleDropdownSelect} title="with a dropdown in it" />
	</PopoverButton>
	
## Carousel

A simple carosel that "react" to the available viewport

  var carouselItems = [
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
  <Carousel items={carouselItems} itemComponent={CarouselCustomItem} />
