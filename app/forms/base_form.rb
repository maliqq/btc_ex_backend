# frozen_string_literal: true

class BaseForm
  include ActiveModel::Model

  def decorated_object
    object.decorate
  end
end
