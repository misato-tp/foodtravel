module ApplicationHelper
  def bootstrap_flash_class(key)
    case key.to_sym
    when :notice
      "success"
    when :alert, :error
      "danger"
    else
      "secondary"
    end
  end
end
