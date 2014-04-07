/** @jsx React.DOM */;


var AbsolutePositionMixin;

AbsolutePositionMixin = {
  getInitialState: function() {
    return {
      style: {
        position: 'absolute'
      }
    };
  },
  componentDidMount: function() {
    this.setPosition();
    return $(window).on('resize', this.setPosition);
  },
  setPosition: function() {
    var $btnEl, $contentEl, anchor, btnHeight, btnOffset, btnWidth, contentElHeight, contentElWidth, placement, style;
    $btnEl = $(this.refs.button.getDOMNode());
    $contentEl = $(this.refs.menu.getDOMNode());
    btnWidth = $btnEl.width();
    btnHeight = $btnEl.height();
    btnOffset = $btnEl.offset();
    contentElWidth = $contentEl.width();
    contentElHeight = $contentEl.height();
    anchor = this.props.anchor;
    placement = this.props.placement;
    style = this.state.style;
    if (placement === 'right' || placement === 'left') {
      style.top = btnOffset.top + (btnHeight / 2) - (contentElHeight / 2);
    }
    if (placement === 'right') {
      style.left = btnWidth + btnOffset.left;
    }
    if (placement === 'left') {
      style.left = btnOffset.left - contentElWidth;
    }
    if (placement === 'up' || placement === 'down') {
      style.left = btnOffset.left + (btnWidth / 2) - contentElWidth / 2;
      if (anchor === 'left') {
        style.left = btnOffset.left;
      }
      if (anchor === 'right') {
        style.left = btnOffset.left - (contentElWidth - btnWidth);
      }
    }
    if (placement === 'up') {
      style.top = btnOffset.top - contentElHeight;
    }
    this.setState({
      style: style
    });
    return this.adjustToViewport();
  },
  adjustToViewport: function() {
    var $dropdownEl, dropdownLeftOffset, dropdownMarginRight, dropdownWidth, offsetDiff, style, winWidth;
    $dropdownEl = $(this.refs.menu.getDOMNode());
    dropdownMarginRight = parseInt($dropdownEl.css('margin-right'));
    dropdownLeftOffset = $(this.refs.button.getDOMNode()).offset().left;
    dropdownWidth = $dropdownEl.width();
    style = this.state.style;
    winWidth = $(window).width();
    offsetDiff = 0;
    if (dropdownLeftOffset < 0 || $dropdownEl.offset().left < 0) {
      offsetDiff = dropdownMarginRight - (-dropdownLeftOffset);
      if (this.props.placement === 'right') {
        style['margin-right'] = 0;
        style['left'] = 0;
      } else {
        style['margin-left'] = 0;
        style['left'] = 0;
      }
    }
    if (dropdownLeftOffset + dropdownWidth > winWidth) {
      offsetDiff = (dropdownLeftOffset + $dropdownEl.width()) - winWidth;
      style.left = -1 * offsetDiff + 'px';
    }
    return this.setState({
      style: style
    });
  }
};

var DropdownStateMixin, PopoverStateMixin, ToggableStateMixin;

ToggableStateMixin = PopoverStateMixin = DropdownStateMixin = {
  getInitialState: function() {
    return {
      open: false
    };
  },
  bindCloseHandler: function() {
    document.addEventListener('keyup', this.handleKeyup);
    if (this.props.autoClose) {
      return document.addEventListener('click', this.handleClickOutside);
    }
  },
  unbindCloseHandler: function() {
    document.removeEventListener('keyup', this.handleKeyup);
    if (this.props.autoClose) {
      return document.removeEventListener('click', this.handleClickOutside);
    }
  },
  handleClickOutside: function(e) {
    this.setState({
      open: false
    });
    return this.unbindCloseHandler();
  },
  handleKeyup: function(e) {
    if (e.keyCode === 27) {
      this.setState({
        open: false
      });
    }
    return this.unbindCloseHandler();
  },
  handleToggle: function(e) {
    var open;
    e.preventDefault();
    open = !this.state.open;
    this.setState({
      open: open
    });
    if (open === true) {
      return this.bindCloseHandler();
    } else {
      return this.unbindCloseHandler();
    }
  }
};

var Carousel, CarouselControls, CarouselItem, CarouselStateMixin, PropTypes, ReactCSSTransitionGroup, ReactTransitionGroup, classSet;

classSet = React.addons.classSet;

ReactCSSTransitionGroup = React.addons.CSSTransitionGroup;

ReactTransitionGroup = React.addons.TransitionGroup;

PropTypes = React.PropTypes;

CarouselStateMixin = {
  propTypes: {
    items: PropTypes.array,
    itemComponent: PropTypes.component
  },
  getInitialState: function() {
    return {
      index: 0,
      activeItems: this.props.items.slice(0, 1),
      direction: 'forward'
    };
  },
  setActiveItem: function(index, direction) {
    var newItem, newItems;
    newItem = this.props.items[index];
    newItems = this.state.activeItems;
    newItems.pop();
    newItems.unshift(newItem);
    return this.setState({
      index: index,
      activeItems: newItems,
      direction: direction
    });
  },
  handleNext: function(e) {
    var index;
    e.preventDefault();
    index = this.state.index;
    index += 1;
    if (index === this.props.items.length) {
      index = 0;
    }
    return this.setActiveItem(index, 'forward');
  },
  handlePrevious: function(e) {
    var index;
    e.preventDefault();
    index = this.state.index;
    index -= 1;
    if (index < 0) {
      index = this.props.items.length - 1;
    }
    return this.setActiveItem(index, 'backward');
  }
};

CarouselControls = React.createClass({
  propTypes: {
    onNext: PropTypes.func,
    onPrevious: PropTypes.func
  },
  render: function() {
    return <div className="carousel-controls">
				<a href="" onClick={this.handlePrevious}>prev</a> 
				<a href="" onClick={this.handleNext}>next</a>
		</div>;
  },
  handleNext: function(e) {
    return this.props.onNext(e);
  },
  handlePrevious: function(e) {
    return this.props.onPrevious(e);
  }
});

CarouselItem = React.createClass({
  propTypes: {
    item: PropTypes.object,
    itemComponent: PropTypes.component
  },
  render: function() {
    var classes;
    classes = classSet({
      'carousel-item': true,
      active: this.props.active
    });
    return <div className={classes}>
			{this.props.itemComponent({item: this.props.item})}
		</div>;
  }
});

Carousel = React.createClass({
  mixins: [CarouselStateMixin],
  render: function() {
    var children, self;
    self = this;
    children = this.state.activeItems.map(function(item, i) {
      return <CarouselItem
				item={item} 
				key={item.key} 
				active={i==self.state.index}
				itemComponent={self.props.itemComponent}
			/>;
    });
    return <div className={"carousel " + this.state.direction}>
			<ReactCSSTransitionGroup transitionName='slide'>
				{children}
			</ReactCSSTransitionGroup>
			<CarouselControls onNext={this.handleNext} onPrevious={this.handlePrevious}/>
		</div>;
  }
});

/** @jsx React.DOM */;
var DropdownButton, DropdownMenu, DropdownMenuItem, classSet;

classSet = React.addons.classSet;

DropdownButton = React.createClass({
  mixins: [AbsolutePositionMixin, ToggableStateMixin],
  render: function() {
    var classes;
    classes = classSet({
      open: this.state.open,
      dropdown: true,
      up: this.props.direction === 'up',
      down: this.props.direction === 'down'
    });
    return <div className={classes}>
			<a href="" onClick={this.handleToggle} className="btn btn-dropdown" ref="button">
				{this.props.title} <i className="icon-caret"></i>
			</a>
			<DropdownMenu ref="menu" items={this.props.items} onSelect={this.props.onSelect} style={this.state.style} />
		</div>
		;
  }
});

DropdownMenu = React.createClass({
  render: function() {
    return <ul className="dropdown-menu" style={this.props.style}>
			{this.props.items.map(function(item, i) {
				return (<DropdownMenuItem item={item} onSelect={this.props.onSelect} key={i} />)
			}, this)}
		</ul>
		;
  }
});

DropdownMenuItem = React.createClass({
  render: function() {
    return <li>
		 	<a href="" onClick={this.handleClick}>{this.props.item.title}</a>
		 </li>;
  },
  handleClick: function(e) {
    e.preventDefault();
    return this.props.onSelect(this.props.item);
  }
});

var PopoverButton, PopoverPanel, classSet;

classSet = React.addons.classSet;

PopoverButton = React.createClass({
  mixins: [ToggableStateMixin, AbsolutePositionMixin],
  render: function() {
    var classes;
    classes = classSet({
      open: this.state.open,
      popover: true
    });
    return <div className={classes}>
			<a href="" onClick={this.handleToggle} className="btn btn-dropdown" ref="button">
				{this.props.title} <i className="icon-caret"></i>
			</a>
			<PopoverPanel ref="menu" style={this.state.style}>{this.props.children}</PopoverPanel>
		</div>
		;
  }
});

PopoverPanel = React.createClass({
  render: function() {
    return <div className="popover-content" style={this.props.style}>
			{this.props.children}
		</div>;
  }
});

var Tooltip, TooltipContent, classSet;

classSet = React.addons.classSet;

Tooltip = React.createClass({
  mixins: [ToggableStateMixin, AbsolutePositionMixin],
  render: function() {
    var classes;
    classes = classSet({
      open: this.state.open,
      tooltip: true
    });
    return <span className={classes}>
			<a href="" onMouseOver={this.handleToggle} onMouseOut={this.handleToggle} className="btn btn-dropdown" ref="button">
				{this.props.title} <i className="icon-caret"></i>
			</a>
			<TooltipContent ref="menu" style={this.state.style}>{this.props.children}</TooltipContent>
		</span>
		;
  }
});

TooltipContent = React.createClass({
  render: function() {
    return <div className="tooltip-content" style={this.props.style}>
			{this.props.children}
		</div>;
  }
});

var CarouselCustomItem, CarouselExample, ComponentExample, DropdownExample, Examples, PopoverExample, TooltipExample, carouselItems, items, mountNode;

ComponentExample = React.createClass({
  render: function() {
    return <div className="cmp-example">
			<h2>{this.props.name}</h2>
			<div className="cmp-demo">
				<h3>Demo</h3>
				{this.props.children}
			</div>
		</div>;
  }
});

DropdownExample = React.createClass({
  render: function() {
    return this.transferPropsTo(<DropdownButton
			onSelect={this.handleSelect} autoClose={true} />);
  },
  handleSelect: function(item) {
    return console.log('selected', item);
  }
});

TooltipExample = React.createClass({
  render: function() {
    return this.transferPropsTo(<Tooltip title="a tooltip">{this.props.children}</Tooltip>);
  },
  handleSelect: function(item) {
    return console.log('selected', item);
  }
});

PopoverExample = React.createClass({
  render: function() {
    return this.transferPropsTo(<PopoverButton autoClose={false}>
			<h2>I'm inside the popover content</h2>
			<p>I can be composed from other components, such a dropdown.
			If you have interactions inside a Popover, you may want to pass
			autoclose=false, so you can interact with it without losing it</p>
				<DropdownButton items={items} autoClose={true} onSelect={this.handleDropdownSelect} title="with a dropdown in it" />
		</PopoverButton>);
  },
  handleDropdownSelect: function(item) {
    return console.log('i got called from the dropdown inside the popver', item);
  }
});

items = [
  {
    title: 'item 1'
  }, {
    title: 'item 2'
  }, {
    title: 'item 3'
  }
];

carouselItems = [
  {
    'title': 'item 1',
    'img': 'http://placehold.it/400x400',
    'key': 1
  }, {
    'title': 'item 2',
    'img': 'http://placehold.it/400x400',
    'key': 2
  }, {
    'title': 'item 3',
    'img': 'http://placehold.it/400x400',
    'key': 3
  }
];

CarouselCustomItem = React.createClass({
  render: function() {
    return <div>i'm the custom item: {this.props.item.title}</div>;
  }
});

CarouselExample = React.createClass({
  render: function() {
    return <Carousel items={carouselItems} itemComponent={CarouselCustomItem} />;
  }
});

Examples = React.createClass({
  render: function() {
    var dropdownCode, dropupCode, popoverCode;
    dropdownCode = "var items = [\n { title: 'item 1' },\n { title: 'item 2' },\n { title: 'item 3' }\n ]\n\n <DropdownExample items={items} title='show menu' placement='down' anchor='right' />";
    dropupCode = "var items = [\n { title: 'item 1' },\n { title: 'item 2' },\n { title: 'item 3' }\n]\n\n <DropdownExample items={items} title='show menu' placement='up' anchor='left' />";
    popoverCode = "<PopoverButton title='lorem' placement='right'>\n <h2>I'm inside the popover content</h2>\n</PopoverButton>";
    return <div>
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
		</div>;
  }
});

mountNode = document.getElementById('content');

React.renderComponent(<Examples />, mountNode);
