$(document).on 'ready page:load turbolinks:load', ->
  CSSRule =
    get: (ruleName, deleteFlag) ->
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
    add: (ruleName, properies) ->
      if document.styleSheets
        if !this.get(ruleName)
          if document.styleSheets[0].addRule
            document.styleSheets[0].addRule ruleName, properies, 0
          else
            document.styleSheets[0].insertRule ruleName + " { #{properies} }", 0

  distance =
    middleHeight: (node) ->
      Math.abs $(node).height() / 2

    betweenTop: (sourceNode, targetNode) ->
      Math.abs $(sourceNode).offset().top - $(targetNode).offset().top

    verticalBranch: (node, lastChild) ->
      this.betweenTop(node, lastChild) + this.middleHeight(lastChild)

  branchProp =
    base:
      "transition: 150ms ease; " +
      "content: ''; " +
      "position: absolute; " +
      "border: 0.1em solid gray; "

    vertical: (height) ->
      "margin-left: 2em; " +
      "height: #{height}px; " +
      "z-index: -1; " +
      this.base

    horizontal: (marginTop) ->
      "margin-top: -#{marginTop}px; " +
      "margin-left: -2em; " +
      "width: 2em; " +
      "z-index: -2; " +
      this.base

  pseudoElement =
    addHorizontal: (node) ->
      id     = $(node).attr('id')
      height = distance.middleHeight(node)
      CSSRule.add(
        "[id='#{id}']::after",
        branchProp.horizontal(height)
        )

    addVertical: (node, purposeNode) ->
      dist = distance.verticalBranch(node, purposeNode)
      id   = $(node).attr('id')
      CSSRule.add(
        "[id='#{id}']::before",
        branchProp.vertical(dist)
        )

    uptHorizontal: (node) ->
      if $(node).hasClass('panel-root') then false
      else
        id        = $(node).attr 'id'
        newHeight = -Math.abs distance.middleHeight(node)
        line      = CSSRule.get '[id="' + id + '"]::after'
        line.style.marginTop = newHeight.toString().concat('px')

    uptVertical: (node) ->
      nodeId    = $(node).attr('id')
      lastChild = $(node).parent().find(
        ".panel-container[data-last-child=#{nodeId}]")

      if $(lastChild).length
        newDistance = distance.verticalBranch(node, lastChild)
        line        = CSSRule.get('[id="' + nodeId + '"]::before')
        line.style.height = newDistance.toString().concat('px')

    uptEachVertical: (node) ->
      # find actual parents
      nodeClasses = $(node).attr('class').split(' ')
      allParents  = $(node).prevAll('.panel-parent')
      parentIds   = $.map(allParents, (el) -> $(el).attr 'id')
      actualIds   = similarItems(nodeClasses, parentIds)
      # add current node id
      actualIds.push $(node).attr('id')
      # get array of jquery elements from actual ids
      actualCollection = getElements(actualIds)
      # update vertical pseudoelement of actual elements
      $.each actualCollection, (i, element) ->
        this.uptVertical(element)

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
    verticalLine  = CSSRule.get('[id="' + $(node).attr('id') + '"]::before')
    
    if content.is(':hidden')
      content.show 0, -> pseudoElement.uptHorizontal(node)
    else
      content.hide 0, -> pseudoElement.uptHorizontal(node)
    pseudoelement.uptEachVertical(node)

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
          content.show 0, -> pseudoElement.uptHorizontal(subNode)
        else
          content.hide 0, -> pseudoElement.uptHorizontal(subNode)

        subLastChildId = $(subNode).attr 'data-last-child'
        pseudoElement.uptVertical $("##{subLastChildId}") if subLastChildId?

    pseudoelement.uptEachVertical(lastChild)

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

    pseudoElement.addVertical(this, lastChild) if $(lastChild).length

  # add horizontal line to each, except root
  $('.panel-container').each ->
    pseudoElement.addHorizontal(this) unless $(this).hasClass('panel-root')