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


  def include_resources
    include_controller_js +
      include_controller_css +
      include_action_js +
      include_action_css
  end

  JS_ROOT = Rails.root.join('app/assets/javascripts')
  def include_controller_js
    if Dir[JS_ROOT.join("#{controller_resource_filename}.*")].count > 0
      javascript_include_tag controller_resource_filename, 'data-turbolinks-track' => true
    else
      "".html_safe
    end
  end

  CSS_ROOT = Rails.root.join('app/assets/stylestyles')
  def include_controller_css
    if Dir[CSS_ROOT.join("#{controller_resource_filename}.*")].count > 0
      stylesheet_link_tag controller_resource_filename, {
        media: 'all', 'data-turbolinks-track' => true
      }
    else
      "".html_safe
    end
  end

  def include_action_js
    if Rails.application.assets.find_asset("#{action_resource_filename}.js")
      javascript_include_tag action_resource_filename, 'data-turbolinks-track' => true
    else
      "".html_safe
    end
  end

  def include_action_css
    if Rails.application.assets.find_asset("#{action_resource_filename}.css")
      stylesheet_link_tag action_resource_filename, {
        media: 'all', 'data-turbolinks-track' => true
      }
    else
      "".html_safe
    end
  end


  private

  def action_resource_filename
    @_action_resource_filename ||= "#{controller_name}_#{action_name}"
  end

  def controller_resource_filename
    @_controller_resource_filename ||= controller_name
  end

end
