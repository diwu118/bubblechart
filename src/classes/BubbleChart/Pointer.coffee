class BubbleChart.Pointer
  constructor: () ->
    @current = null
    @bubble = null
    @diff = null
    @moving = false
    @dragging = false

    self = @
    @e_move = do ->
      stop = null
      (e) ->
        clearTimeout stop
        self.current = self.getPosition(e)
        self.moving = true
        if self.grabbingBubble()
          e.preventDefault()
          self.dragging = true
        stop = setTimeout (=> self.moving = false), 50

    @e_grab = (e) ->
      if self.bubble?
        e.preventDefault()
        self.bubble.grabbed = true
        self.diff = self.current.diff self.bubble.position
        self.current = null

    @e_release = (e) ->
      if self.bubble?
        e.preventDefault()
        self.bubble.grabbed = false
        self.diff = null
        unless self.dragging
          if window? and self.bubble.href?
            window.location.href = self.bubble.href
        self.dragging = false

  grabbingBubble: ->
    @bubble? and @bubble.grabbed

  getPixelRatio: (c) ->
    ratio = 1
    if window.devicePixelRatio? and c.context.webkitBackingStorePixelRatio < 2
        ratio = window.devicePixelRatio
    ratio

  getPosition: (e) ->
    canvas = e.target or e.srcElement
    boundingRect = canvas.getBoundingClientRect()
    pr = @getPixelRatio(canvas)
    if e.touches && e.touches.length > 0
      x = e.touches[0].pageX - boundingRect.left
      y = e.touches[0].pageY - boundingRect.top
    else
      x = e.pageX - boundingRect.left
      y = e.pageY - boundingRect.top
    new BubbleChart.Point(x * pr, y * pr)