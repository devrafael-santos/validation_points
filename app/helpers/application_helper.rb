module ApplicationHelper
  def user_avatar(user, size_class: "w-8 h-8 text-xs")
    if user.avatar.attached?
      image_tag user.avatar, class: "#{size_class} rounded-full object-cover ring-1 ring-color shrink-0"
    else
      content_tag :div, user.name.first.upcase,
        class: "#{size_class} rounded-full bg-indigo-600 text-white flex items-center justify-center font-bold shrink-0 shadow-xs"
    end
  end
end
