class Child < ApplicationRecord
  belongs_to :group, optional: true
end
