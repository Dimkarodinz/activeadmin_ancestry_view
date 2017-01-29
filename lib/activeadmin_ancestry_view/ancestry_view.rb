module AncestryView
  def ancestry_view(action_name = 'index', opt = {}, &block)
    eval active_admin_action(action_name, opt, &block)
    eval active_admin_controller(action_name)
  end

  private

  def active_admin_controller(action_name)
    builder = ActiveadminAncestryView::Finder.get_controller_builder(action_name)
    ActiveadminAncestryView::ControllerGenerator.new(builder).call
  end

  def active_admin_action(action_name, opt = {}, &block)
    builder = ActiveadminAncestryView::Finder.get_action_builder(action_name)
    ActiveadminAncestryView::ActionGenerator.new(builder, opt, &block).call
  end
end