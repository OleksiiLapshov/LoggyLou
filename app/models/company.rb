class Company < ApplicationRecord
  has_many :projects

  def address_lines
    if address_line_1 && address_line_2
      "#{address_line_1}, #{address_line_2}".strip
    else
      "#{address_line_1}#{address_line_2}".strip
    end
  end
end
