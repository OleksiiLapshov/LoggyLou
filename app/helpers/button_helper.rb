module ButtonHelper
  def icon_text(icon, text, icon_options: {})
    default_options = { variant: :solid, options: { class: "w-4 h-4" } }

    final_options = default_options.deep_merge(icon_options)

    tag.span(class: "flex items-center gap-1") do
      concat heroicon(icon, **final_options)
      concat tag.span(text)
    end
  end

  def new_worklog_button
    link_to new_worklog_path, class: "button-success" do
      icon_text("pencil-square", "New Worklog")
    end
  end

  def login_button
    button_tag(type: "submit", class: "button-success") do
      icon_text("arrow-right-on-rectangle", "Sign In")
    end
  end

  def filter_button
    button_tag(type: "submit", class: "button") do
      icon_text("funnel", "Filter")
    end
  end

  def back_button(path = :back)
    link_to path, class: "button-secondary" do
      icon_text("arrow-left", "Back")
    end
  end
end
