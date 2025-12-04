module SubmissionsHelper
  def status_badge(status)
    color_classes = case status
                    when "draft"
                      "bg-amber-300 text-amber-800 dark:bg-amber-700/70 dark:text-amber-200"
                    when "approved"
                      "bg-green-300 text-green-800 dark:bg-green-700/70 dark:text-green-200"
                    when "rejected"
                      "bg-red-300 text-red-800 dark:bg-red-700/70 dark:text-red-200"
                    else
                      "bg-gray-100 text-gray-800 dark:bg-gray-700 dark:text-gray-300"
                    end

    tag.span(status.humanize, class: "px-2 py-1 rounded-md text-xs font-medium #{color_classes}")
  end
end
