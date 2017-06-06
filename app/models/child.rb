class Child < ApplicationRecord
  belongs_to :group, optional: true
  belongs_to :parent
end
