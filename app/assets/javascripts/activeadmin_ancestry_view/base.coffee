$(document).on 'ready page:load turbolinks:load', ->
  # get css rule as js object
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

  addCSSRule = (ruleName, properies) ->
    if document.styleSheets
      if !getCSSRule(ruleName)
        if document.styleSheets[0].addRule
          document.styleSheets[0].addRule ruleName, properies, 0
        else
          document.styleSheets[0].insertRule ruleName + " { #{properies} }", 0
  
  # find half height of the node (px)
  middleOfHeight = (node) ->
    Math.abs $(node).height() / 2

  distanceToTop = (node, target) ->
    Math.abs $(node).offset().top - $(target).offset().top

  # find distance btw node and its last child (px)
  verticalBranchDist = (node, lastChild) ->
    distanceToTop(node, lastChild) + middleOfHeight(lastChild)

  baseBranchProp =
    "transition: 150ms ease; " +
    "content: ''; " +
    "position: absolute; " +
    "border: 0.1em solid gray; "

  # vertical line properies with dynamic height
  veticalBranchProp = (height) ->
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

  # creates vertical line :before pseudoelement
  addVerticalLine = (node, purposeNode) ->
    distance = verticalBranchDist(node, purposeNode)
    id       = $(node).attr('id')

    addCSSRule(
      "[id='#{id}']::before",
      veticalBranchProp(distance)
      )

  # creates horizontal line :after pseudoelement
  addHorizontalLine = (node) ->
    id     = $(node).attr('id')
    height = middleOfHeight(node)
    addCSSRule(
      "[id='#{id}']::after",
      horizontalBranchProp(height)
      )

  uptHorizontalLine = (node) ->
    if $(node).hasClass('panel-root')
      false
    else
      id = $(node).attr 'id'
      newHeight = -Math.abs middleOfHeight(node)
      line = getCSSRule('[id="' + id + '"]::after')
      line.style.marginTop = newHeight.toString().concat('px')

  findPanelHeader = (object) ->
    object.find('.panel').find('.panel-header')

  clearAllColors = ->
    $('.panel-header').css('background-color', '')
    $('.panel-header').each ->
      if $(this).hasClass('selectable')
        $(this).removeClass('selectable')

  similarItems = (arr1, arr2) ->
    item for item in arr2 when item in arr1

  getElements = (arrayOfIds) ->
    $.map(arrayOfIds, (id) ->
      $("##{id}").get()
    )
    
  changeVerticalOfEachParent = (nodeToStart) ->
    # find actual parents
    nodeClasses = $(nodeToStart).attr('class').split(' ')
    allParents  = $(nodeToStart).prevAll('.panel-parent')

    parentIds   = $.map(allParents, (el) -> $(el).attr 'id')
    actualIds   = similarItems(nodeClasses, parentIds)

    # add node id to array
    actualIds.push $(nodeToStart).attr('id')
    # ids to array of jquery elements
    actualCollection = getElements(actualIds)

    $.each actualCollection, (i, element) -> updateVerticalLine(element)

  updateVerticalLine = (node) ->
    nodeId = $(node).attr('id')
    lastChild = $(node).parent().find(
      ".panel-container[data-last-child=#{nodeId}]")

    if $(lastChild).length
      newDistance = verticalBranchDist(node, lastChild)
      line = getCSSRule('[id="' + nodeId + '"]::before')
      line.style.height = newDistance.toString().concat('px')

  # inherit color from parent panel on load
  # if parent has no color, inherit from parent of parent
  $('.panel-parent').each ->
    id = $(this).attr('id')
    parentColor = findPanelHeader($(this)).css('background-color')

    $('.panel-childless').each ->
      if $(this).hasClass(id)
        findPanelHeader($(this)).css('background-color', parentColor)

  # show-hide content table of single div
  $('.show-content').click ->
    node    = $(this).parents('.panel-container')
    nodeId  = $(node).attr 'id'
    content = $(this).parent().next('.panel_contents')

    oldNodeHeight = $(node).height()
    verticalLine  = getCSSRule('[id="' + $(node).attr('id') + '"]::before')
    
    if content.is(':hidden')
      content.show 0, -> uptHorizontalLine(node)
    else
      content.hide 0, -> uptHorizontalLine(node)
    changeVerticalOfEachParent(node)

  # show-hide content table for bunch of nodes
  $('.show-childrens').click ->
    nodeId      = $(this).parents('.panel-container').attr('id')
    nodeContent = $(this).parent().next('.panel_contents')
    lastChild   = $(".panel-container[data-last-child=#{nodeId}]")
    lastChildId = $(lastChild).attr('id')

    # NOTE: do not use .toggleClass here
    if nodeContent.is(':hidden') then nodeContent.show() else nodeContent.hide()

    $('.panel').each ->
      subNode = $(this).parent('.panel-container')
      if subNode.hasClass(nodeId)
        content = $(this).find('.panel_contents')

        if nodeContent.is(':visible')
          content.show 0, -> uptHorizontalLine(subNode)
        else
          content.hide 0, -> uptHorizontalLine(subNode)

        subLastChildId = $(subNode).attr 'data-last-child'
        updateVerticalLine $("##{subLastChildId}") if subLastChildId?

    changeVerticalOfEachParent(lastChild)

  # select user
  $('.panel-header').on 'click', ->
    clearAllColors()
    $(this).addClass('selectable')
    # add color to all node's panel headers
    parent_id = $(this).parents('.panel-container').attr('id')
    $('.panel-header').each ->
      if ($(this)).parents('.panel-container').hasClass(parent_id)
        $(this).addClass('selectable')

  # add vertical line to each parent
  $('.panel-parent').each ->
    nodeId    = $(this).attr('id')
    lastChild = $(this).parent().find(
      ".panel-container[data-last-child=#{nodeId}]")

    addVerticalLine(this, lastChild) if $(lastChild).length

  # add horizontal line to each, except root
  $('.panel-container').each ->
    addHorizontalLine(this) unless $(this).hasClass('panel-root')