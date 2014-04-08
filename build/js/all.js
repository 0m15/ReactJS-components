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

var Carousel, CarouselControls, CarouselItem, PropTypes, ReactCSSTransitionGroup, ReactTransitionGroup, classSet;

classSet = React.addons.classSet;

ReactCSSTransitionGroup = React.addons.CSSTransitionGroup;

ReactTransitionGroup = React.addons.TransitionGroup;

PropTypes = React.PropTypes;

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
  getInitialState: function() {
    return {
      classes: {
        'carousel-item': true
      },
      style: {
        'margin-left': 0
      }
    };
  },
  propTypes: {
    item: PropTypes.object,
    itemComponent: PropTypes.component
  },
  componentDidMount: function() {
    return this.setup();
  },
  setup: function() {
    var self;
    this.reflow();
    self = this;
    return $(this.getDOMNode()).on('transitionend MSTransitionEnd webkitTransitionEnd oTransitionEnd', function() {
      return self.props.onSlide();
    });
  },
  reflow: function() {
    var el, elWidth, left, style;
    el = this.getDOMNode();
    elWidth = $(el).width();
    left = (this.props.index - 1) * elWidth;
    style = this.state.style;
    style.left = left + 'px';
    return this.setState({
      style: style
    });
  },
  render: function() {
    var classes, style;
    classes = classSet(this.state.classes);
    style = this.state.style;
    return <div className={classes} style={style}>
			{this.props.itemComponent({item: this.props.item})}
		</div>;
  }
});

Carousel = React.createClass({
  propTypes: {
    items: PropTypes.array,
    itemComponent: PropTypes.component
  },
  getInitialState: function() {
    return {
      index: 0,
      activeItems: this.props.items,
      direction: 'forward',
      sliding: false,
      enabled: false
    };
  },
  componentDidMount: function() {
    var self;
    this.setup();
    self = this;
    return $(window).on('resize', this.handleWindowResize);
  },
  _getViewportWidth: function() {
    return $(this.getDOMNode()).width();
  },
  _getSlides: function() {
    return $(this.getDOMNode()).find('.carousel-item');
  },
  _getSlidesActualWidth: function(index) {
    var $item, totalWidth;
    if (index == null) {
      index = this.state.index;
    }
    totalWidth = 0;
    $item = null;
    this._getSlides().slice(index).each(function() {
      $item = $(this);
      return totalWidth += $item.width();
    });
    return totalWidth;
  },
  hasNext: function() {
    var totalWidth, viewportWidth;
    viewportWidth = this._getViewportWidth();
    totalWidth = this._getSlidesActualWidth();
    return totalWidth > viewportWidth;
  },
  hasPrevious: function() {
    return parseInt(this._getSlides()[0].style['margin-left']) < 0;
  },
  setup: function() {
    var enabled, itemsWidth, self, viewportWidth;
    self = this;
    itemsWidth = 0;
    viewportWidth = this._getViewportWidth();
    itemsWidth = this._getSlidesActualWidth(0);
    enabled = itemsWidth > viewportWidth;
    return this.setState({
      enabled: enabled
    });
  },
  reset: function() {
    return this._getSlides().each(function() {
      return $(this).css('margin-left', 0);
    });
  },
  slideTo: function(index, direction) {
    var $items, exceedingWidth, newOffset, self, sliding;
    if (!this.state.enabled) {
      return false;
    }
    if (direction === 'forward' && !this.hasNext()) {
      return false;
    }
    if (direction === 'backward' && !this.hasPrevious()) {
      return false;
    }
    if (this.state.sliding) {
      return false;
    }
    self = this;
    exceedingWidth = 0;
    newOffset = 0;
    sliding = true;
    $items = this._getSlides().each(function() {
      var $item, itemWidth, lastOffsetLeft, offsetLeft;
      $item = $(this);
      itemWidth = $item.width();
      lastOffsetLeft = parseInt($item.css('margin-left').replace('px', ''));
      offsetLeft = index * itemWidth;
      if (direction === 'backward') {
        newOffset = lastOffsetLeft + $item.width();
        if (lastOffsetLeft % itemWidth !== 0) {
          newOffset = lastOffsetLeft - newOffset;
        }
        if (lastOffsetLeft === 0) {
          index = 0;
          newOffset = 0;
          return sliding = false;
        }
      } else {
        newOffset = lastOffsetLeft - $item.width();
        exceedingWidth = self._getSlidesActualWidth() - self._getViewportWidth();
        if (exceedingWidth < $item.width()) {
          return newOffset = lastOffsetLeft - exceedingWidth;
        }
      }
    });
    this.setState({
      index: index,
      direction: direction,
      sliding: sliding
    });
    return $items.css('margin-left', newOffset);
  },
  handleOnSlide: function() {
    return this.setState({
      sliding: false
    });
  },
  handleNext: function(e) {
    var index;
    e.preventDefault();
    index = this.state.index;
    index += 1;
    if (index === this.props.items.length) {
      index = this.props.items.length;
    }
    return this.slideTo(index, 'forward');
  },
  handlePrevious: function(e) {
    var index;
    e.preventDefault();
    index = this.state.index;
    index -= 1;
    if (index < 0) {
      index = 0;
    }
    return this.slideTo(index, 'backward');
  },
  handleWindowResize: function(e) {
    var self;
    this.setup();
    self = this;
    return this.state.activeItems.forEach(function(item) {
      var ref;
      ref = self.refs["item" + item.key];
      return ref.reflow();
    });
  },
  render: function() {
    var children, self;
    self = this;
    children = this.state.activeItems.map(function(item, i) {
      return <CarouselItem
				item={item}
				index={item.key}
				currentIndex={self.state.index}
				key={item.key}
				direction={self.state.direction}
				active={i==self.state.index}
				itemComponent={self.props.itemComponent}
				ref={'item'+item.key}
				onSlide={self.handleOnSlide}
			/>;
    });
    return <div className={"carousel " + this.state.direction}>
				{children}
			<CarouselControls enabled={this.state.enabled} onNext={this.handleNext} onPrevious={this.handlePrevious}/>
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
  }, {
    'title': 'item 4',
    'img': 'http://placehold.it/400x400',
    'key': 4
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
