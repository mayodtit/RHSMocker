class Mailcheck2

  DOMAINS = ['yahoo.com', 'google.com', 'hotmail.com', 'gmail.com', 'me.com', 'aol.com', 'mac.com', 'live.com', 'comcast.net', 'googlemail.com', 'msn.com', 'hotmail.co.uk', 'yahoo.co.uk', 'facebook.com', 'verizon.net', 'sbcglobal.net', 'att.net', 'gmx.com', 'mail.com']

  TOP_LEVEL_DOMAINS = ['co.uk', 'com', 'net', 'org', 'info', 'edu', 'gov', 'mil', 'ca']

  def initialize(opts = {})
    @threshold = 3
    @domains = opts[:domains] || DOMAINS
    @top_level_domains = opts[:top_level_domains] || TOP_LEVEL_DOMAINS
  end

  def suggest(email)
    email_parts = split_email(email.downcase)

    if email_parts
      suggest_for_known_address(email_parts)
    else
      suggest_for_unknown_address(email)
    end
  end

  def suggest_for_unknown_address(email)
    @threshold = 5
    len = email.length
    match = Hash.new
    match[:dist] = 99
    (1...len).each do |i|
      address = email[0...i]
      domain = email[i...len]
      result = find_closest_domain(domain, @domains)
      if result[1] != nil && result[1] < match[:dist]
        match[:dist] = result[1]
        match[:address] = address
        match[:domain] = result[0]
      end
    end
    puts match
    puts find_closest_domain('g', @domains)
    if match[:dist] <= @threshold
      return { :address => match[:address], :domain => match[:domain], :full => "#{match[:address]}@#{match[:domain]}" }
    end

    false
  end

  def suggest_for_known_address(email_parts)
    # If there is no top level domain, allow larger room for error
    if email_parts[:top_level_domain] == ''
      @threshold = 4
    end

    closest_domain = find_closest_domain(email_parts[:domain], @domains)[0]

    if closest_domain
      if closest_domain != email_parts[:domain]
        # The email address closely matches one of the supplied domains return a suggestion
        return { :address => email_parts[:address], :domain => closest_domain, :full => "#{email_parts[:address]}@#{closest_domain}" }
      end
    else
      # The email address does not closely match one of the supplied domains
      # First to check if top level domain is empty.  If it is empty, by default assignment it to com.
      if email_parts[:top_level_domain] == ''
        return { :address => email_parts[:address], :domain => email_parts[:domain], :full => email_parts[:address] + '@' + email_parts[:domain] + '.com' }
      end

      closest_top_level_domain = find_closest_domain(email_parts[:top_level_domain], @top_level_domains)[0]

      if email_parts[:domain] && closest_top_level_domain && closest_top_level_domain != email_parts[:top_level_domain]
        # The email address may have a mispelled top-level domain return a suggestion
        domain = email_parts[:domain]
        closest_domain = domain[0, domain.rindex(email_parts[:top_level_domain])] + closest_top_level_domain
        return { :address => email_parts[:address], :domain => closest_domain, :full => "#{email_parts[:address]}@#{closest_domain}" }
      end
    end
    # The email address exactly matches one of the supplied domains, does not closely
    # match any domain and does not appear to simply have a mispelled top-level domain,
    # or is an invalid email address do not return a suggestion.
    false
  end

  def find_closest_domain(domain, domains)
    min_dist = 99
    closest_domain = nil
    return nil if domains.nil? || domains.size == 0

    domains.each do |dmn|
      return [domain, 0] if domain == dmn
      dist = sift_3distance(domain, dmn)
      if dist < min_dist
        min_dist = dist
        closest_domain = dmn
      end
    end

    if min_dist <= @threshold && closest_domain
      [closest_domain, min_dist]
    else
      [nil, nil]
    end
  end

  def sift_3distance(s1, s2)
    # sift3: http:#siderite.blogspot.com/2007/04/super-fast-and-accurate-string-distance.html
    c = 0
    offset1 = 0
    offset2 = 0
    lcs = 0
    max_offset = 5

    while (c + offset1 < s1.length) && (c + offset2 < s2.length) do
      if s1[c + offset1] == s2[c + offset2]
        lcs += 1
      else
        offset1 = 0
        offset2 = 0
        max_offset.times do |i|
          if c + i < s1.length && s1[c + i] == s2[c]
            offset1 = i
            break
          end
          if c + i < s2.length && s1[c] == s2[c + i]
            offset2 = i
            break
          end
        end
      end
      c += 1
    end
    (s1.length + s2.length) / 2.0 - lcs
  end

  def split_email(email)
    parts = email.split('@')

    return false if parts.length < 2 || parts.any?{ |p| p == '' }

    domain = parts.pop
    domain_parts = domain.split('.')
 
    return false if domain_parts.length == 0

    {
      :top_level_domain => domain_parts[1..-1].join('.'),
      :domain => domain,
      :address => parts.first
    }
  end
end