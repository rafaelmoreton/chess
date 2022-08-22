# frozen_string_literal: true

module Colors
  def black_square(occupant)
    "\u001b[90m #{occupant} \u001b[0m"
  end
  def blue_square(occupant)
    "\u001b[44m #{occupant} \u001b[0m"
  end
end