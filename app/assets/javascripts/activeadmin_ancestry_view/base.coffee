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
      @betweenTop(node, lastChild) + @middleHeight(lastChild)

  branchProp =
    baseMargin: 2 #em
    base:
      "transition: 150ms ease; " +
      "content: ''; " +
      "position: absolute; " +
      "border: 0.1em solid gray; "

    vertical: (height) ->
      "margin-left: #{@baseMargin}em; " +
      "height: #{height}px; " +
      "z-index: -1; " +
      @base

    horizontal: (marginTop, marginLeft) ->
      "margin-top: -#{marginTop}px; " +
      "margin-left: -#{marginLeft - @baseMargin}em; " +
      "width: #{marginLeft - @baseMargin}em; " +
      "z-index: -2; " +
      @base

  pseudoElement =
    addHorizontal: (node) ->
      id     = $(node).attr('id')
      height = distance.middleHeight(node)
      marginLeft = $(node).attr('data-shift-multiplicator')
      CSSRule.add(
        "[id='#{id}']::after",
        branchProp.horizontal(height, marginLeft)
      )

    addVertical: (node, purposeNode) ->
      dist = distance.verticalBranch(node, purposeNode)
      id   = $(node).attr('id')
      CSSRule.add "[id='#{id}']::before", branchProp.vertical(dist)

    updHorizontal: (node) ->
      if $(node).hasClass('panel-root') then false
      else
        id        = $(node).attr 'id'
        newHeight = -Math.abs distance.middleHeight(node)
        line      = CSSRule.get '[id="' + id + '"]::after'
        line.style.marginTop = newHeight.toString().concat('px')

    updVertical: (node) ->
      nodeId    = $(node).attr('id')
      lastChild = $(node).parent().find(
        ".panel-container[data-last-child=#{nodeId}]")

      if $(lastChild).length
        newDistance = distance.verticalBranch(node, lastChild)
        line        = CSSRule.get('[id="' + nodeId + '"]::before')
        line.style.height = newDistance.toString().concat('px')

    updEachVertical: (node) ->
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
      that = this
      $.each(actualCollection, (i, element) ->
        that.updVertical(element)
      )

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
    $.map arrayOfIds, (id) -> $("##{id}").get()

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
      content.show 0, -> pseudoElement.updHorizontal(node)
    else
      content.hide 0, -> pseudoElement.updHorizontal(node)
    pseudoElement.updEachVertical(node)

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
          content.show 0, -> pseudoElement.updHorizontal(subNode)
        else
          content.hide 0, -> pseudoElement.updHorizontal(subNode)
        subLastChildId = $(subNode).attr 'data-last-child'
        pseudoElement.updVertical $("##{subLastChildId}") if subLastChildId?

    pseudoElement.updEachVertical(lastChild)

  # select user
  $('.panel-header').on 'click', ->
    clearAllColors()
    $(this).addClass('selectable')
    parentId = $(this).parents('.panel-container').attr('id')

    $('.panel-header').each ->
      if ($(this)).parents('.panel-container').hasClass(parentId)
        $(this).addClass('selectable')

  # add vertical line to each .panel-parent
  $('.panel-parent').each ->
    nodeId    = $(this).attr('id')
    lastChild = $(this).parent().find(
      ".panel-container[data-last-child=#{nodeId}]")

    pseudoElement.addVertical(this, lastChild) if $(lastChild).length

  $('.panel-container').each ->
    # $(this).css('margin-left', $(this).attr('data-panel-shift') + 'em' )
    pseudoElement.addHorizontal(this) unless $(this).hasClass('panel-root')