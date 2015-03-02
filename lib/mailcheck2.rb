require 'mailcheck'

class Mailcheck2 < Mailcheck

  #email suggestion is divided into 2 categories: 
  #1. the address is known
  #2. the address is unknown
  def suggest(email)
    email_parts = split_email(email.downcase)
    if email_parts
      @threshold = 3
      suggest_for_known_address(email_parts)
    else
      suggest_for_unknown_address(email)
    end
  end

  #For unknown addresses, a heuristic is used to determine a suitable fit
  def suggest_for_unknown_address(email)
    len = email.length
    @threshold = 99
    match = {dist: 99}

    (1...len).each do |i|
      address = email[0...i]
      domain = email[i...len]
      result = find_closest_domain(domain, @domains)
      if result[:min_dist] != nil && (result[:min_dist] + i * 0.05 < match[:dist])
        match[:dist] = result[:min_dist]
        match[:address] = address
        match[:domain] = result[:closest_domain]
      end
    end

    if match[:domain]
      return { :suggestion => { :address => match[:address], :domain => match[:domain], :full => "#{match[:address]}@#{match[:domain]}" }}
    end

    nil
  end

  def suggest_for_known_address(email_parts)
    # If there is no top level domain, allow larger room for error
    if email_parts[:top_level_domain] == ''
      @threshold = 4
    end

    closest_domain = find_closest_domain(email_parts[:domain], @domains)[:closest_domain]

    if closest_domain && closest_domain != email_parts[:domain]
        # The email address closely matches one of the supplied domains return a suggestion
      return { :suggestion => { :address => email_parts[:address], :domain => closest_domain, :full => "#{email_parts[:address]}@#{closest_domain}" }}
    else
      # The email address does not closely match one of the supplied domains
      # First to check if top level domain is empty.  If it is empty, by default assignment it to com.
      if email_parts[:top_level_domain] == ''
        return { :suggestion => { :address => email_parts[:address], :domain => email_parts[:domain], :full => email_parts[:address] + '@' + email_parts[:domain] + '.com' }}
      end

      closest_top_level_domain = find_closest_domain(email_parts[:top_level_domain], @top_level_domains)[:closest_domain]
      if email_parts[:domain] && closest_top_level_domain && closest_top_level_domain != email_parts[:top_level_domain]
        # The email address may have a mispelled top-level domain return a suggestion
        domain = email_parts[:domain]
        closest_domain = domain[0, domain.rindex(email_parts[:top_level_domain])] + closest_top_level_domain
        return { :suggestion => { :address => email_parts[:address], :domain => closest_domain, :full => "#{email_parts[:address]}@#{closest_domain}" }}
      end
    end
    # The email address exactly matches one of the supplied domains, does not closely
    # match any domain and does not appear to simply have a mispelled top-level domain,
    # or is an invalid email address do not return a suggestion.
    nil
  end

  def find_closest_domain(domain, domains)
    min_dist = 99
    closest_domain = nil
    return nil if domains.nil? || domains.size == 0

    domains.each do |dmn|
      return {closest_domain: domain, min_dist: 0} if domain == dmn
      dist = sift_3distance(domain, dmn)
      if dist < min_dist
        min_dist = dist
        closest_domain = dmn
      end
    end

    if min_dist <= @threshold && closest_domain
      {closest_domain: closest_domain, min_dist: min_dist}
    else
      {closest_domain: nil, min_dist: nil}
    end
  end
end