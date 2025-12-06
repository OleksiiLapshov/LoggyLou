module ApplicationHelper
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def nav_link(text, path)
    active = current_page?(path)

    classes = "px-4 hover:text-white transition duration-200 "

    classes += active ? "font-bold text-white underline decoration-2 underline-offset-4" : "text-white/80"

    content_tag(:li, class: classes) do
      link_to text, path
    end
  end
end
