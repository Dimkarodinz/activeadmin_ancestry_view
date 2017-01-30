$(document).on 'ready page:load turbolinks:load', ->
  findPanelHeader = (object) ->
    object.find('.panel').find('.panel-header')

  clearAllColors = ->
    $('.panel-header').css('background-color', '')
    $('.panel-header').each ->
      if $(this).hasClass('selectable')
        $(this).removeClass('selectable')

  # inherit color from parent panel on load
  # if parent has no color, inherit from parent of parent
  $('.panel-parent').each ->
    id = $(this).attr('id')
    parentColor = findPanelHeader($(this)).css('background-color')

    $('.panel-childless').each ->
      if $(this).hasClass(id)
        findPanelHeader($(this)).css('background-color', parentColor)

  # show-hide single div
  $('.show-content').click ->
    content = $(this).parent().next('.panel_contents')
    if content.is(':hidden')
      content.show('fast')

      nodeId = $(this).parents('.panel-container').attr('id')
      console.log document.styleSheets[0].cssRules[0]

      # console.log verticalLine
      # verticalLine = getCSSRule("[id='#{nodeId}']::before")
      # verticalLine.style.height = '100px'
    else
      content.hide('fast')

  # show-hide nodes
  $('.show-childrens').click ->
    parent_id = $(this).parents('.panel-container').attr('id')
    parent_content = $(this).parent().next('.panel_contents')
    # NOTE: do not use .toggleClass here
    if parent_content.is(':hidden')
      parent_content.show()
    else
      parent_content.hide()

    # show-hide subtree panels
    $('.panel').each ->
      if ($(this)).parent('.panel-container').hasClass(parent_id)
        content = $(this).find('.panel_contents')
        if parent_content.is(':visible') then content.show() else content.hide()

  # select user
  $('.panel-header').on 'click', ->
    clearAllColors()
    $(this).addClass('selectable')
    # add color to all node's panel headers
    parent_id = $(this).parents('.panel-container').attr('id')
    $('.panel-header').each ->
      if ($(this)).parents('.panel-container').hasClass(parent_id)
        $(this).addClass('selectable')

  #--- Tree branches ---

  # find middle of node
  middleOfHeight = (node) ->
    Math.abs $(node).height() / 2

  distanceToTop = (node, target) ->
    Math.abs $(node).offset().top - $(target).offset().top

  # find distance btw node and its last child
  verticalBranchDist = (node, lastChild) ->
    distanceToTop(node, lastChild) + middleOfHeight(node)

  baseBranchProp =
    "content: ''; " +
    "position: absolute; " +
    "border: 0.1em solid gray; "

  # vertical line properies with dynamic height
  veticalBranchProp = (id, height) ->
    "margin-left: 2em; " +
    "height: #{height}px; " +
    "z-index: -1; " +
    baseBranchProp

  # horizontal line properies with dynamic parameters
  horizontalBranchProp = (height) ->
    "margin-top: -#{height}px; " +
    "margin-left: -2em; " +
    "width: 2em; " +
    "z-index: -2; " +
    baseBranchProp

  # add vertical line ( :before pseudoelement) to panel which has children
  addVerticalLine = (node) ->
    id        = $(node).attr 'id'
    lastChild = $(node).parent().find ".panel-container[data-last-child=#{id}]"

    if $(lastChild).length
      distance = verticalBranchDist(node, lastChild)
      document.styleSheets[0].addRule(
        "[id='#{id}']::before",
        "#{veticalBranchProp(id, distance)}"
        )

  # add horizontal line (:after pseudoelement) to all panels except root
  addHorizontalLine = (node) ->
    if $(node).hasClass('panel-root')
      true
    else
      id = $(node).attr('id')
      height = middleOfHeight(node)
      document.styleSheets[0].addRule(
        "[id='#{id}']::after",
        "#{horizontalBranchProp(height)}"
        )

  $('.panel-parent').each ->
    addVerticalLine(this)

  $('.panel-container').each ->
    addHorizontalLine(this)

  getCSSRule = (ruleName, deleteFlag) ->
    ruleName = ruleName.toLowerCase()
    if document.styleSheets
      i = 0
      while i < document.styleSheets.length
        styleSheet = document.styleSheets[i]
        ii = 0
        cssRule = false
        loop
          if styleSheet.cssRules
            cssRule = styleSheet.cssRules[ii]
          else
            cssRule = styleSheet.rules[ii]
          if cssRule
            if cssRule.selectorText.toLowerCase() == ruleName
              if deleteFlag == 'delete'
                if styleSheet.cssRules
                  styleSheet.deleteRule ii
                else
                  styleSheet.removeRule ii
                return true
              else
                return cssRule
          ii++
          unless cssRule
            break
        i++
    false

  killCSSRule = (ruleName) ->
    getCSSRule ruleName, 'delete'

  addCSSRule = (ruleName) ->
    if document.styleSheets
      if !getCSSRule(ruleName)
        if document.styleSheets[0].addRule
          document.styleSheets[0].addRule ruleName, null, 0
        else
          document.styleSheets[0].insertRule ruleName + ' { }', 0
    getCSSRule ruleName