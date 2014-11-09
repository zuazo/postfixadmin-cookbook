if defined?(ChefSpec)

  [
    :postfixadmin_admin,
    :postfixadmin_alias,
    :postfixadmin_alias_domain,
    :postfixadmin_domain,
    :postfixadmin_mailbox
  ].each do |matcher|
    if ChefSpec.respond_to?(:define_matcher)
      # ChefSpec >= 4.1
      ChefSpec.define_matcher matcher
    elsif defined?(ChefSpec::Runner) &&
          ChefSpec::Runner.respond_to?(:define_runner_method)
      # ChefSpec < 4.1
      ChefSpec::Runner.define_runner_method matcher
    end
  end

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
