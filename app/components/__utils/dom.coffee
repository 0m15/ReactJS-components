module.exports =
	dom:
		get: (id) ->
			return document.getElementById(id)

		getComputedStyles: (elem) ->
	    return elem.ownerDocument.defaultView.getComputedStyle(elem, null)

		viewport: () ->
			width: window.innerWidth,
			height: window.innerHeight

	  offsetParent: (elem) ->
	    docElem = document.documentElement
	    offsetParent = elem.offsetParent || docElem

	    while offsetParent and offsetParent.nodeName isnt 'HTML' and @getComputedStyles(offsetParent).position is 'static'
	      offsetParent = offsetParent.offsetParent
	    
	    return offsetParent or docElem

		getOffset: (el, position) ->
			docEl = document.documentElement
			box = top: 0, left: 0

			if el.getBoundingClientRect?
				box = el.getBoundingClientRect()

			if position is 'fixed'
				return box

			top: box.top + window.pageYOffset - docEl.clientTop,
			left: box.left + window.pageXOffset - docEl.clientLeft

		getPosition: (elem) ->
			parentOffset = top: 0, left: 0
			
			# Fixed elements are offset from window (parentOffset = top:0, left: 0, 
			# because it is its only offset parent
			if @getComputedStyles(elem).position is 'fixed'
	      # We assume that getBoundingClientRect is available 
	      # when computed position is fixed
	      offset = elem.getBoundingClientRect()
	    else
	      # Get *real* offsetParent
	      offsetParent = @offsetParent elem
	      
	      # Get correct offsets
	      offset = @getOffset elem
	      
	      if offsetParent.nodeName isnt 'HTML'
	        parentOffset = @getOffset(offsetParent)
	      
	      # Add offsetParent borders
	      parentOffset.top += parseInt(@getComputedStyles(offsetParent).borderTopWidth, 10)
	      parentOffset.left += parseInt(@getComputedStyles(offsetParent).borderLeftWidth, 10)
	    
	    # Subtract parent offsets and element margins
	    top: offset.top - parentOffset.top - parseInt(@getComputedStyles(elem).marginTop, 10),
	    left: offset.left - parentOffset.left - parseInt(@getComputedStyles(elem).marginLeft, 10)