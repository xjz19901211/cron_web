module ApplicationHelper
  # %w{users#new works}
  def page_active?(action_routes)
    action_routes.any? do |action_route|
      cname, aname = action_route.split('#')

      if aname
        cname == controller_name && aname == action_name
      else
        cname == controller_name
      end
    end
  end

  def active_class(action_routes)
    page_active?(action_routes) ? 'active' : ''
  end
end
