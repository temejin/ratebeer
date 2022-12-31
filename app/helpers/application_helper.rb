module ApplicationHelper
  def edit_and_destroy_buttons(item)
    edit = link_to('Edit', url_for([:edit, item]), class: "btn btn-primary")
    del = link_to('Destroy', item, method: :delete,
                                   form: { data: { turbo_confirm: "Are you sure ?" } },
                                   class: "btn btn-danger")
    raw("#{edit} #{del}") unless current_user.nil?
  end

  def round(number)
    number.round(1)
  end
end
