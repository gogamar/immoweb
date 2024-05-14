module ApplicationHelper

  def tailwind_classes_for(flash_type)
    {
      notice: "rounded-md bg-green-50 p-4 m-1",
      alert: "rounded-md bg-red-50 p-4 m-1",
    }.stringify_keys[flash_type.to_s] || flash_type.to_s
  end

  def language_dropdown(current_locale)
    content_tag(:li, class: 'nav-item dropdown language-dropdown') do
      concat(link_to("#", class: 'nav-link dropdown-toggle', id: 'languageDropdown', data: { bs_toggle: 'dropdown' }, 'aria-haspopup': true, 'aria-expanded': false) do
        content_tag(:small) do
          concat(" #{t(current_locale)}")
        end
      end)

      concat(content_tag(:ul, class: 'dropdown-menu dropdown-menu-end', 'aria-labelledby': 'languageDropdown') do
        (I18n.available_locales - [current_locale]).each do |locale|
          query_params = params.except(:locale).permit!.to_h
          locale_path = url_for(locale: locale.to_s, **query_params)
          concat(content_tag(:li) do
            concat(link_to(locale_path, class: 'dropdown-item') do
              concat(" #{t(locale)}")
            end)
          end)
        end
      end)
    end
  end
end
