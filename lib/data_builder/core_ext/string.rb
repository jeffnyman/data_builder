class String
  def integer?
    true if Integer(self)
  rescue StandardError
    false
  end
end
