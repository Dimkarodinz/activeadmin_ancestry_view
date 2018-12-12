$(document).ready(function() {
  var CSSRule, branchProp, clearAllColors, distance, findPanelHeader, getElements, pseudoElement, similarItems;
  CSSRule = {
    get: function(ruleName, deleteFlag) {
      var cssRule, i, ii, styleSheet;
      ruleName = ruleName.toLowerCase();
      if (document.styleSheets) {
        i = 0;
        while (i < document.styleSheets.length) {
          styleSheet = document.styleSheets[i];
          ii = 0;
          cssRule = false;
          while (true) {
            if (styleSheet.cssRules) {
              cssRule = styleSheet.cssRules[ii];
            } else {
              cssRule = styleSheet.rules[ii];
            }
            if (cssRule) {
              if (cssRule.selectorText.toLowerCase() === ruleName) {
                if (deleteFlag === 'delete') {
                  if (styleSheet.cssRules) {
                    styleSheet.deleteRule(ii);
                  } else {
                    styleSheet.removeRule(ii);
                  }
                  return true;
                } else {
                  return cssRule;
                }
              }
            }
            ii++;
            if (!cssRule) {
              break;
            }
          }
          i++;
        }
      }
      return false;
    },
    add: function(ruleName, properies) {
      if (document.styleSheets) {
        if (!this.get(ruleName)) {
          if (document.styleSheets[0].addRule) {
            return document.styleSheets[0].addRule(ruleName, properies, 0);
          } else {
            return document.styleSheets[0].insertRule(ruleName + (" { " + properies + " }"), 0);
          }
        }
      }
    }
  };
  distance = {
    middleHeight: function(node) {
      return Math.abs($(node).height() / 2);
    },
    betweenTop: function(sourceNode, targetNode) {
      return Math.abs($(sourceNode).offset().top - $(targetNode).offset().top);
    },
    verticalBranch: function(node, lastChild) {
      return this.betweenTop(node, lastChild) + this.middleHeight(lastChild);
    }
  };
  branchProp = {
    baseMargin: 2,
    base: "transition: 150ms ease; " + "content: ''; " + "position: absolute; " + "border: 0.1em solid gray; ",
    vertical: function(height) {
      return ("margin-left: " + this.baseMargin + "em; ") + ("height: " + height + "px; ") + "z-index: -1; " + this.base;
    },
    horizontal: function(marginTop, marginLeft) {
      return ("margin-top: -" + marginTop + "px; ") + ("margin-left: -" + (marginLeft - this.baseMargin) + "em; ") + ("width: " + (marginLeft - this.baseMargin) + "em; ") + "z-index: -2; " + this.base;
    }
  };
  pseudoElement = {
    addHorizontal: function(node) {
      var height, id, marginLeft;
      id = $(node).attr('id');
      height = distance.middleHeight(node);
      marginLeft = $(node).attr('data-shift-multiplicator');
      return CSSRule.add("[id='" + id + "']::after", branchProp.horizontal(height, marginLeft));
    },
    addVertical: function(node, purposeNode) {
      var dist, id;
      dist = distance.verticalBranch(node, purposeNode);
      id = $(node).attr('id');
      return CSSRule.add("[id='" + id + "']::before", branchProp.vertical(dist));
    },
    updHorizontal: function(node) {
      var id, line, newHeight;
      if ($(node).hasClass('panel-root')) {
        return false;
      } else {
        id = $(node).attr('id');
        newHeight = -Math.abs(distance.middleHeight(node));
        line = CSSRule.get('[id="' + id + '"]::after');
        return line.style.marginTop = newHeight.toString().concat('px');
      }
    },
    updVertical: function(node) {
      var lastChild, line, newDistance, nodeId;
      nodeId = $(node).attr('id');
      lastChild = $(node).parent().find(".panel-container[data-last-child=" + nodeId + "]");
      if ($(lastChild).length) {
        newDistance = distance.verticalBranch(node, lastChild);
        line = CSSRule.get('[id="' + nodeId + '"]::before');
        return line.style.height = newDistance.toString().concat('px');
      }
    },
    updEachVertical: function(node) {
      var actualCollection, actualIds, allParents, nodeClasses, parentIds, that;
      nodeClasses = $(node).attr('class').split(' ');
      allParents = $(node).prevAll('.panel-parent');
      parentIds = $.map(allParents, function(el) {
        return $(el).attr('id');
      });
      actualIds = similarItems(nodeClasses, parentIds);
      actualIds.push($(node).attr('id'));
      actualCollection = getElements(actualIds);
      that = this;
      return $.each(actualCollection, function(i, element) {
        return that.updVertical(element);
      });
    }
  };
  findPanelHeader = function(object) {
    return object.find('.panel').find('.panel-header');
  };
  clearAllColors = function() {
    $('.panel-header').css('background-color', '');
    return $('.panel-header').each(function() {
      if ($(this).hasClass('selectable')) {
        return $(this).removeClass('selectable');
      }
    });
  };
  similarItems = function(arr1, arr2) {
    var item, _i, _len, _results;
    _results = [];
    for (_i = 0, _len = arr2.length; _i < _len; _i++) {
      item = arr2[_i];
      if (__indexOf.call(arr1, item) >= 0) {
        _results.push(item);
      }
    }
    return _results;
  };
  getElements = function(arrayOfIds) {
    return $.map(arrayOfIds, function(id) {
      return $("#" + id).get();
    });
  };
  $('.panel-parent').each(function() {
    var id, parentColor;
    id = $(this).attr('id');
    parentColor = findPanelHeader($(this)).css('background-color');
    return $('.panel-childless').each(function() {
      if ($(this).hasClass(id)) {
        return findPanelHeader($(this)).css('background-color', parentColor);
      }
    });
  });
  $('.show-content').click(function() {
    var content, node, nodeId, oldNodeHeight, verticalLine;
    node = $(this).parents('.panel-container');
    nodeId = $(node).attr('id');
    content = $(this).parent().next('.panel_contents');
    oldNodeHeight = $(node).height();
    verticalLine = CSSRule.get('[id="' + $(node).attr('id') + '"]::before');
    if (content.is(':hidden')) {
      content.show(0, function() {
        return pseudoElement.updHorizontal(node);
      });
    } else {
      content.hide(0, function() {
        return pseudoElement.updHorizontal(node);
      });
    }
    return pseudoElement.updEachVertical(node);
  });
  $('.show-childrens').click(function() {
    var lastChild, lastChildId, nodeContent, nodeId;
    nodeId = $(this).parents('.panel-container').attr('id');
    nodeContent = $(this).parent().next('.panel_contents');
    lastChild = $(".panel-container[data-last-child=" + nodeId + "]");
    lastChildId = $(lastChild).attr('id');
    if (nodeContent.is(':hidden')) {
      nodeContent.show();
    } else {
      nodeContent.hide();
    }
    $('.panel').each(function() {
      var content, subLastChildId, subNode;
      subNode = $(this).parent('.panel-container');
      if (subNode.hasClass(nodeId)) {
        content = $(this).find('.panel_contents');
        if (nodeContent.is(':visible')) {
          content.show(0, function() {
            return pseudoElement.updHorizontal(subNode);
          });
        } else {
          content.hide(0, function() {
            return pseudoElement.updHorizontal(subNode);
          });
        }
        subLastChildId = $(subNode).attr('data-last-child');
        if (subLastChildId != null) {
          return pseudoElement.updVertical($("#" + subLastChildId));
        }
      }
    });
    return pseudoElement.updEachVertical(lastChild);
  });
  $('.panel-header').on('click', function() {
    var parentId;
    clearAllColors();
    $(this).addClass('selectable');
    parentId = $(this).parents('.panel-container').attr('id');
    return $('.panel-header').each(function() {
      if (($(this)).parents('.panel-container').hasClass(parentId)) {
        return $(this).addClass('selectable');
      }
    });
  });
  $('.panel-parent').each(function() {
    var lastChild, nodeId;
    nodeId = $(this).attr('id');
    lastChild = $(this).parent().find(".panel-container[data-last-child=" + nodeId + "]");
    if ($(lastChild).length) {
      return pseudoElement.addVertical(this, lastChild);
    }
  });
  return $('.panel-container').each(function() {
    if (!$(this).hasClass('panel-root')) {
      return pseudoElement.addHorizontal(this);
    }
  });
});
