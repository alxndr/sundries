class Integer

  def is_prime?
    ('1' * self) !~ /^1?$|^(11+?)\1+$/
  end

end
