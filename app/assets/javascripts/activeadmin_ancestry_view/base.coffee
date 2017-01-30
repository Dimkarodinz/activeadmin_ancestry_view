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

  #--- Tree branches
  # find distance btw node and its last child
  verticalBranchDist = (node, lastChild) ->
    dist = $(node).offset().top - $(lastChild).offset().top
    Math.round(Math.abs(dist))

  # pseudoelement line with dynamic height
  pseudoElementProp = (id, height) ->
    "margin-left: 2em; "
    "margin-left: 2em; " +
    "content: ''; " +
    "position: absolute; " +
    "height: #{height}px; " +
    "z-index: -1; " +
    "border: 0.1em solid gray;"

  $('.panel-parent').each ->
    id = $(this).attr('id')
    lastChild = $(this).parent().find(".panel-container[data-last-child=#{id}]")

    if $(lastChild).length
      distance = verticalBranchDist(this, lastChild)
      document.styleSheets[0].addRule(
        "[id='#{id}']::before",
        "#{pseudoElementProp(id, distance)}"
        )