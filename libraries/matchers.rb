if defined?(ChefSpec)

  def create_postfixadmin_admin(user)
    ChefSpec::Matchers::ResourceMatcher.new(
      :postfixadmin_admin, :create, user
    )
  end

  def remove_postfixadmin_admin(user)
    ChefSpec::Matchers::ResourceMatcher.new(
      :postfixadmin_admin, :remove, user
    )
  end

  def create_postfixadmin_alias(address)
    ChefSpec::Matchers::ResourceMatcher.new(
      :postfixadmin_alias, :create, address
    )
  end

  def create_postfixadmin_alias_domain(alias_domain)
    ChefSpec::Matchers::ResourceMatcher.new(
      :postfixadmin_alias_domain, :create, alias_domain
    )
  end

  def create_postfixadmin_domain(domain)
    ChefSpec::Matchers::ResourceMatcher.new(
      :postfixadmin_domain, :create, domain
    )
  end

  def create_postfixadmin_mailbox(mailbox)
    ChefSpec::Matchers::ResourceMatcher.new(
      :postfixadmin_mailbox, :create, mailbox
    )
  end

end
