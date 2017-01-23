module ActiveadminAncestryView
  module ResourceDSL

    def ancestry_view_index(opt = {}, &block)
      # => add render(partial_opt) to block end
      # => ensure that this action follow to index (rewrite it ?)
      # => do something pretty with options

      partial_opt = { partial: 'activeadmin_ancestry_view/main',
                      locals: { resource: @resource } }
      index_opt   = { as: :block }

      partial_opt.merge!(opt[:partial]) if opt[:partial]
      index_opt.merge!(opt[:index]) if opt[:index]

      config.set_page_presenter :ancestry_view_index, ActiveAdmin::PagePresenter.new(index_opt, &block)
    end
  end
end