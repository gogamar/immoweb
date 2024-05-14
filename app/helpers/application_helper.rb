module ApplicationHelper

  def tailwind_classes_for(flash_type)
    {
      notice: "rounded-md bg-green-50 p-4 m-1",
      alert: "rounded-md bg-red-50 p-4 m-1",
    }.stringify_keys[flash_type.to_s] || flash_type.to_s
  end

end
